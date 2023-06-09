Shader "haslo/VolumetricFog" {
    Properties {
        _FogCenter ("Fog Center/Radius", Vector) = (0, 0, 0, 0.5)
        _FogColor ("Fog Colour", Color) = (1, 1, 1, 1)
        _InnerRatio ("Inner Ratio", Range(0.0, 0.9)) = 0.5
        _Density ("Density", Range(0.0, 10.0)) = 5
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

            float calculate_fog_intensity(float3 sphere_center,
                                        float sphere_radius,
                                        float inner_ratio,
                                        float density,
                                        float3 camera_position,
                                        float3 view_direction,
                                        float max_distance,
                                        float num_steps) {
                // calculate ray/sphere intersections
                const float3 local_cam = camera_position - sphere_center;
                float a = dot(view_direction, view_direction);
                float b = 2 * dot(view_direction, local_cam);
                float c = dot(local_cam, local_cam) - sphere_radius * sphere_radius;
                float d = b * b - 4 * a * c;
                if (d <= 0) {
                    return 0;
                }
                const float d_sqrt = sqrt(d);
                const float dist1 = max((-b - d_sqrt) / 2 * a, 0);
                const float dist2 = max((-b + d_sqrt) / 2 * a, 0);

                const float back_depth = min(dist2, max_distance);
                float sample = dist1;
                const float step_distance = (back_depth - dist1) / num_steps;
                const float step_contribution = density / num_steps;

                const float center_value = 1 / (1 - inner_ratio);

                float clarity = 1;
                for (int segment = 0; segment < num_steps; segment++) {
                    const float3 position = local_cam + view_direction * sample;
                    const float val = saturate(center_value * (1 - length(position) / sphere_radius));
                    const float fog_amount = saturate(val * step_contribution);
                    clarity *= 1 - fog_amount;
                    sample += step_distance;
                }
                return 1 - clarity;
            }
                        
            float4 _FogCenter;
            fixed4 _FogColor;
            float _InnerRatio;
            float _Density;
            sampler2D _CameraDepthTexture;
            float _NumSteps;

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
                const float in_front_of = (o.pos.z / o.pos.w) > 0;
                o.pos.z *= in_front_of;
                
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                half4 col = half4(1, 1, 1, 1);
                const float depth = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos))));
                const float3 view_dir = normalize(i.viewDir);

                const float fog_alpha = calculate_fog_intensity(_FogCenter.xyz,
                                                                _FogCenter.w,
                                                                _InnerRatio,
                                                                _Density,
                                                                _WorldSpaceCameraPos,
                                                                view_dir,
                                                                depth,
                                                                _NumSteps);
                col.rgb = _FogColor.rgb;
                col.a = fog_alpha;
                
                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
