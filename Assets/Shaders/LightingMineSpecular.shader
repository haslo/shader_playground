Shader "haslo/LightingMineSpecular"
{
    Properties
    {
        _Color ("Color", Color) = (0, 0.5, 0.5, 0.0)
        _SmoothnessTex ("Smoothness (R)", 2D) = "white" {}
        _SpecColor ("Specular", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags {
            "Queue" = "Geometry"
        }
        
        CGPROGRAM
        #pragma surface surf StandardSpecular

        struct Input
        {
            float2 uv_SmoothnessTex;
        };

        sampler2D _SmoothnessTex;
        float4 _Color;

        void surf(Input IN, inout SurfaceOutputStandardSpecular o)
        {
            o.Albedo.rgb = _Color.rgb;
            o.Smoothness = tex2D (_SmoothnessTex, IN.uv_SmoothnessTex);
            o.Specular = _SpecColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
