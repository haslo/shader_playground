Shader "haslo/AllProps"
{
    Properties
    {
        _color ("Color", Color) = (1, 1, 1, 1)
        _texLevel ("Tex Level", Range(0, 5)) = 1
        _refLevel ("Reflection Level", Range(0, 5)) = 1
        _texture ("Texture", 2D) = "white" {}
        _cube ("Cube", CUBE) = "" {}
        _float ("Float", Float) = 0.5
        _vector ("Vector", Vector) = (0.5, 1, 1, 1)
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_texture;
            float3 worldRefl;
        };

        fixed4 _color;
        half _texLevel;
        half _refLevel;
        sampler2D _texture;
        samplerCUBE _cube;
        float _float;
        float4 _vector;

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo.rgb = (tex2D(_texture, IN.uv_texture) * _texLevel).rgb;
            o.Emission = (texCUBE(_cube, IN.worldRefl) * _refLevel).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
