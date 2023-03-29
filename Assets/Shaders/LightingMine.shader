Shader "haslo/LightingMine"
{
    Properties
    {
        _Color ("Color", Color) = (0, 0.5, 0.5, 0.0)
        _RampTex ("Ramp Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags {
            "Queue" = "Geometry"
        }
        
        CGPROGRAM
        // #pragma surface surf BasicLambert
        // #pragma surface surf BasicBlinnPhong
        // #pragma surface surf TimedBlinnPhong
        // #pragma surface surf BasicToon
        #pragma surface surf TimedToon

        float4 _Color;
        sampler2D _RampTex;

        half4 LightingBasicLambert(SurfaceOutput s, half3 lightDir, half atten) {
            half NdotL = dot (s.Normal, lightDir);
            half4 c;
            // c.rgb = s.Albedo * _LightColor0.rgb * (pow(1 - NdotL, 4) * atten);
            c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);
            c.a = s.Alpha;
            return c;
        }

        half4 LightingBasicBlinnPhong(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
            half3 h = normalize(lightDir + viewDir); // halfway vector
            half diff = max(0, dot(s.Normal, lightDir));

            float nh = max(0, dot(s.Normal, h)); // dot product between surface normal and h, falloff of specular
            float spec = pow(nh, 48.0); // "48 is what Unity uses"

            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
            c.a = s.Alpha;
            return c;
        }

        half4 LightingTimedBlinnPhong(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
            half3 h = normalize(lightDir + viewDir); // halfway vector
            half diff = max(0, dot(s.Normal, lightDir));

            float nh = max(0, dot(s.Normal, h)); // dot product between surface normal and h, falloff of specular
            float spec = pow(nh, 48.0); // "48 is what Unity uses"

            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten * _SinTime;
            c.a = s.Alpha;
            return c;
        }

        half4 LightingBasicToon(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
            float diff = max(0, dot(s.Normal, lightDir));
            float h = diff * 0.5 + 0.5; // h value, used as uv value for pulling out the texture components from the ramp
            float2 rh = h;
            float3 ramp = tex2D(_RampTex, rh).rgb;

            float4 c;
            c.rgb = s.Albedo * _LightColor0 * (ramp);
            c.a = s.Alpha;
            return c;
        }

        half4 LightingTimedToon(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
            float diff = max(0, dot(s.Normal, lightDir));
            float h = diff * 0.5 + 0.5; // h value, used as uv value for pulling out the texture components from the ramp
            float2 rh = h;
            float3 ramp = tex2D(_RampTex, rh).rgb;

            float4 c;
            c.rgb = s.Albedo * _LightColor0 * (ramp) * _SinTime;

            float dotN = pow(1 - dot(viewDir, s.Normal), 2);
            fixed rim = (dotN > 0.5) ? dotN : 0;
            c.rgb += rim * half4(1, 0, 1, 0.5);
            
            c.a = s.Alpha;
            return c;
        }

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
