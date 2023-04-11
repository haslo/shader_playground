Shader "haslo/LightingBlinnPhong" {
    Properties {
        _Color ("Color", Color) = (0, 0.5, 0.5, 0.0)
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1) // magic parameter name for BlinnPhong
        _Specular ("Specular",Range(0, 1)) = 0.5
        _Gloss ("Gloss",Range(0, 1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue" = "Geometry"
        }

        CGPROGRAM
        #pragma surface surf BlinnPhong

        struct Input {
            float2 uv_texture;
        };

        float4 _Color;
        half _Specular;
        half _Gloss;

        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo.rgb = _Color.rgb;
            o.Specular = _Specular;
            o.Gloss = _Gloss;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
