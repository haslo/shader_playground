Shader "haslo/PackedPractice" {
    Properties {
        _colorAlbedo ("Albedo", Color) = (1,1,1,1)
    }
    SubShader {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uv_MainTex;
        };

        fixed4 _colorAlbedo;

        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo.r = _colorAlbedo.r;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
