Shader "haslo/LightingLambert"
{
    Properties
    {
        _Color ("Color", Color) = (0, 0.5, 0.5, 0.0)
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

        float4 _Color;

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo.rgb = _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
