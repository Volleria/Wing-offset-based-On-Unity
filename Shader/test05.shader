
Shader "test05"
{
	Properties
    {
		[HideInInspector] _tx ("tx",float) = 0
		[HideInInspector] _ty ("ty",float) = 0
		[HideInInspector] _tz ("tz",float) = 0
		[HideInInspector] _Scale ("scale",float) =1
        
        // 定位点坐标初始化
        [Header(Set the point location)]
        [Space(10)]_LocatingPoint1("LocatingPoint 1",vector) = (0,0,0,0)
        _LocatingPoint2("LocatingPoint 2",vector) = (0,0,0,0)
        _LocatingPoint3("LocatingPoint 3",vector) = (0,0,0,0)
        _LocatingPoint4("LocatingPoint 4",vector) = (0,0,0,0)
        _LocatingPoint5("LocatingPoint 5",vector) = (0,0,0,0) 

        // yz轴偏移幅度修正因子
        [Header(Set the axis offset)]
        [Space(10)]_Offset_Y("y轴方向幅度修正",Range(2,10)) = 2
        _Offset_Z("z轴方向幅度修正",Range(2,10)) = 2

        // xyz轴偏移量初始化
        [Header(Set the point offset)]
        [Space(10)]_Offset1_y("Offset1 y",Range(-0.5,0.5)) = 0
        _Offset1_x("Offset1 x",Range(-0.5,0.5)) = 0
        _Offset1_z("Offset1 z",Range(-0.5,0.5)) = 0

        [Space(10)]_Offset2_y("Offset2 y",Range(-0.5,0.5)) = 0
        _Offset2_x("Offset2 x",Range(-0.5,0.5)) = 0
        _Offset2_z("Offset2 z",Range(-0.5,0.5)) = 0       

        [Space(10)]_Offset3_y("Offset3 y",Range(-0.5,0.5)) = 0
        _Offset3_x("Offset3 x",Range(-0.5,0.5)) = 0
        _Offset3_z("Offset3 z",Range(-0.5,0.5)) = 0

        [Space(10)]_Offset4_y("Offset4 y",Range(-0.5,0.5)) = 0
        _Offset4_x("Offset4 x",Range(-0.5,0.5)) = 0
        _Offset4_z("Offset4 z",Range(-0.5,0.5)) = 0
        
        [Space(10)]_Offset5_y("Offset5 y",Range(-0.5,0.5)) = 0
        _Offset5_x("Offset5 x",Range(-0.5,0.5)) = 0
        _Offset5_z("Offset5 z",Range(-0.5,0.5)) = 0
        
    }
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			float4 _LocatingPoint1;
            float4 _LocatingPoint2;
            float4 _LocatingPoint3;
            float4 _LocatingPoint4;
            float4 _LocatingPoint5;

            float _Offset_Y;
            float _Offset_Z;

            float _Offset1_y;
            float _Offset2_y;
            float _Offset3_y;
            float _Offset4_y;
            float _Offset5_y;

            float _Offset1_x;
            float _Offset2_x;
            float _Offset3_x;
            float _Offset4_x;
            float _Offset5_x;

            float _Offset1_z;
            float _Offset2_z;
            float _Offset3_z;
            float _Offset4_z;
            float _Offset5_z; 

			float _tx;
			float _ty;			
			float _tz;
			float _Scale;
		
			struct a2v
			{
				float4 vertex : POSITION;
				float4 texcoord :TEXCOORD0; 
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 temp:COLOR0;
			};


			v2f vert (a2v v)
			{
				v2f f;

				// 设置矩阵
				float4x4 scale_M={
					_Scale,0,0,0,
					0,_Scale,0,0,
					0,0,_Scale,0,
					0,0,0,1
				};
				float4x4 trans_M ={
					1,0,0,_tx,
					0,1,0,_ty,
					0,0,1,_tz,
					0,0,0,1
				};
				// 逆矩阵
				float4x4 scale_M_inverse={
					1/_Scale,0,0,0,
					0,1/_Scale,0,0,
					0,0,1/_Scale,0,
					0,0,0,1
				};
				float4x4 trans_M_inverse ={
					1,0,0,-_tx,
					0,1,0,-_ty,
					0,0,1,-_tz,
					0,0,0,1
				};
				// 进行坐标变换  归一化到[0,1] 
				v.vertex = mul(scale_M,v.vertex);
				v.vertex = mul(trans_M,v.vertex);

				// ------------------------------偏移效果--------------------------

                // 手动调节定位点位置
                if( _LocatingPoint1.x == 0 )
                {                  
                    _LocatingPoint1 = float4(0.166 + _Offset1_x, 0.5 + _Offset1_y, 0.5, 1);                   
                }
                if( _LocatingPoint2.x == 0)
                {                  
                    _LocatingPoint2 = float4(0.333 + _Offset2_x, 0.5 + _Offset2_y, 0.5, 1);                  
                }
                if( _LocatingPoint3.x == 0)
                {                  
                     _LocatingPoint3 = float4(0.5 + _Offset3_x,   0.5 + _Offset3_y, 0.5, 1);                   
                }
                if( _LocatingPoint4.x == 0)
                {                  
                     _LocatingPoint4 = float4(0.666 + _Offset4_x, 0.5 + _Offset4_y, 0.5, 1);                  
                }
                if( _LocatingPoint5.x == 0)
                {                  
                    _LocatingPoint5 = float4(0.833 + _Offset5_x, 0.5 + _Offset5_y, 0.5, 1);                   
                }

                _LocatingPoint1 += float4(_Offset1_x, _Offset1_y, _Offset1_z, 0);
                _LocatingPoint2 += float4(_Offset2_x, _Offset2_y, _Offset2_z, 0);  
                _LocatingPoint3 += float4(_Offset3_x, _Offset3_y, _Offset3_z, 0);  
                _LocatingPoint4 += float4(_Offset4_x, _Offset4_y, _Offset4_z, 0);  
                _LocatingPoint5 += float4(_Offset5_x, _Offset5_y, _Offset5_z, 0);  
            

                // 测试用
                // _Offset1_y += sin(_Time.y * 5) / 50;
                // _Offset2_y += sin(_Time.y * 5 + 0.5) / 50;
                // _Offset3_y += sin(_Time.y * 5 + 2) / 50;
                // _Offset4_y += sin(_Time.y * 5 + 0.2) / 50;
                // _Offset5_y += sin(_Time.y * 5 + 1) / 50;




                // 定位点周围点受其影响，y方向发生偏移
             //   float dy1 = 0;
             //   float dx1 = abs(v.vertex.x - _LocatingPoint1.x);
             //   if(dx1 < 0.167)
             //   {
             //       float smoothstep_factor1 = 1 / (_Offset1_y + 0.0001);
             //       dy1 = smoothstep(0.5,0,dx1)/smoothstep_factor1;
             //   }
//
             //   float dy2 = 0;
             //   float dx2 = abs(v.vertex.x - _LocatingPoint2.x);
             //   if(dx2 < 0.167)
             //   {
             //       float smoothstep_factor2 = 1 / (_Offset2_y + 0.0001);
             //       dy2 = smoothstep(0.5,0,dx2)/smoothstep_factor2; 
             //   }
             //  
             //   float dy3 = 0;
             //   float dx3 = abs(v.vertex.x - _LocatingPoint3.x);
             //   if (dx3 < 0.167)
             //   {
             //       float smoothstep_factor3 = 1 / (_Offset3_y + 0.0001);
             //       dy3 = smoothstep(0.5,0,dx3)/smoothstep_factor3;
             //   }
//
             //   float dy4 = 0;
             //   float dx4 = abs(v.vertex.x - _LocatingPoint4.x);
             //   if(dx4 < 0.167)
             //   {
             //       float smoothstep_factor4 = 1 / (_Offset4_y + 0.0001);
             //       dy4 = smoothstep(0.5,0,dx4)/smoothstep_factor4;
             //   }
//
             //   float dy5 = 0;
             //   float dx5 = abs(v.vertex.x - _LocatingPoint5.x);
             //   if(dx5 < 0.167)
             //   {
             //       float smoothstep_factor5 = 1 / (_Offset5_y + 0.0001);
             //       dy5 = smoothstep(0.5,0,dx5)/smoothstep_factor5;                    
             //   }

                float dx1 = abs(v.vertex.x - _LocatingPoint1.x);
                float smoothstep_factor1_y = _Offset_Y / (_Offset1_y + 0.0001);
                float dy1 = smoothstep(0.5,0,dx1)/smoothstep_factor1_y;
                float smoothstep_factor1_z = _Offset_Z / (_Offset1_z + 0.0001);
                float dz1 = smoothstep(0.5,0,dx1)/smoothstep_factor1_z;

                float dx2 = abs(v.vertex.x - _LocatingPoint2.x);
                float smoothstep_factor2_y = _Offset_Y / (_Offset2_y + 0.0001);
                float dy2 = smoothstep(0.5,0,dx2)/smoothstep_factor2_y;
                float smoothstep_factor2_z = _Offset_Z / (_Offset2_z + 0.0001);
                float dz2 = smoothstep(0.5,0,dx2)/smoothstep_factor2_z;                

                float dx3 = abs(v.vertex.x - _LocatingPoint3.x);
                float smoothstep_factor3_y = _Offset_Y / (_Offset3_y + 0.0001);
                float dy3 = smoothstep(0.5,0,dx3)/smoothstep_factor3_y;
                float smoothstep_factor3_z = _Offset_Z / (_Offset3_z + 0.0001);
                float dz3 = smoothstep(0.5,0,dx3)/smoothstep_factor3_z;

                float dx4 = abs(v.vertex.x - _LocatingPoint4.x);
                float smoothstep_factor4_y = _Offset_Y / (_Offset4_y + 0.0001);
                float dy4 = smoothstep(0.5,0,dx4)/smoothstep_factor4_y;
                float smoothstep_factor4_z = _Offset_Z / (_Offset4_z + 0.0001);
                float dz4 = smoothstep(0.5,0,dx4)/smoothstep_factor4_z;

                float dx5 = abs(v.vertex.x - _LocatingPoint5.x);
                float smoothstep_factor5_y = _Offset_Y / (_Offset5_y + 0.0001);
                float dy5 = smoothstep(0.5,0,dx5)/smoothstep_factor5_y;
                float smoothstep_factor5_z = _Offset_Z / (_Offset5_z + 0.0001);
                float dz5 = smoothstep(0.5,0,dx5)/smoothstep_factor5_z;


                v.vertex.y += dy1 + dy2 + dy3 + dy4 + dy5;
                v.vertex.z += dz1 + dz2 + dz3 + dz4 + dz5;

				f.temp = v.vertex.xyz;

				// 将模型恢复
				v.vertex = mul(trans_M_inverse,v.vertex);
				v.vertex = mul(scale_M_inverse,v.vertex);
				f.vertex = UnityObjectToClipPos(v.vertex);
				return f;
			}

			fixed4 frag (v2f i) : SV_Target
            {
                return saturate(float4(i.temp,1));
			}
			ENDCG
		}		
	}
}