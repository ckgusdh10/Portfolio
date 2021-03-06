#pragma once
class CStaticObj : public CGameObject
{
public:
	CStaticObj();
	virtual ~CStaticObj() {}
};

class CTree : public CStaticObj
{
public:
	CTree() {};
	virtual ~CTree() {};
public:
	virtual bool Initialize(ID3D12Device *pd3dDevice, ID3D12GraphicsCommandList *pd3dCommandList, ID3D12RootSignature *pd3dGraphicsRootSignature, CMesh* pMesh);
};

class CTreeShadow : public CStaticObj
{
public:
	CTreeShadow() {};
	virtual ~CTreeShadow() {};

public:
	virtual bool Initialize(ID3D12Device *pd3dDevice, ID3D12GraphicsCommandList *pd3dCommandList, ID3D12RootSignature *pd3dGraphicsRootSignature, CMesh * pMesh);
};

class CStone : public CStaticObj
{
public:
	CStone() {};
	virtual ~CStone() {};

public:
	virtual bool Initialize(ID3D12Device *pd3dDevice, ID3D12GraphicsCommandList *pd3dCommandList, ID3D12RootSignature *pd3dGraphicsRootSignature, CMesh * pMesh);
};

class CMushroom : public CStaticObj
{
public:
	CMushroom() {};
	virtual ~CMushroom() {};
public:
	virtual bool Initialize(ID3D12Device *pd3dDevice, ID3D12GraphicsCommandList *pd3dCommandList, ID3D12RootSignature *pd3dGraphicsRootSignature, CMesh * pMesh, int i);
};

class CFence : public CStaticObj
{
public:
	CFence() {};
	virtual ~CFence() {};
public:
	virtual bool Initialize(ID3D12Device *pd3dDevice, ID3D12GraphicsCommandList *pd3dCommandList, ID3D12RootSignature *pd3dGraphicsRootSignature, CMesh* pMesh);
};