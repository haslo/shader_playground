Shader "haslo/FirstVertexFragment" {
    Properties {
        _Color ("Color", Color) = (0, 0.5, 0.5, 0.0)
        _MainTex ("Texture", 2D) = "black" {}
    }
    SubShader {
        Tags {
            "Queue" = "Geometry"
        }

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uv_MainTex;
        };

        float4 _Color;
        sampler2D _MainTex;

        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo.rgb = _Color.rgb + tex2D(_MainTex, IN.uv_MainTex);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
