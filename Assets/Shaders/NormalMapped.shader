Shader "haslo/NormalMapped" {
    Properties {
        _color ("Color", Color) = (1, 1, 1, 1)
        _colorLevel ("Color Level", Range(0, 5)) = 1
        _refLevel ("Reflection Level", Range(0, 5)) = 1
        _normalLevel ("Normal Level", Range(0, 3)) = 1
        _texLevel ("Tex Level", Range(0, 5)) = 1
        _texScale ("Texture Scale", Range(0, 10)) = 1
        _texture ("Texture", 2D) = "white" {}
        // _textureDisp ("Disp Texture", 2D) = "white" {}
        _textureNormal ("Normal Texture", 2D) = "bump" {}
        // _textureSpecular ("Specular Texture", 2D) = "white" {}
        _cube ("Cube", CUBE) = "" {}
        _float ("Float", Float) = 0.5
        _vector ("Vector", Vector) = (0.5, 1, 1, 1)
    }
    SubShader {
        CGPROGRAM
        #pragma surface surf Lambert

        fixed4 _color;
        half _colorLevel;
        half _refLevel;
        half _normalLevel;
        half _texLevel;
        half _texScale;
        sampler2D _texture;
        // sampler2D _textureDisp;
        sampler2D _textureNormal;
        // sampler2D _textureSpecular;
        samplerCUBE _cube;
        float _float;
        float4 _vector;

        struct Input {
            float2 uv_texture;
            float2 uv_textureDisp;
            float2 uv_textureNormal;
            float2 uv_textureSpecular;
            float3 worldRefl;
            INTERNAL_DATA
        };

        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo.rgb = (_color.rgb * _colorLevel).rgb + (tex2D(_texture, IN.uv_texture.yx * _texScale) * _texLevel).
                rgb;
            o.Normal = UnpackNormal(tex2D(_textureNormal, IN.uv_textureNormal.yx * _texScale));
            o.Normal *= float3(_normalLevel, _normalLevel, 1);
            o.Normal *= _SinTime.x * 0.5 + 1;
            // o.Specular = tex2D(_textureSpecular, IN.uv_textureSpecular);
            o.Emission = (texCUBE(_cube, WorldReflectionVector(IN, o.Normal)) * _refLevel).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
