﻿Shader "Hidden/Fix"
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
            uniform float estimations;

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

            bool Approximation(float a, float b)
            {
                float diff = (a - b < 0) ? (-(a - b)) : (a - b);
                return diff > estimations;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                
                float r = col.r;
                float b = col.r;
                float g = col.g;

                if (type == 0) //Protanope
                {
                    if (Approximation(g,b))
                    {
                        g = 1.0;
                        b = 0.0;
                    }
                    else if (Approximation(b,g))
                    {
                        b = 1.0;
                        g = 0.0;
                    }
                }
                else if (type == 1) //Deuteranope
                {
                    if (Approximation(r, b))
                    {
                        r = 1.0;
                        b = 0.0;
                    }
                    else if (Approximation(b, r))
                    {
                        b = 1.0;
                        r = 0.0;
                    }
                }
                else if (type == 2) //Tritanope
                {
                    if (Approximation(r, g))
                    {
                        r = 1.0;
                        g = 0.0;
                    }
                    else if (Approximation(g, r))
                    {
                        g = 1.0;
                        r = 0.0;
                    }
                }

                col.r = r;
                col.b = b;
                col.g = g;

                return col;
            }
            ENDCG
        }
    }
}