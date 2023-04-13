Shader "haslo/FirstVertexFragment" {
    Properties {
        _MainTex ("Main Texture", 2D) = "white" {}
    }

    SubShader {
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

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // o.color.r = (v.vertex.x + 5) / 10; // object space
                // o.color.b = (v.vertex.z + 5) / 10; // object space
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                // fixed4 col = fixed4(i.color.r, 0, i.color.b, 1);
                // fixed4 col = fixed4((i.vertex.x - 200) / 1000, 0, (i.vertex.y - 500) / 1000, 1); // screen space
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
