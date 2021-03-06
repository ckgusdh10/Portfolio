SamplerState gWrapSamplerState : register(s0);
Texture2D<float4> gtxUI : register(t0);
static float fMiniMapSize = -0.5f;
static float fArrowSize = 0.05f;

struct VS_UI_OUTPUT
{
   float4 position : SV_POSITION;
   float2 uv : TEXCOORD;
};
cbuffer UI_INFO : register(b0)
{
   float2 uv1;
   float2 uv2;
   float2 xmf2Degree;
   float2 xmf2Arrow;
   float4 xmf4TimeNumber[3];
   float4 xmf4HpNumber[3];
   float2 xmf2Point;
   float  fGravity;

   float time;
   int hp;
   float skilltime;
   float sanyangskilltime;
   float fairyskilltime;
};

VS_UI_OUTPUT MINIMAP_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   //사각형을 그린다.
   if (nVertexID == 0)
   {
      output.position = float4(-1.0f, fMiniMapSize + 0.1f, 0.0f, 1.0f);
      output.uv = float2(uv1.x, uv1.y);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(fMiniMapSize, fMiniMapSize + 0.1f, 0.0f, 1.0f);
      output.uv = float2(uv2.x, uv1.y);
   }
   else if (nVertexID == 2)
   {
      output.position = float4(fMiniMapSize, -1.0f, 0.0f, 1.0f);
      output.uv = float2(uv2.x, uv2.y);
   }
   else if (nVertexID == 3)
   {
      output.position = float4(-1.0f, fMiniMapSize + 0.1f, 0.0f, 1.0f);
      output.uv = float2(uv1.x, uv1.y);
   }
   else if (nVertexID == 4)
   {
      output.position = float4(fMiniMapSize, -1.0f, 0.0f, 1.0f);
      output.uv = float2(uv2.x, uv2.y);
   }
   else
   {
      output.position = float4(-1.0f, -1.0f, 0.0f, 1.0f);
      output.uv = float2(uv1.x, uv2.y);
   }

   return output;
}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


VS_UI_OUTPUT ARROW_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;
   float2x2 Rotation = float2x2(xmf2Degree.x, -xmf2Degree.y, xmf2Degree.y, xmf2Degree.x);
   float2 pos[4];
   pos[0] = float2(-fArrowSize, fArrowSize);
   pos[1] = float2(fArrowSize, fArrowSize);
   pos[2] = float2(fArrowSize, -fArrowSize);
   pos[3] = float2(-fArrowSize, -fArrowSize);

   for (int i = 0; i < 4; i++)
   {
      pos[i] = mul(pos[i], Rotation);
      pos[i].x += xmf2Arrow.x;
      pos[i].y += xmf2Arrow.y;
   }

   if (nVertexID == 0)
   {
      output.position = float4(pos[0].x, pos[0].y, 0.0f, 1.0f);
      output.uv = float2(0.0f, 0.0f);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(pos[1].x, pos[1].y, 0.0f, 1.0f);
      output.uv = float2(1.0f, 0.0f);
   }
   else if (nVertexID == 2)
   {
      output.position = float4(pos[2].x, pos[2].y, 0.0f, 1.0f);
      output.uv = float2(1.0f, 1.0f);
   }
   else if (nVertexID == 3)
   {
      output.position = float4(pos[0].x, pos[0].y, 0.0f, 1.0f);
      output.uv = float2(0.0f, 0.0f);
   }
   else if (nVertexID == 4)
   {
      output.position = float4(pos[2].x, pos[2].y, 0.0f, 1.0f);
      output.uv = float2(1, 1);
   }
   else
   {
      output.position = float4(pos[3].x, pos[3].y, 0.0f, 1.0f);
      output.uv = float2(0.0f, 1.0f);
   }

   return output;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

VS_UI_OUTPUT CROSS_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   if (nVertexID == 0)
   {
      output.position = float4(-0.3f, 0.3f, 0.0f, 1.0f);
      output.uv = float2(0.0f, 0.0f);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(0.3f, 0.3f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 0.0f);
   }
   else if (nVertexID == 2)
   {
      output.position = float4(0.3f, -0.3f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 1.0f);
   }
   else if (nVertexID == 3)
   {
      output.position = float4(-0.3f, 0.3f, 0.0f, 1.0f);
      output.uv = float2(0.0f, 0.0f);
   }
   else if (nVertexID == 4)
   {
      output.position = float4(0.3f, -0.3f, 0.0f, 1.0f);
      output.uv = float2(1, 1);
   }
   else
   {
      output.position = float4(-0.3f, -0.3f, 0.0f, 1.0f);
      output.uv = float2(0.0f, 1.0f);
   }

   return output;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//-0.5f - ((1 - (hp * 0.01)) / 2)
//(0.4 - (0.1 * ((250 / 500)* 100 * 0.04)))
//-0.5f - (0.4 - (0.1 * ((250 / 500)* 100 * 0.04)))
VS_UI_OUTPUT HPGAUGE_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   if (nVertexID == 0 || nVertexID == 3)
   {
      output.position = float4(-0.54f, 0.86f, 0.0f, 1.0f);
      output.uv = float2(0.0f, -0.0f);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(-0.19f - (0.35f - (0.1f * ((hp / 500.f) * 100.f * 0.035f))), 0.86f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 0.0f);
   }
   else if (nVertexID == 2 || nVertexID == 4)
   {
      output.position = float4(-0.19f - (0.35f - (0.1f * ((hp / 500.f) * 100.f * 0.035f))), 0.75f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 1.0f);
   }
   else if (nVertexID == 5)
   {
      output.position = float4(-0.54f, 0.75f, 0.0f, 1.0f);
      output.uv = float2(0.0f, 1.0f);
   }

   return output;
}

VS_UI_OUTPUT HPBASE_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   if (nVertexID == 0 || nVertexID == 3)
   {
      output.position = float4(-0.6f, 0.88f, 0.0f, 1.0f);
      output.uv = float2(0.0f, -0.0f);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(-0.17f, 0.88f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 0.0f);
   }
   else if (nVertexID == 2 || nVertexID == 4)
   {
      output.position = float4(-0.17f, 0.73f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 1.0f);
   }
   else if (nVertexID == 5)
   {
      output.position = float4(-0.6f, 0.73f, 0.0f, 1.0f);
      output.uv = float2(0.0f, 1.0f);
   }

   return output;
}

VS_UI_OUTPUT PANZA_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   if (nVertexID == 0 || nVertexID == 3)
   {
      output.position = float4(-0.8f, 1.0f, 0.0f, 1.0f);
      output.uv = float2(0.0f, -0.0f);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(-0.05f, 1.0f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 0.0f);
   }
   else if (nVertexID == 2 || nVertexID == 4)
   {
      output.position = float4(-0.05f, 0.65f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 1.0f);
   }
   else if (nVertexID == 5)
   {
      output.position = float4(-0.8f, 0.65f, 0.0f, 1.0f);
      output.uv = float2(0.0f, 1.0f);
   }

   return output;
}

VS_UI_OUTPUT TREE_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   if (nVertexID == 0 || nVertexID == 3)
   {
      output.position = float4(-0.95f, 0.90f, 0.0f, 1.0f);
      output.uv = float2(0.0f, -0.0f);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(-0.81f, 0.90f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 0.0f);
   }
   else if (nVertexID == 2 || nVertexID == 4)
   {
      output.position = float4(-0.81f, 0.74f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 1.0f);
   }
   else if (nVertexID == 5)
   {
      output.position = float4(-0.95f, 0.74f, 0.0f, 1.0f);
      output.uv = float2(0.0f, 1.0f);
   }

   return output;
}

VS_UI_OUTPUT WARRIORICON_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   if (nVertexID == 0 || nVertexID == 3)
   {
      output.position = float4(-0.7f, 0.94f, 0.0f, 1.0f);
      output.uv = float2(0.0f, -0.0f);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(-0.5f, 0.94f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 0.0f);
   }
   else if (nVertexID == 2 || nVertexID == 4)
   {
      output.position = float4(-0.5f, 0.68f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 1.0f);
   }
   else if (nVertexID == 5)
   {
      output.position = float4(-0.7f, 0.68f, 0.0f, 1.0f);
      output.uv = float2(0.0f, 1.0f);
   }

   return output;
}

VS_UI_OUTPUT FAIRYICON_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   if (nVertexID == 0 || nVertexID == 3)
   {
      output.position = float4(-0.7f, 0.94f, 0.0f, 1.0f);
      output.uv = float2(0.0f, -0.0f);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(-0.5f, 0.94f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 0.0f);
   }
   else if (nVertexID == 2 || nVertexID == 4)
   {
      output.position = float4(-0.5f, 0.68f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 1.0f);
   }
   else if (nVertexID == 5)
   {
      output.position = float4(-0.7f, 0.68f, 0.0f, 1.0f);
      output.uv = float2(0.0f, 1.0f);
   }

   return output;
}

VS_UI_OUTPUT SANYANG_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   if (nVertexID == 0 || nVertexID == 3)
   {
      output.position = float4(-0.7f, 0.94f, 0.0f, 1.0f);
      output.uv = float2(0.0f, -0.0f);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(-0.5f, 0.94f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 0.0f);
   }
   else if (nVertexID == 2 || nVertexID == 4)
   {
      output.position = float4(-0.5f, 0.68f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 1.0f);
   }
   else if (nVertexID == 5)
   {
      output.position = float4(-0.7f, 0.68f, 0.0f, 1.0f);
      output.uv = float2(0.0f, 1.0f);
   }

   return output;
}

VS_UI_OUTPUT ENDING_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   if (nVertexID == 0 || nVertexID == 3)
   {
      output.position = float4(-0.8f, 0.8f, 0.0f, 1.0f);
      output.uv = float2(0.0f, -0.0f);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(0.8f, 0.8f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 0.0f);
   }
   else if (nVertexID == 2 || nVertexID == 4)
   {
      output.position = float4(0.8f, -0.8f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 1.0f);
   }
   else if (nVertexID == 5)
   {
      output.position = float4(-0.8f, -0.8f, 0.0f, 1.0f);
      output.uv = float2(0.0f, 1.0f);
   }

   return output;
}
VS_UI_OUTPUT STARTSCENE_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   if (nVertexID == 0 || nVertexID == 3)
   {
      output.position = float4(-1.0f, 1.0f, 0.0f, 1.0f);
      output.uv = float2(0.0f, -0.0f);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(1.0f, 1.0f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 0.0f);
   }
   else if (nVertexID == 2 || nVertexID == 4)
   {
      output.position = float4(1.0f, -1.0f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 1.0f);
   }
   else if (nVertexID == 5)
   {
      output.position = float4(-1.0f, -1.0f, 0.0f, 1.0f);
      output.uv = float2(0.0f, 1.0f);
   }

   return output;

}

VS_UI_OUTPUT WARRIORSKILL_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   if (nVertexID == 0 || nVertexID == 3)
   {
      output.position = float4(-0.1f, -0.7f, 0.0f, 1.0f);
      output.uv = float2(0.0f, -0.0f);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(0.1f, -0.7f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 0.0f);
   }
   else if (nVertexID == 2 || nVertexID == 4)
   {
      output.position = float4(0.1f, -0.9f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 1.0f);
   }
   else if (nVertexID == 5)
   {
      output.position = float4(-0.1f, -0.9f, 0.0f, 1.0f);
      output.uv = float2(0.0f, 1.0f);
   }

   return output;
}

VS_UI_OUTPUT SANYANGSKILL_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   if (nVertexID == 0 || nVertexID == 3)
   {
      output.position = float4(-0.1f, -0.7f, 0.0f, 1.0f);
      output.uv = float2(0.0f, -0.0f);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(0.1f, -0.7f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 0.0f);
   }
   else if (nVertexID == 2 || nVertexID == 4)
   {
      output.position = float4(0.1f, -0.9f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 1.0f);
   }
   else if (nVertexID == 5)
   {
      output.position = float4(-0.1f, -0.9f, 0.0f, 1.0f);
      output.uv = float2(0.0f, 1.0f);
   }

   return output;
}

VS_UI_OUTPUT FAIRYSKILL_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   if (nVertexID == 0 || nVertexID == 3)
   {
      output.position = float4(-0.1f, -0.7f, 0.0f, 1.0f);
      output.uv = float2(0.0f, -0.0f);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(0.1f, -0.7f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 0.0f);
   }
   else if (nVertexID == 2 || nVertexID == 4)
   {
      output.position = float4(0.1f, -0.9f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 1.0f);
   }
   else if (nVertexID == 5)
   {
      output.position = float4(-0.1f, -0.9f, 0.0f, 1.0f);
      output.uv = float2(0.0f, 1.0f);
   }

   return output;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

VS_UI_OUTPUT SCOREBOARD_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   if (nVertexID == 0 || nVertexID == 3)
   {
      output.position = float4(-0.5f, 1.0f, 0.0f, 1.0f);
      output.uv = float2(0.0f, -0.0f);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(0.5f, 1.0f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 0.0f);
   }
   else if (nVertexID == 2 || nVertexID == 4)
   {
      output.position = float4(0.5f, 0.75f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 1.0f);
   }
   else
   {
      output.position = float4(-0.5f, 0.75f, 0.0f, 1.0f);
      output.uv = float2(0.0f, 1.0f);
   }

   return output;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

VS_UI_OUTPUT GRAVITYBAR_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   if (nVertexID == 0 || nVertexID == 3)
   {
      output.position = float4(0.85f, 0.65f, 0.0f, 1.0f);
      output.uv = float2(0.0f, -0.0f);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(0.95f, 0.65f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 0.0f);
   }
   else if (nVertexID == 2 || nVertexID == 4)
   {
      output.position = float4(0.95f, -0.55f, 0.0f, 1.0f);
      output.uv = float2(1.0f, 1.0f);
   }
   else
   {
      output.position = float4(0.85f, -0.55f, 0.0f, 1.0f);
      output.uv = float2(0.0f, 1.0f);
   }

   return output;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

VS_UI_OUTPUT GRAVITYPOINTER_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;
   float2 pos[4];
   pos[0] = float2(0.705, 0.405);
   pos[1] = float2(0.96, 0.405);
   pos[2] = float2(0.96, 0.205);
   pos[3] = float2(0.705, 0.205);

   for (int i = 0; i < 4; i++)
   {
      pos[i].y += xmf2Point.y;
   }

   if (nVertexID == 0)
   {
      output.position = float4(pos[0].x, pos[0].y, 0.0f, 1.0f);
      output.uv = float2(0.0f, 0.0f);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(pos[1].x, pos[1].y, 0.0f, 1.0f);
      output.uv = float2(1.0f, 0.0f);
   }
   else if (nVertexID == 2)
   {
      output.position = float4(pos[2].x, pos[2].y, 0.0f, 1.0f);
      output.uv = float2(1.0f, 1.0f);
   }
   else if (nVertexID == 3)
   {
      output.position = float4(pos[0].x, pos[0].y, 0.0f, 1.0f);
      output.uv = float2(0.0f, 0.0f);
   }
   else if (nVertexID == 4)
   {
      output.position = float4(pos[2].x, pos[2].y, 0.0f, 1.0f);
      output.uv = float2(1, 1);
   }
   else
   {
      output.position = float4(pos[3].x, pos[3].y, 0.0f, 1.0f);
      output.uv = float2(0.0f, 1.0f);
   }

   return output;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

VS_UI_OUTPUT SCORENUMBER_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   if (nVertexID == 0 || nVertexID == 3)
   {
      output.position = float4(-0.275f, 0.95f, 0.0f, 1.0f);
      output.uv = float2(xmf4TimeNumber[0].x, xmf4TimeNumber[0].y);
   }
   else if (nVertexID == 1 || nVertexID == 6 || nVertexID == 9)
   {
      output.position = float4(-0.075f, 0.95f, 0.0f, 1.0f);
      if (nVertexID == 1)
         output.uv = float2(xmf4TimeNumber[0].z, xmf4TimeNumber[0].y);
      else
         output.uv = float2(xmf4TimeNumber[1].x, xmf4TimeNumber[1].y);
   }
   else if (nVertexID == 2 || nVertexID == 4 || nVertexID == 11)
   {
      output.position = float4(-0.075f, 0.75f, 0.0f, 1.0f);
      if (nVertexID == 2 || nVertexID == 4)
         output.uv = float2(xmf4TimeNumber[0].z, xmf4TimeNumber[0].w);
      else
         output.uv = float2(xmf4TimeNumber[1].x, xmf4TimeNumber[1].w);
   }
   else if (nVertexID == 5)
   {
      output.position = float4(-0.275f, 0.75f, 0.0f, 1.0f);
      output.uv = float2(xmf4TimeNumber[0].x, xmf4TimeNumber[0].w);
   }
   else if (nVertexID == 7 || nVertexID == 12 || nVertexID == 15)
   {
      output.position = float4(0.125f, 0.95f, 0.0f, 1.0f);
      if (nVertexID == 7)
         output.uv = float2(xmf4TimeNumber[1].z, xmf4TimeNumber[1].y);
      else
         output.uv = float2(xmf4TimeNumber[2].x, xmf4TimeNumber[2].y);
   }
   else if (nVertexID == 8 || nVertexID == 10 || nVertexID == 17)
   {
      output.position = float4(0.125f, 0.75f, 0.0f, 1.0f);
      if (nVertexID == 8 || nVertexID == 10)
         output.uv = float2(xmf4TimeNumber[1].z, xmf4TimeNumber[1].w);
      else
         output.uv = float2(xmf4TimeNumber[2].x, xmf4TimeNumber[2].w);
   }
   else if (nVertexID == 13)
   {
      output.position = float4(0.325f, 0.95f, 0.0f, 1.0f);
      output.uv = float2(xmf4TimeNumber[2].z, xmf4TimeNumber[2].y);
   }
   else if (nVertexID == 14 || nVertexID == 16)
   {
      output.position = float4(0.325f, 0.75f, 0.0f, 1.0f);
      output.uv = float2(xmf4TimeNumber[2].z, xmf4TimeNumber[2].w);
   }

   return output;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

VS_UI_OUTPUT HP_NUMBER_VS(uint nVertexID : SV_VertexID)
{
   VS_UI_OUTPUT output;

   if (nVertexID == 0)
   {
      output.position = float4(-0.375f, -0.625f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[0].x, xmf4HpNumber[0].y);
   }
   else if (nVertexID == 1)
   {
      output.position = float4(-0.175f, -0.625f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[0].z, xmf4HpNumber[0].y);
   }
   else if (nVertexID == 2)
   {
      output.position = float4(-0.175f, -0.825f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[0].z, xmf4HpNumber[0].w);
   }
   else if (nVertexID == 3)
   {
      output.position = float4(-0.375f, -0.625f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[0].x, xmf4HpNumber[0].y);
   }
   else if (nVertexID == 4)
   {
      output.position = float4(-0.175f, -0.825f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[0].z, xmf4HpNumber[0].w);
   }
   else if (nVertexID == 5)
   {
      output.position = float4(-0.375f, -0.825f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[0].x, xmf4HpNumber[0].w);
   }
   else if (nVertexID == 6)
   {
      output.position = float4(-0.25f, -0.625f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[1].x, xmf4HpNumber[1].y);
   }
   else if (nVertexID == 7)
   {
      output.position = float4(-0.05f, -0.625f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[1].z, xmf4HpNumber[1].y);
   }
   else if (nVertexID == 8)
   {
      output.position = float4(-0.05f, -0.825f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[1].z, xmf4HpNumber[1].w);
   }
   else if (nVertexID == 9)
   {
      output.position = float4(-0.25f, -0.625f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[1].x, xmf4HpNumber[1].y);
   }
   else if (nVertexID == 10)
   {
      output.position = float4(-0.05f, -0.825f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[1].z, xmf4HpNumber[1].w);
   }
   else if (nVertexID == 11)
   {
      output.position = float4(-0.25f, -0.825f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[1].x, xmf4HpNumber[1].w);
   }
   else if (nVertexID == 12)
   {
      output.position = float4(-0.1f, -0.625f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[2].x, xmf4HpNumber[2].y);
   }
   else if (nVertexID == 13)
   {
      output.position = float4(0.1f, -0.625f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[2].z, xmf4HpNumber[2].y);
   }
   else if (nVertexID == 14)
   {
      output.position = float4(0.1f, -0.825f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[2].z, xmf4HpNumber[2].w);
   }
   else if (nVertexID == 15)
   {
      output.position = float4(-0.1f, -0.625f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[2].x, xmf4HpNumber[2].y);
   }
   else if (nVertexID == 16)
   {
      output.position = float4(0.1f, -0.825f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[2].z, xmf4HpNumber[2].w);
   }
   else if (nVertexID == 17)
   {
      output.position = float4(-0.1f, -0.825f, 0.0f, 1.0f);
      output.uv = float2(xmf4HpNumber[2].x, xmf4HpNumber[2].w);
   }

   return output;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
float4 UIPS(VS_UI_OUTPUT input) : SV_TARGET
{
   //input.position.x = sin(input.position.y * time);
   float4 color = gtxUI.Sample(gWrapSamplerState, input.uv);

   //color = (1, 1, 1, 1);
   clip(color.a - 0.1f);

   return color;
}

float4 WARRIORSKILLPS(VS_UI_OUTPUT input) : SV_TARGET
{
   //input.position.x = sin(input.position.y * time);
   float4 color = gtxUI.Sample(gWrapSamplerState, input.uv);

   
   if (input.uv.y < 1 - (skilltime / 5.0f) && skilltime != 0)
   {
      color.r = 0.4;
   }
   
   //color = (1, 1, 1, 1);
   clip(color.a - 0.1f);

   return color;
}

float4 SANYANGSKILLPS(VS_UI_OUTPUT input) : SV_TARGET
{
   //input.position.x = sin(input.position.y * time);
   float4 color = gtxUI.Sample(gWrapSamplerState, input.uv);


   if (input.uv.y < 1 - (sanyangskilltime / 5.0f) && sanyangskilltime != 0)
   {
      color.r = 0.4;
   }

   //color = (1, 1, 1, 1);
   clip(color.a - 0.1f);

   return color;
}

float4 FAIRYSKILLPS(VS_UI_OUTPUT input) : SV_TARGET
{
   //input.position.x = sin(input.position.y * time);
   float4 color = gtxUI.Sample(gWrapSamplerState, input.uv);


   if (input.uv.y < 1 - (fairyskilltime / 5.0f) && fairyskilltime != 0)
   {
      color.r = 0.4;
   }

   //color = (1, 1, 1, 1);
   clip(color.a - 0.1f);

   return color;
}

//float4 SANYANGSKILLPS(VS_UI_OUTPUT input) : SV_TARGET
//{
//	//input.position.x = sin(input.position.y * time);
//	float4 color = gtxUI.Sample(gWrapSamplerState, input.uv);
//
//
//	if (input.uv.y < 1 - (sanyangskilltime / 5.0f) && sanyangskilltime != 0)
//	{
//		color.r = 0.4;
//	}
//
//	//color = (1, 1, 1, 1);
//	clip(color.a - 0.1f);
//
//	return color;
//}