Shader "haslo/StencilNormalMapped" {
    Properties {
        _normalLevel ("Normal Level", Range(0, 3)) = 1
        _texLevel ("Tex Level", Range(0, 5)) = 1
        _texScale ("Texture Scale", Range(0, 10)) = 1
        _texture ("Texture", 2D) = "white" {}
        _textureNormal ("Normal Texture", 2D) = "bump" {}
        
        _SRef ("Stencil Ref", Float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _SComp ("Stencil Comp", Float) = 8
        [Enum(UnityEngine.Rendering.StencilOp)] _SOp ("Stencil Op", Float) = 2
    }
    SubShader {
        Tags { "Queue" = "Geometry-1" }

        ZWrite off
        ColorMask 0
                
        Stencil {
            Ref [_SRef]
            Comp [_SComp]
            Pass [_SOp]
        }
        
        CGPROGRAM
            #pragma surface surf Lambert

            half _normalLevel;
            half _texLevel;
            half _texScale;
            sampler2D _texture;
            sampler2D _textureNormal;

            struct Input {
                float2 uv_texture;
                float2 uv_textureNormal;
                INTERNAL_DATA
            };

            void surf(Input IN, inout SurfaceOutput o) {
                o.Albedo.rgb = (tex2D(_texture, IN.uv_texture.yx * _texScale) * _texLevel).rgb;
                o.Normal = UnpackNormal(tex2D(_textureNormal, IN.uv_textureNormal.yx * _texScale));
                o.Normal *= float3(_normalLevel, _normalLevel, 1);
            }
        ENDCG
    }
    FallBack "Diffuse"
}
