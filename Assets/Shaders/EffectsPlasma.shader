Shader "haslo/EffectsPlasma" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Tint ("Color Tint", Color) = (1, 1, 1, 1)
        _Speed ("Speed", Range(1, 100)) = 10
        _Scale1 ("Scale 1", Range(0.1, 10)) = 2
        _Scale2 ("Scale 2", Range(0.1, 10)) = 2
        _Scale3 ("Scale 3", Range(0.1, 10)) = 2
        _Scale4 ("Scale 4", Range(0.1, 10)) = 2
    }
    SubShader {
        Cull Off
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uv_MainTex;
            float3 worldPos;
        };

        float4 _Tint;
        float _Speed;
        float _Scale1;
        float _Scale2;
        float _Scale3;
        float _Scale4;

        void surf (Input IN, inout SurfaceOutput o) {
            const float PI = 3.14159265;
            float t = _Time.x * _Speed;

            // vertical
            float c = sin(IN.uv_MainTex.x * 5 * _Scale1 + t);

            // horizontal
            c += sin(IN.uv_MainTex.y * 5 * _Scale2 + t);

            // diagonal
            c += sin(_Scale3 * (IN.uv_MainTex.x * 5 * sin(t/2.0) + IN.uv_MainTex.y * 5 * cos(t/3.0)) + t);

            // circular
            float c1 = pow(IN.uv_MainTex.x * 5 + 0.7 * sin(t / 5), 2);
            float c2 = pow(IN.uv_MainTex.y * 5 + 0.7 * cos(t / 3), 2);
            c += sin(sqrt(_Scale4 * (c1 + c2) + 1 + t));
            
            o.Albedo.r = sin(c / 4.0 * PI);
            o.Albedo.g = sin(c / 4.0 * PI + 2 * PI / 4);
            o.Albedo.b = sin(c / 4.0 * PI + 4 * PI / 4);

            o.Albedo += _Tint;
        }
        ENDCG
    }
    Fallback "Diffuse"
}
