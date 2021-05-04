// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*
    Screen space shader for adjustable motion blur
    Made by Evan Koppers
*/

Shader "Unlit/MotionBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "UnityShaderVariables.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _MainTexPrevious;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                // transform position to clip space
                // (multiply with model*view*projection matrix)
                o.vertex = UnityObjectToClipPos(v.vertex);
                // just pass the texture coordinate
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {   
                int nSamples = 30;

                //current worldSpace
                fixed4 current = tex2D(_MainTex, i.uv);
                current = UNITY_MATRIX_IT_MV * current;

                //previous screen space
                fixed4 previous = UNITY_MATRIX_MVP * tex2D(_MainTexPreviousm, i.uv);
                previous.xyz /= previous.w;
                previous.xy = previous.xy * 0.5 + 0.5;

                //set this current one as previous for next
                tex2D(_MainTexPreviousm, i.uv) = current;

                fixed2 blurVec = previous.xy - i.uv;
                
                fixed4 result = tex2D(_MainTex, i.uv);
                for (int i = 1; i < nSamples; ++i) {
                    // get offset in range [-0.5, 0.5]:
                    fixed2 offset = blurVec * (float(i) / float(nSamples - 1) - 0.5);

                    // sample & add to result:
                    result += tex2D(uTexInput, i.uv + offset);
                }

                result /= float(nSamples);

                return result;
            }
            ENDCG
        }
    }
}
