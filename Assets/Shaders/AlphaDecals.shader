Shader "haslo/AlphaDecals" {
    Properties {
        _Color ("Color", Color) = (0, 0.5, 0.5, 0.0)
        _MainTex ("Main Texture", 2D) = "white" {}
        _DecalTex ("Decal Texture", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "Queue" = "Geometry"
        }

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _DecalTex;
        float4 _Color;

        struct Input {
            float2 uv_MainTex;
            float2 uv_DecalTex;
        };

        void surf(Input IN, inout SurfaceOutput o) {
            fixed4 a = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 b = tex2D(_DecalTex, IN.uv_DecalTex);
            o.Albedo.rgb = a.rgb;
            o.Emission.rgb = _SinTime.a < 0.7 || (_SinTime.a > 0.8 && (_SinTime.a < 0.9 || _SinTime.a > 0.97)) ? b.rgb * 2 : (0, 0, 0);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
