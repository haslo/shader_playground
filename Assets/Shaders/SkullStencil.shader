Shader "haslo/SkullStencil" {
    Properties {
        _Color ("Color", Color) = (0, 0.5, 0.5, 0.0)
    }
    SubShader {
        Tags {
            "Queue" = "Geometry-1"
        }
        
        ColorMask 0
        ZWrite off
        
        Stencil {
            Ref 1
            Comp always
            Pass replace
        }

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uv_texture;
        };

        float4 _Color;

        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo.rgb = _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
