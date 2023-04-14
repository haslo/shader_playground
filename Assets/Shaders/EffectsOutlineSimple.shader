Shader "haslo/EffectsOutlineSimple" {
    Properties {
        _MainTex ("Texture", 2D) = "black" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        _OutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
        _Outline ("Outline width", Range(-0.01, 0.1)) = 0.005
    }
    SubShader {
        Tags {
            "Queue" = "Transparent"
        }

        ZWrite off
        
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert

        struct Input {
            float2 uv_MainTex;
        };

        float _Outline;
        float4 _OutlineColor;
        void vert(inout appdata_full v) {
            v.vertex.xyz += v.normal * _Outline;
        }
        void surf (Input IN, inout SurfaceOutput o) {
            o.Emission = _OutlineColor.rgb;
        }
        ENDCG

        ZWrite on

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        fixed4 _Color;

        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo.rgb = _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
