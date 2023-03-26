Shader "haslo/MyFirstShader"
{
    Properties
    {
        _colorAlbedo ("Albedo", Color) = (1,1,1,1)
        _colorEmission ("Emission", Color) = (1,1,1,1)
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _colorAlbedo;
        fixed4 _colorEmission;

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _colorAlbedo.rgb;
            o.Emission = _colorEmission.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
