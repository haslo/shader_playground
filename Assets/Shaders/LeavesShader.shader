Shader "haslo/LeavesShader"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
        }
        // AlphaTest Greater 0.5

        CGPROGRAM

        #pragma surface surf Lambert alphatest:_Cutoff addshadow

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex).rgba;
            if (c.a < 0.5) discard;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        
        ENDCG
    }
    Fallback "Diffuse"
}
