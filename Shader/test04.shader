// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/test04"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Offset1("Offset1", Range(0,5)) = 0
        _Offset2("Offset2", Range(0,5)) = 0
        _LocatingPoint("LocatingPoint",vector) = (0,0,0,0)
        _K("K",Range(0,10)) = 1
    }
    SubShader
    {
        pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            float _Offset1;
            float _Offset2;
            float4 _LocatingPoint;
            float _K;

            struct a2v
            {
                float4 vertex:POSITION;
                float3 normal:NORMAL;
                float4 texcoord :TEXCOORD0;
            };

            struct v2f
            {
                float4 position:SV_POSITION;
                float3 temp:COLOR0;                
            };

            v2f vert(a2v v) 
            {
                float flag = 1;
                v2f f;
                f.temp = v.vertex.xyz;
                // 垂直偏移 与 平方偏移
                if(v.vertex.x > 0)
                {
                    v.vertex.y += _Offset2;
                }
                // 反比例偏移
                if(v.vertex.x < 0.01 && v.vertex.x>-0.01 && 
                    //v.vertex.z < 0.01 && v.vertex.z>-0.01 && 
                   v.vertex.y > 0)
                {
                    v.vertex.y += _Offset1;
                    _LocatingPoint = v.vertex;
                }
                float dx = abs(v.vertex.x - _LocatingPoint.x);
                float dy = _K / dx;
                v.vertex.y += clamp(dy,0,_Offset1);


                f.position = UnityObjectToClipPos(v.vertex);
                return f;
            }

            fixed4 frag(v2f f) :SV_TARGET
            {
                if(f.temp.x < 0.01 && f.temp.x>-0.01 &&
                //f.temp.z < 0.01 && f.temp.z>-0.01 && 
                   f.temp.y > 0)
                {
                    f.temp.xyz = float3(1,1,1);

                }
                return saturate(fixed4(f.temp,1));


            }




            ENDCG
        }

    }
    FallBack "Diffuse"
}
