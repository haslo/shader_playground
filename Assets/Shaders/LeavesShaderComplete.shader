Shader "haslo/LeavesShaderComplete" {
    Properties {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Color ("Main Color", Color) = (1, 1, 1, 1)
        _Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.1
    }
    SubShader {
        Tags {
            "Queue" = "Transparent"
        }

        Cull off

        CGPROGRAM
        #pragma surface surf Lambert alphatest:_Cutoff alpha:fade addshadow

        sampler2D _MainTex;
        fixed4 _Color;
        half _Cutoff;

        struct Input {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o) {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            if (c.a < _Cutoff) discard;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    Fallback "Transparent/Cutout/VertexLit"
}
