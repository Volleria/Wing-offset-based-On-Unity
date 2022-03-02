Shader "Unlit/Tessellation"
{
    Properties
    {
        _TessellationUniform ("Tessellation Uniform",Range(1,64))=1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
       

        Pass
        {

            Name "FORWARD"

            CGPROGRAM
 
            #pragma domain ds
            #pragma hull hs
            #pragma vertex tessvert
            #pragma fragment frag
            
            #pragma target 5.0

            #include "UnityCG.cginc"
            #include "Tessellation.cginc"

            

            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
            };
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (a2v v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.tangent = v.tangent;
                o.normal = v.normal;
                return o;
            }

            #ifdef UNITY_CAN_COMPILE_TESSELLATION
            struct TessVertex {
                float2 uv : TEXCOORD0;
                float4 vertex : INTERNALTESSPOS;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
            };

            struct OutputPatchConstant {
                float egd[3] : SV_TESSFACTOR;
                float inside : SV_INSIDETESSFACTOR;
            };

            TessVertex tessvert(a2v v){
                TessVertex o;
                o.vertex = v.vertex;
                o.uv = v.uv;
                o.tangent = v.tangent;
                o.normal = v.normal;
                return o;
            }

            float _TessellationUniform;

            OutputPatchConstant hsconst(InputPatch<TessVertex,3> patch){
                OutputPatchConstant o;
                o.egd[0] = _TessellationUniform;
                o.egd[1] = _TessellationUniform;
                o.egd[2] = _TessellationUniform;
                o.inside = _TessellationUniform;
                return o;
            }
            [UNITY_domain("tri")]
            [UNITY_partitioning("fractional_odd")]
            [UNITY_outputtopology("triangle_cw")]
            [UNITY_patchconstantfunc("hsconst")]
            [UNITY_outputcontrolpoints(3)]     

            TessVertex hs(InputPatch<TessVertex,3> patch,uint id : SV_OUTPUTCONTROLPOINTID){
                return patch[id];
            }

            [UNITY_domain("tri")]
            v2f ds(OutputPatchConstant tessFactor,const OutputPatch<TessVertex,3> patch,float3 bary : SV_DOMAINLOCATION){
                a2v v;
                v.vertex = patch[0].vertex*bary.x+patch[1].vertex*bary.y+patch[2].vertex*bary.z;
                v.normal= patch[0].normal*bary.x+patch[1].normal*bary.y+patch[2].normal*bary.z;
                v.tangent= patch[0].tangent*bary.x+patch[1].tangent*bary.y+patch[2].tangent*bary.z;
                v.uv= patch[0].uv*bary.x+patch[1].uv*bary.y+patch[2].uv*bary.z;
                v2f o = vert(v);
                return o;
               
            }

            #endif



            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(1.0f,1.0f,1.0f,1.0f);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}