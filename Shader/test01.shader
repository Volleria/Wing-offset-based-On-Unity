// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/test01"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Offset1("Offset1", Range(0,5)) = 1
        _Offset2("Offset2", Range(0,5)) = 1
        _Offset3("Offset3", Range(0,5)) = 1
        _LocatingPoint("LocatingPoint",vector) = (0,0,0,0) 
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
            float _Offset3;
            float4 _LocatingPoint;

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
                v2f f;
                f.temp = v.vertex.xyz;
                if(v.vertex.x > 0)
                {
                    v.vertex.y += _Offset2;
                    v.vertex.y += pow(v.vertex.x,_Offset3);
                }
                v.vertex.xyz += v.normal * _Offset1;
                f.position = UnityObjectToClipPos(v.vertex + _Offset1);
                return f;
            }

            fixed4 frag(v2f f) :SV_TARGET
            {

                return fixed4(f.temp,1);
                // return float4(1,0,0,1);

            }




            ENDCG
        }

    }
    FallBack "Diffuse"
}
