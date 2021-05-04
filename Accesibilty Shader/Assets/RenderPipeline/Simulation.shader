/*
    Post processing Shader to emulate being color bline
    Made by Evan Koppers
*/

Shader "Hidden/Simulation"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
        SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            uniform int type;

            #include "UnityCG.cginc"

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                
                //col.rgb = 1 - col.rgb;

                float3 L = (17.8824f * col.r) + (43.5161f * col.g) + (4.11935f * col.b);
                float3 M = (3.45565f * col.r) + (27.1554f * col.g) + (3.86714f * col.b);
                float3 S = (0.0299566f * col.r) + (0.184309f * col.g) + (1.46709f * col.b);

                // Simulate color blindness

                float l, m, s = 0.0f;

                if (type == 0)
                {
                    // Protanope - reds are greatly reduced (3% men)
                    l = 0.0f * L + 2.02344f * M + -2.52581f * S;
                    m = 0.0f * L + 1.0f * M + 0.0f * S;
                    s = 0.0f * L + 0.0f * M + 1.0f * S;
                }
                else if (type == 1)
                {
                    // Deuteranope - greens are greatly reduced (7% men)
                    l = 1.0f * L + 0.0f * M + 0.0f * S;
                    m = 0.494207f * L + 0.0f * M + 1.24827f * S;
                    s = 0.0f * L + 0.0f * M + 1.0f * S;
                }
                else if (type == 2)
                {
                    // Tritanope - blues are greatly reduced (0.003% population)
                    l = 1.0f * L + 0.0f * M + 0.0f * S;
                    m = 0.0f * L + 1.0f * M + 0.0f * S;
                    s = -0.395913f * L + 0.801109f * M + 0.0f * S;
                }

                col.r = (0.0809444479f * l) + (-0.130504409f * m) + (0.116721066f * s);
                col.g = (-0.0102485335f * l) + (0.0540193266f * m) + (-0.113614708f * s);
                col.b = (-0.000365296938f * l) + (-0.00412161469f * m) + (0.693511405f * s);
                col.a = 1;

                return col;
            }
            ENDCG
        }
    }
}
