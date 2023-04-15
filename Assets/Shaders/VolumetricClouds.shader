Shader "haslo/VolumetricClouds" {
    Properties {
        _Scale ("Scale", Range(0.1, 10.0)) = 2.0
        _StepScale ("Step Scale", Range(0.1, 10.0)) = 2.0
        _Steps ("Steps", Range(1, 200)) = 60
        _MinHeight ("Min Height", Range(-10, 10)) = 0
        _MaxHeight ("Max Height", Range(-10, 10)) = 10
        _FadeDist ("Fade Distance", Range(0, 10)) = 0.5
        _SunDir ("Sun Direction", Vector) = (1, 0, 0, 0)
    }
    
    SubShader {
        Tags {
            "Queue" = "Transparent"
        }

        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off Lighting Off ZWrite Off
        ZTest Always
        
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 viewDir : TEXCOORD1;
                float4 projPos : TEXCOORD2;
                float3 worldPos : TEXCOORD3;
            };

            float _Scale;
            float _StepScale;
            float _Steps;
            float _MinHeight;
            float _MaxHeight;
            float _FadeDist;
            float4 _SunDir;
            sampler2D _CameraDepthTexture;

            v2f vert(appdata_base v) {
                v2f o;
                float4 wPos = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.viewDir = wPos.xyz - _WorldSpaceCameraPos;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                half4 col = half4(1, 1, 1, 1);
                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
