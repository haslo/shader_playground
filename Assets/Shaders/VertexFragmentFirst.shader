Shader "haslo/VertexFragmentFirst" {
    Properties {
        _MainTex ("Main Texture", 2D) = "white" {}
        _ScaleUVX ("Scale UV X", Range(0.1, 20)) = 1
        _ScaleUVY ("Scale UV Y", Range(0.1, 20)) = 1
        _OffsetUVX ("Offset UV X", Range(0, 20)) = 0
        _OffsetUVY ("Offset UV Y", Range(0, 20)) = 0
    }

    SubShader {
        Tags { "Queue" = "Transparent" }
        GrabPass {}
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                // float4 color : COLOR;
            };

            sampler2D _GrabTexture;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _ScaleUVX;
            float _ScaleUVY;
            float _OffsetUVX;
            float _OffsetUVY;

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                // o.color.r = (v.vertex.x + 5) / 10; // object space
                // o.color.b = (v.vertex.z + 5) / 10; // object space

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.x = sin(o.uv.x * _ScaleUVX + _OffsetUVX);
                o.uv.y = sin(o.uv.y * _ScaleUVY + _OffsetUVY);
                
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                // fixed4 col = fixed4(i.color.r, 0, i.color.b, 1);
                // fixed4 col = fixed4((i.vertex.x - 200) / 1000, 0, (i.vertex.y - 500) / 1000, 1); // screen space
                // fixed4 col = tex2D(_GrabTexture, i.uv);

                fixed4 col = tex2D(_MainTex, i.uv) * tex2D(_GrabTexture, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
