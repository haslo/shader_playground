Shader "haslo/LightingMine"
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
        #pragma surface surf BasicLambert
        // #pragma surface surf BasicBlinnPhong

        half4 LightingBasicLambert (SurfaceOutput s, half3 lightDir, half atten) {
            half NdotL = dot (s.Normal, lightDir);
            half4 c;
            // c.rgb = s.Albedo * _LightColor0.rgb * (pow(1 - NdotL, 4) * atten);
            c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);
            c.a = s.Alpha;
            return c;
        }

        half4 LightingBasicBlinnPhong (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
            half3 h = normalize(lightDir + viewDir); // halfway vector
            half diff = max(0, dot(s.Normal, lightDir));

            float nh = max(0, dot(s.Normal, h)); // dot product between surface normal and h, falloff of specular
            float spec = pow(nh, 48.0); // "48 is what Unity uses"

            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
            c.a = s.Alpha;
            return c;
        }

        float4 _Color;

        struct Input
        {
            float2 uv_texture;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo.rgb = _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
