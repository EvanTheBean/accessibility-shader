Shader "Custom/WaterShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Distortion("Distortion", Range(0,5)) = 1
		_Scale("Scale", Range(0,1)) = .3
		_Tiling("Tiling", Range(0,20)) = 10
		_WaveSpeed("Wave Speed", Range(0,20)) = 1
		_WaveSize("WaveSize", Range(0, 100)) = 1
	}
		SubShader
		{
			Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

			Pass
			{
				CGPROGRAM
				//Declare the vertex and fragment functions
				#pragma vertex vertMain
				#pragma fragment fragMain

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct vertexData
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float _Distortion;
				float _Scale;
				float _Tiling;
				float _WaveSpeed;
				float _WaveSize;

				vertexData vertMain(appdata IN)
				{
					vertexData OUT;

					IN.vertex.y += cos(_Time.y * _WaveSpeed + IN.vertex.x * _WaveSize);
					OUT.vertex = UnityObjectToClipPos(IN.vertex);

					//Creates the tiles individuaslly
					OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
					return OUT;
				}

				fixed4 fragMain(vertexData IN) : SV_Target
				{
					//Pushes and pulls the x value 
					IN.uv.x += sin((IN.uv.x) * _Tiling + _Time.y * _Distortion) * _Scale;



					// sample the texture
					fixed4 col = tex2D(_MainTex, IN.uv);

					return col;
				}
				ENDCG
			}
		}
}
