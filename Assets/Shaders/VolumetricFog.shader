Shader "haslo/VolumetricFog" {
    Properties {
        _FogCenter ("Fog Center/Radius", Vector) = (0, 0, 0, 0.5)
        _FogColor ("Fog Colour", Color) = (1, 1, 1, 1)
        _InnerRatio ("Inner Ratio", Range(0.0, 0.9)) = 0.5
        _Density ("Density", Range(0.0, 1.0)) = 0.5
        _NumSteps ("Number of Steps", Range(1, 50)) = 10
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
            
            float4 _FogCenter;
            fixed4 _FogColor;
            float _InnerRatio;
            float _Density;
            sampler2D _CameraDepthTexture;
            float _NumSteps;

            float CalculateFogIntensity(float3 sphere_center,
                                        float sphere_radius,
                                        float inner_ratio,
                                        float density,
                                        float3 camera_position,
                                        float3 view_direction,
                                        float max_distance) {
                // calculate ray/sphere intersections
                const float3 local_cam = camera_position - sphere_center;
                float a = dot(view_direction, view_direction);
                float b = 2 * dot(view_direction, local_cam);
                float c = dot(local_cam, local_cam) - sphere_radius * sphere_radius;
                float d = b * b - 4 * a * c;
                if (d <= 0.0f) {
                    return 0.0f;
                }
                float d_sqrt = sqrt(d);
                float dist1 = max((-b - d_sqrt) / 2 * a, 0);
                float dist2 = max((-b + d_sqrt) / 2 * a, 0);

                float back_depth = min(dist2, max_distance);
                float sample = dist1;
                float step_distance = (back_depth - dist1) / _NumSteps;
                float step_contribution = density;

                float center_value = 1 / (1 - inner_ratio);

                float clarity = 1;
                for (int segment = 0; segment < _NumSteps; segment++) {
                    float3 position = local_cam + view_direction * sample;
                    float val = saturate(center_value * (1 - length(position) / sphere_radius));
                    float fog_amount = saturate(val * step_contribution);
                    clarity *= 1 - fog_amount;
                    sample += step_distance;
                }
                return 1 - clarity;
            }
            
            struct v2f {
                float3 viewDir : TEXCOORD0;
                float4 pos : SV_POSITION;
                float4 projPos : TEXCOORD1;
            };

            v2f vert(appdata_base v) {
                v2f o;
                float4 wPos = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.viewDir = wPos.xyz - _WorldSpaceCameraPos;
                o.projPos = ComputeScreenPos(o.pos);

                // paint from inside, too (platform independently)
                // https://docs.unity3d.com/Manual/SL-Platform-Differences.html
                float inFrontOf = (o.pos.z / o .pos.w) > 0;
                o.pos.z *= inFrontOf;
                
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                half4 col = half4(1, 1, 1, 1);
                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
