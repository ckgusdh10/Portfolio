#include "User.h"
#include "../Util/ErrorUtil.h"

CUser::CUser():PacketSize(0),PrevPacketSize(0),Connected(false), CurCharacter(CHARACTER::WARRIOR),Index(0),IsInvincible(false)
{
	ZeroMemory(&Exover.WSAOVER, sizeof(WSAOVERLAPPED));
	Exover.WsaBuf.buf = Exover.IO_Buf;
	Exover.WsaBuf.len = sizeof(Exover.IO_Buf);
	Exover.IO_Type = IO_RECV;
	ViewList.clear();
}

CUser::~CUser()
{
	closesocket(mSock);
	mSock = NULL;
}

void CUser::R_Recv()
{
	unsigned long flag = 0;
	//WSAOVER �ʱ�ȭ 
	ZeroMemory(&Exover.WSAOVER, sizeof(WSAOVERLAPPED));
	if (0 != WSARecv(mSock, &Exover.WsaBuf, 1, NULL, &flag, &Exover.WSAOVER, NULL)) {
		if (WSA_IO_PENDING != WSAGetLastError())
			ErrorUtil::Err_Display("Start RECV");
	}
}

char* CUser::Process(int data_size, char* io_ptr)
{

	int Work_Size = data_size;
	char* IO_Ptr = io_ptr;

	while (0 < Work_Size) {
		int p_size;
		if (0 != PacketSize)
			p_size = PacketSize;
		else {
			p_size = IO_Ptr[0];
			PacketSize = p_size;
		}
		int need_size = p_size - PrevPacketSize;
		if (need_size <= Work_Size) {
			memcpy(Packet
				+ PrevPacketSize, IO_Ptr, need_size);
			PrevPacketSize = 0;
			PacketSize = 0;
			Work_Size -= need_size;
			IO_Ptr += need_size;
			return Packet;

		}
		else {
			memcpy(Packet + PrevPacketSize, IO_Ptr, Work_Size);
			PrevPacketSize += Work_Size;
			Work_Size = -Work_Size;
			IO_Ptr += Work_Size;
		}
	}
	return NULL;
}

void CUser::Reset()
{
	PacketSize = 0;
	PrevPacketSize = 0;
	ZeroMemory(&Exover.WSAOVER, sizeof(WSAOVERLAPPED));
	Connected = false;
	closesocket(GetSock());
	SetSock(NULL);
	SetConnected(false);
}

