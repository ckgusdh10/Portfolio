#pragma once
#include "Scene.h"

class DayForestScene :public CScene
{
	typedef  void(DayForestScene::*functionPointer)(char* Packet);
	typedef  std::map<char, functionPointer>  ProcessorMap;
	ProcessorMap        Processor;

private:
	std::unordered_map<string,INSTANCEOB> m_mProtoType; 
	CPlaneMap*			    m_pMap;
	CEffect*				m_pEffect[10];

	vector<pShadow*>	m_vPlayerShadow;

	vector<CStaticObj*>     m_StaticObjects;
	vector<CStaticObj*>		m_StaticShadows;

	vector<CMoveObject*>    m_vMonsters;
	vector<CMoveObject*>	m_vMShadows;
	vector<Mon_Shadow*>		m_vMonShadows;

	CInstancingShader*	pShader;
	vector<CInstancingShader*> m_StaticShader;

public:
	DayForestScene();
	virtual ~DayForestScene();

public:
	virtual void ProcessInput(float fDeltaTime);
	virtual void Render(ID3D12GraphicsCommandList *pd3dCommandList, CCamera *pCamera = NULL);
	virtual void Update(float fDeltaTime, ID3D12Device *pd3dDevice, ID3D12GraphicsCommandList *pd3dCommandList);
	virtual void EffectUpdate(ID3D12Device *pd3dDevice, ID3D12GraphicsCommandList *pd3dCommandList);
	virtual bool Initialize(ID3D12Device *pd3dDevice, ID3D12GraphicsCommandList *pd3dCommandList);
	virtual bool OnProcessingMouseMessage(HWND hWnd, UINT nMessageID, WPARAM wParam, LPARAM lParam);
	virtual bool OnProcessingKeyboardMessage(HWND hWnd, UINT nMessageID, WPARAM wParam, LPARAM lParam);
	virtual void ReleaseUploadBuffers();
	virtual void PacketProcess(char* packet) { (this->*Processor[packet[1]])(packet); }

	

public:
	void BuildLightsAndMaterials();
	void CreateStaticObjectFromMapFile(ID3D12Device *pd3dDevice, ID3D12GraphicsCommandList *pd3dCommandList);
	void DayForestScene::CreateStaticObProtoType(ID3D12Device *pd3dDevice, ID3D12GraphicsCommandList *pd3dCommandList, const std::wstring filePath, const std::string strTag, XMFLOAT3 scale);
	void CreateMovableObProtoType(ID3D12Device *pd3dDevice, ID3D12GraphicsCommandList *pd3dCommandList, const std::wstring filePath, const std::string strTag, READ_DATA type);
	INSTANCEOB FindStaticObProtoType(const std::string& strKey);
	void CollisionCheck(float fDeltaTime);
	void CollisionMove(BYTE dir, float fDeltaTime);
public: /*Packet ó���Լ�*/
	void PutNPC(char* packet);
	void StateNPC(char* packet);
	void RemoveNPC(char* packet);

};

