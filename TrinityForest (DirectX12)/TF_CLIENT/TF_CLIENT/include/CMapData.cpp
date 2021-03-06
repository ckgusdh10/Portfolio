#include "CMapData.h"



CMapData::CMapData()
{
}


CMapData::~CMapData()
{
}

bool CMapData::Initialize()
{
	ifstream  ReadStage1("Assets/Map/0816.geg");
	int f;
	ReadStage1 >> f;
	ReadStage1 >> f;
	if (ReadStage1.is_open())
	{
		for (int y = 0; y < MAPSIZE; ++y) {
			for (int x = 0; x < MAPSIZE; ++x) {
				ReadStage1 >> Stage1[y][x];
				//cout << Stage1[y][x] << " ";
			}
			//cout << endl;
		}
		ReadStage1.close();
		//printf("MapRead Success!!\n");
	}
	CreateMapBoundingBox();
	return true;

}

void CMapData::CreateMapBoundingBox()
{

	XMFLOAT3 Points[16][8] = {
	{ XMFLOAT3(0, -20, 0), XMFLOAT3(570, -20, 0), XMFLOAT3(570, -20, -45), XMFLOAT3(0, -20, -45),
	XMFLOAT3(0, 100, 0), XMFLOAT3(570, 100, 0), XMFLOAT3(570, 100, -45), XMFLOAT3(0, 100, -45) },

	{ XMFLOAT3(0, -20, -525), XMFLOAT3(570, -20, -525), XMFLOAT3(570, -20, -570), XMFLOAT3(0, -20, -570),
	XMFLOAT3(0, 100, -525), XMFLOAT3(570, 100, -525), XMFLOAT3(570, 100, -570), XMFLOAT3(0, 100, -570) },

	{ XMFLOAT3(0, -20, -45), XMFLOAT3(45, -20, -45), XMFLOAT3(45, -20, -525), XMFLOAT3(0, -20, -525),
	XMFLOAT3(0, 100, -45), XMFLOAT3(45, 100, -45), XMFLOAT3(45, 100, -525), XMFLOAT3(0, 100, -525) },

	{ XMFLOAT3(525, -20, -45), XMFLOAT3(570, -20, -45), XMFLOAT3(570, -20, -525), XMFLOAT3(525, -20, -525),
	XMFLOAT3(525, 100, -45), XMFLOAT3(570, 100, -45), XMFLOAT3(570, 100, -525), XMFLOAT3(525, 100, -525) },

	{ XMFLOAT3(75, -20, -45), XMFLOAT3(105, -20, -45), XMFLOAT3(105, -20, -495), XMFLOAT3(75, -20, -495),
	XMFLOAT3(75,100, -45), XMFLOAT3(105,100, -45), XMFLOAT3(105,100, -495), XMFLOAT3(75,100, -495) },

	{ XMFLOAT3(105, -20, -465), XMFLOAT3(435, -20, -465), XMFLOAT3(435, -20, -495), XMFLOAT3(105, -20, -495),
	XMFLOAT3(105,100, -465), XMFLOAT3(435,100, -465), XMFLOAT3(435,100, -495), XMFLOAT3(105,100, -495) },

	{ XMFLOAT3(405, -20, -465), XMFLOAT3(435, -20, -465), XMFLOAT3(435, -20, -135), XMFLOAT3(405, -20, -135),
	XMFLOAT3(405,100, -465), XMFLOAT3(435,100, -465), XMFLOAT3(435,100, -135), XMFLOAT3(405,100, -135) },

	{ XMFLOAT3(405, -20, -135), XMFLOAT3(405, -20, -165), XMFLOAT3(195, -20, -165), XMFLOAT3(195, -20, -135),
	XMFLOAT3(405,100, -135), XMFLOAT3(405,100, -165), XMFLOAT3(195,100, -165), XMFLOAT3(195,100, -135) },

	{ XMFLOAT3(195, -20, -165), XMFLOAT3(225, -20, -165), XMFLOAT3(225, -20, -375), XMFLOAT3(195, -20, -375),
	XMFLOAT3(195,100, -165), XMFLOAT3(225,100, -165), XMFLOAT3(225,100, -375), XMFLOAT3(195,100, -375) },

	{ XMFLOAT3(225, -20, -375), XMFLOAT3(225, -20, -315), XMFLOAT3(315, -20, -315), XMFLOAT3(315, -20, -375),
	XMFLOAT3(225,100, -375), XMFLOAT3(225,100, -315), XMFLOAT3(315,100, -315), XMFLOAT3(315,100, -375) },

	{ XMFLOAT3(495, -20, -525), XMFLOAT3(495, -20, -75), XMFLOAT3(465, -20, -75), XMFLOAT3(465, -20, -525),
	XMFLOAT3(495,100, -525), XMFLOAT3(495,100, -75), XMFLOAT3(465,100, -75), XMFLOAT3(465,100, -525) },

	{ XMFLOAT3(465, -20, -75), XMFLOAT3(465, -20, -105), XMFLOAT3(135, -20, -105), XMFLOAT3(135, -20, -75),
	XMFLOAT3(465,100, -75), XMFLOAT3(465,100, -105), XMFLOAT3(135,100, -105), XMFLOAT3(135,100, -75) },

	{ XMFLOAT3(135, -20, -105), XMFLOAT3(135, -20, -375), XMFLOAT3(165, -20, -375), XMFLOAT3(165, -20, -105),
	XMFLOAT3(135,100, -105), XMFLOAT3(135,100, -375), XMFLOAT3(165,100, -375), XMFLOAT3(165,100, -105) },

	{ XMFLOAT3(165, -20, -435), XMFLOAT3(165, -20, -405), XMFLOAT3(375, -20, -405), XMFLOAT3(375, -20, -435),
	XMFLOAT3(165,100, -435), XMFLOAT3(165,100, -405), XMFLOAT3(375,100, -405), XMFLOAT3(375,100, -435) },

	{ XMFLOAT3(345, -20, -405), XMFLOAT3(345, -20, -195), XMFLOAT3(375, -20, -195), XMFLOAT3(375, -20, -405),
	XMFLOAT3(345,100, -405), XMFLOAT3(345,100, -195), XMFLOAT3(375,100, -195), XMFLOAT3(375,100, -405) },

	{ XMFLOAT3(345, -20, -255), XMFLOAT3(345, -20, -195), XMFLOAT3(255, -20, -195), XMFLOAT3(255, -20, -255),
	XMFLOAT3(345,100, -255), XMFLOAT3(345,100, -195), XMFLOAT3(255,100, -195), XMFLOAT3(255,100, -255) }
	};
	std::vector<BoundingOrientedBox*> Stage1BoundingBox;
	for (int i = 0; i < 16; ++i)
	{
		BoundingOrientedBox *tempCollision = new BoundingOrientedBox();
		BoundingOrientedBox::CreateFromPoints(*tempCollision, 8, Points[i], sizeof(float) * 3);
		Stage1BoundingBox.push_back(tempCollision);
	}
	MapBoundingBoxes[STAGE::STAGE1] = Stage1BoundingBox;

	//여기다 Stage2 Stage3도 차후 추가하자 

}

void CMapData::Close()
{
	for (auto& M : MapBoundingBoxes) {
		Safe_Delete_VecList(M.second);
	}
}
