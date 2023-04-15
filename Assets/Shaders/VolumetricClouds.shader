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
                float3 viewDir : TEXCOORD0;
                float4 projPos : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            float _Scale;
            float _StepScale;
            float _Steps;
            float _MinHeight;
            float _MaxHeight;
            float _FadeDist;
            float4 _SunDir;
            // sampler2D _CameraDepthTexture;

            fixed4 raymarch(float3 cameraPos, float3 viewDir, fixed4 backgroundCol, float depth) {
                fixed4 col = fixed4(0, 0, 0, 0);
                return col;
            }

            v2f vert(appdata_base v) {
                v2f o;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.viewDir = o.worldPos.xyz - _WorldSpaceCameraPos;
                o.projPos = ComputeScreenPos(o.pos);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                float depth = 1;
                depth *= length(i.viewDir);
                // alternatively:
                // float depth = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos))));
                fixed4 col = half4(1, 1, 1, 0);
                fixed4 clouds = raymarch(_WorldSpaceCameraPos, normalize(i.viewDir) * _StepScale, col, depth);
                fixed3 mixedCol = col * (1.0 - clouds.a) + clouds.rgb;
                return fixed4(mixedCol, clouds.a);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
