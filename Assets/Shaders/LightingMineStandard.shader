Shader "haslo/LightingMineStandard"
{
    Properties
    {
        _Color ("Color", Color) = (0, 0.5, 0.5, 0.0)
        _MetallicTex ("Metallic (R)", 2D) = "white" {}
        _Metallic ("Metallic", Range(0.0, 1.0)) = 0.0
    }
    SubShader
    {
        Tags {
            "Queue" = "Geometry"
        }
        
        CGPROGRAM
        #pragma surface surf Standard

        struct Input
        {
            float2 uv_MetallicTex;
        };

        sampler2D _MetallicTex;
        half _Metallic;
        float4 _Color;

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo.rgb = _Color.rgb;
            o.Smoothness = tex2D (_MetallicTex, IN.uv_MetallicTex);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
