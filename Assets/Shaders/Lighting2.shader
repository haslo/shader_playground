Shader "haslo/Lighting2"
{
    Properties
    {
        _color ("Color", Color) = (0, 0.5, 0.5, 0.0)
        _color ("Color", Color) = (0, 0.5, 0.5, 0.0)
    }
    SubShader
    {
        Tags {
            "Queue" = "Geometry"
        }
        
        CGPROGRAM
        #pragma surface surf BlinnPhong

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
