Shader "haslo/Lighting1"
{
    Properties
    {
        _color ("Color", Color) = (0, 0.5, 0.5, 0.0)
        _colorLevel ("Color Level", Range(0, 5)) = 1
        _texture ("Texture", 2D) = "white" {}
        _texLevel ("Tex Level", Range(0, 5)) = 1
        _texScale ("Texture Scale", Range(0, 10)) = 1
    }
    SubShader
    {
        Tags {
            "Queue" = "Geometry"
        }
        
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_texture;
        };

        float4 _color;
        half _colorLevel;
        sampler2D _texture;
        half _texLevel;
        half _texScale;

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo.rgb = (tex2D(_texture, IN.uv_texture.yx * _texScale) * _texLevel).rgb + (_color * _colorLevel).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
