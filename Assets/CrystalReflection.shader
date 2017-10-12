// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/CrystalReflection" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		
		// Grab the screen behind the object into _BackgroundTexture
		GrabPass
		{
		}
		
		Tags{ "RenderType"="Transparent" "Queue" = "Transparent" }

		LOD 200
		
		CGPROGRAM

		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard vertex:vert alpha //fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0


		struct Input {
			float2 uv_MainTex : TEXCOORD0;
			float4 grabPos : TEXCOORD1;
			float4 pos : SV_POSITION;
			float3 viewDir : TEXCOORD2;
			float3 normal : TEXCOORD3;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END
		
		void vert(inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input,o);
			// use UnityObjectToClipPos from UnityCG.cginc to calculate 
			// the clip-space of the vertex
			o.pos = UnityObjectToClipPos(v.vertex) + COMPUTE_VIEW_NORMAL.xyzz;// UnityObjectToClipPos();
			// use ComputeGrabScreenPos function from UnityCG.cginc
			// to get the correct texture coordinate
			o.grabPos = ComputeGrabScreenPos(o.pos);
			
		}

		sampler2D _MainTex;
		sampler2D _GrabTexture;
		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = _Color;// tex2D(_MainTex, IN.uv_MainTex) * _Color;
			
			//c = tex2Dproj(_BackgroundTexture, UNITY_PROJ_COORD(IN.grabPos)) * (1 - _Color.a);
			o.Albedo = c.rgb;
			

			fixed4 e = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(IN.grabPos));
			o.Emission = e;
			
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = 1;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
