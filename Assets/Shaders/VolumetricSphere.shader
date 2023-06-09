Shader "haslo/VolumetricSphere" {
    Properties {
        _SphereCenter ("Sphere Center/Radius", Vector) = (0, 0, 0, 0.5)
        _AmbientIntensity ("Ambient Intensity", Range(0, 1)) = 0
    }
    
    SubShader {
        Tags {
            "Queue" = "Transparent"
        }

        Blend SrcAlpha OneMinusSrcAlpha
        
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            float4 _SphereCenter;
            float _AmbientIntensity;
            
            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                // float3 normal : NORMAL;
            };

            struct v2f {
                float3 wPos : TEXCOORD0;
                float4 pos : SV_POSITION;
                // fixed4 diff : COLOR0;
            };

            v2f vert(appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                // half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                // half geometryNL = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                // o.diff = geometryNL * _LightColor0;
                return o;
            }

            #define STEPS 256
            #define STEP_SIZE 0.01

            bool SphereHit(float3 position, float3 center, float radius) {
                return distance(position, center) < radius;
            }
            
            float3 RaymarchHit(float3 position, float3 direction) {
                for(int i = 0; i < STEPS; i++) {
                    if (SphereHit(position, _SphereCenter.xyz, _SphereCenter.w)) {
                        return position;
                    }
                    position += direction * STEP_SIZE;
                }
                return float3(0, 0, 0);
            }
            
            fixed4 frag(v2f i) : SV_Target {
                float3 viewDirection = normalize(i.wPos - _WorldSpaceCameraPos);
                float3 worldPosition = i.wPos;
                float3 depth = RaymarchHit(worldPosition, viewDirection);
                
                half3 worldNormal = depth - _SphereCenter.xyz;
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));

                if (length(depth) != 0) {
                    // depth *= nl * _LightColor0 * 2;
                    // depth *= nl * _LightColor0 + 1;
                    // return fixed4(depth, 1);
                    // return fixed4(depth.x, depth.y, depth.z, 1);
                    // depth *= i.diff;
                    // return fixed4(depth, 1); 
                    return fixed4(saturate((nl * 3 + _AmbientIntensity) * _LightColor0.rgb), 1);
                } else {
                    return fixed4(1, 1, 1, 0);
                }
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
