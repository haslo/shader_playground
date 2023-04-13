Shader "haslo/StenciledLambert" {
    Properties {
        _Color ("Color", Color) = (0, 0.5, 0.5, 0.0)
        _SRef ("Stencil Ref", Float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _SComp ("Stencil Comp", Float) = 8
        [Enum(UnityEngine.Rendering.StencilOp)] _SOp ("Stencil Op", Float) = 2
    }
    SubShader {
        Tags {
            "Queue" = "Geometry"
        }

        Stencil {
            Ref [_SRef]
            Comp [_SComp]
            Pass [_SOp]
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
