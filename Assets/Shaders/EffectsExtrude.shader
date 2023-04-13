Shader "haslo/EffectsExtrude" {
    Properties {
        _MainTex ("Texture", 2D) = "black" {}
    }
    SubShader {
        Tags {
            "Queue" = "Geometry"
        }

        CGPROGRAM
            #pragma surface surf Lambert vertex:vert
        
            struct Input {
                float2 uv_MainTex;
            };

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            void vert (inout appdata v) {
                v.vertex.xyz += v.normal * sin(_Time.a + v.texcoord.x + v.texcoord.y) * 0.05;
            }

            sampler2D _MainTex;
            void surf(Input IN, inout SurfaceOutput o) {
                o.Albedo.rgb = tex2D(_MainTex, IN.uv_MainTex);
            }
        ENDCG
    }
    FallBack "Diffuse"
}
