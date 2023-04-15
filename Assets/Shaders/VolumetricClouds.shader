Shader "haslo/VolumetricClouds" {
    Properties {
        _Scale ("Scale", Range(0.1, 10.0)) = 2.0
        _StepScale ("Step Scale", Range(0.1, 10.0)) = 2.0
        _Steps ("Steps", Range(1, 200)) = 60
        _MinHeight ("Min Height", Range(-10, 10)) = 0
        _MaxHeight ("Max Height", Range(-10, 10)) = 10
        _FadeDist ("Fade Distance", Range(0, 10)) = 0.5
        _SunDir ("Sun Direction", Vector) = (1, 0, 0, 0)
    }
    
    SubShader {
        Tags {
            "Queue" = "Transparent"
        }

        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off Lighting Off ZWrite Off
        ZTest Always
        
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
                float4 pos : SV_POSITION;
                float3 viewDir : TEXCOORD0;
                float4 projPos : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            float _Scale;
            float _StepScale;
            float _Steps;
            float _MinHeight;
            float _MaxHeight;
            float _FadeDist;
            float4 _SunDir;
            // sampler2D _CameraDepthTexture;

            float random(float3 value, float3 dotDirection) {
                float3 smallValue = sin(value);
                float random = dot(smallValue, dotDirection);
                random = frac(sin(random) * 761238.76321);
                return random;
            }

            float3 random3d(float3 value) {
                return float3(random(value, float3(34.123, 42.532, 84.342)),
                              random(value, float3(25.532, 23.123, 23.123)),
                              random(value, float3(75.123, 67.532, 44.342)));
            }
            
            float noise3d(float3 value) {
                value *= _Scale;
                float3 interp = frac(value);
                interp = smoothstep(0.0, 1.0, interp);

                float3 ZValues[2];
                for (int z = 0; z < 2; z++) {
                    float3 YValues[2];
                    for (int y = 0; y < 2; y++) {
                        float3 XValues[2];
                        for (int x = 0; x < 2; x++) {
                            float3 cell = floor(value) + float3(x, y, z);
                            XValues[x] = random3d(cell);
                        }
                        YValues[y] = lerp(XValues[0], XValues[1], interp.x);
                    }
                    ZValues[z] = lerp(YValues[0], YValues[1], interp.y);
                }
                const float noise = -1.4 + 2.0 * lerp(ZValues[0], ZValues[1], interp.z);
                return noise;
            }

            fixed4 integrate(fixed4 sum, float diffuse, float density, fixed4 backgroundCol, float t) {
                fixed3 lighting = fixed3(0.6, 0.68, 0.7) * 1.3 + 0.5 * fixed3(0.7, 0.5, 0.3) * diffuse;
                fixed3 colrgb = lerp(fixed3(1.0, 0.95, 0.98), fixed3(0.65, 0.65, 0.65), density);
                fixed4 col = fixed4(colrgb.rgb, density);
                col.rgb *= lighting;
                colrgb = lerp(col.rgb, backgroundCol, 1.0 - exp(0.003*t*t));
                col.a *= 0.5;
                col.rgb *= col.a;
                return sum + col * (1.0 - sum.a);
            }

            #define MARCH(steps, noiseMap, cameraPos, viewDir, backgroundCol, sum, depth, t) { \
                for (int i = 0; i < steps + 1; i++) { \
                    if (t > depth) { break; } \
                    float3 pos = cameraPos + t * viewDir; \
                    if (pos.y < _MinHeight || pos.y > _MaxHeight || sum.a > 0.99) { \
                        t += max(0.1, 0.02 * t); \
                        continue; \
                    } \
                    float density = noiseMap(pos); \
                    if (density > 0.01) { \
                        float diffuse = clamp((density - noiseMap(pos + 0.3 * _SunDir)) / 0.6, 0.0, 1.0); \
                        sum = integrate(sum, diffuse, density, backgroundCol, t); \
                    } \
                    t += max(0.1, 0.02 * t); \
                } \
            }

            #define NOISEPROC(N, P) 1.75 * N * saturate((_MaxHeight - P.y) / _FadeDist)

            float map1(float3 q) {
                float3 p = q;
                float f;
                f = 0.5 * noise3d(q);
                q = q * 2;
                f += 0.25 * noise3d(q);
                return NOISEPROC(f, p);
            }

            float map2(float3 q) {
                float3 p = q;
                float f;
                f = 0.5 * noise3d(q);
                q = q * 2;
                f += 0.25 * noise3d(q);
                q = q * 3;
                f += 0.125 * noise3d(q);
                return NOISEPROC(f, p);
            }

            float map3(float3 q) {
                float3 p = q;
                float f;
                f = 0.5 * noise3d(q);
                q = q * 2;
                f += 0.25 * noise3d(q);
                q = q * 3;
                f += 0.125 * noise3d(q);
                q = q * 4;
                f += 0.0625 * noise3d(q);
                return NOISEPROC(f, p);
            }

            float map4(float3 q) {
                float3 p = q;
                float f;
                f = 0.5 * noise3d(q);
                q = q * 2;
                f += 0.25 * noise3d(q);
                q = q * 3;
                f += 0.125 * noise3d(q);
                q = q * 4;
                f += 0.0625 * noise3d(q);
                q = q * 5;
                f += 0.03125 * noise3d(q);
                return NOISEPROC(f, p);
            }

            float map5(float3 q) {
                float3 p = q;
                float f;
                f = 0.5 * noise3d(q);
                q = q * 2;
                f += 0.25 * noise3d(q);
                q = q * 3;
                f += 0.125 * noise3d(q);
                q = q * 4;
                f += 0.0625 * noise3d(q);
                q = q * 5;
                f += 0.03125 * noise3d(q);
                q = q * 6;
                f += 0.015625 * noise3d(q);
                return NOISEPROC(f, p);
            }
            
            fixed4 raymarch(float3 cameraPos, float3 viewDir, fixed4 backgroundCol, float depth) {
                fixed4 col = fixed4(0, 0, 0, 0);
                float ct = 0;

                float3 marchPos = float3(cameraPos.x + _Time.x, cameraPos.xy); 
                
                MARCH(_Steps, map1, marchPos, viewDir, backgroundCol, col, depth, ct);
                MARCH(_Steps, map2, marchPos, viewDir, backgroundCol, col, depth * 2, ct);
                MARCH(_Steps, map3, marchPos, viewDir, backgroundCol, col, depth * 3, ct);
                MARCH(_Steps, map4, marchPos, viewDir, backgroundCol, col, depth * 4, ct);
                MARCH(_Steps, map5, marchPos, viewDir, backgroundCol, col, depth * 5, ct);
                
                return clamp(col, 0, 1);
            }

            v2f vert(appdata_base v) {
                v2f o;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.viewDir = o.worldPos.xyz - _WorldSpaceCameraPos;
                o.projPos = ComputeScreenPos(o.pos);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                float depth = 1;
                depth *= length(i.viewDir);
                // alternatively:
                // float depth = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos))));
                fixed4 col = half4(1, 1, 1, 0);
                fixed4 clouds = raymarch(_WorldSpaceCameraPos, normalize(i.viewDir) * _StepScale, col, depth);
                fixed3 mixedCol = col * (1.0 - clouds.a) + clouds.rgb;
                return fixed4(mixedCol, clouds.a);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
