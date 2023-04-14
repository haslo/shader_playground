Shader "haslo/EffectsWaves" {
    Properties {
      _MainTex("Main Texture", 2D) = "white" {}
      _FoamTex("Foam Texture", 2D) = "white" {}
      _Tint("Color Tint", Color) = (1,1,1,1)
      _Freq("Frequency", Range(0,5)) = 3
      _Speed("Speed",Range(0,100)) = 10
      _Amp("Amplitude",Range(0,1)) = 0.5
    }
    SubShader {
      CGPROGRAM
      #pragma surface surf Lambert vertex:vert 
      
      struct Input {
          float2 uv_MainTex;
          float3 vertColor;
      };
      
      float4 _Tint;
      float _Freq;
      float _Speed;
      float _Amp;

      struct appdata {
          float4 vertex: POSITION;
          float3 normal: NORMAL;
          float4 texcoord: TEXCOORD0;
          float4 texcoord1: TEXCOORD1;
          float4 texcoord2: TEXCOORD2;
      };
      
      void vert (inout appdata v, out Input o) {
          UNITY_INITIALIZE_OUTPUT(Input,o);
          float tX = _Time * _Speed;
          float tZ = (_Time * 0.5) * _Speed;
          float waveHeightX = sin(tX + v.vertex.x * _Freq) * _Amp;
          float waveHeightZ = sin(tZ + v.vertex.z * _Freq) * _Amp;
          v.vertex.y = v.vertex.y + waveHeightX + waveHeightZ;
          v.normal = normalize(float3(v.normal.x + waveHeightX, v.normal.y, v.normal.z + waveHeightZ));
          o.vertColor = (waveHeightX + waveHeightZ) * 5 + 2;

      }

      sampler2D _MainTex;
      sampler2D _FoamTex;
      
      void surf (Input IN, inout SurfaceOutput o) {
          float2 mainuv = IN.uv_MainTex + float2(_Time.y * 0.05, _SinTime.z * 0.1);
          float4 maincolor = tex2D(_MainTex, mainuv);
          float2 foamuv = IN.uv_MainTex + float2(_Time.y * 0.05 + _SinTime.z * 0.02, _SinTime.z * 0.1 + _SinTime.w * 0.02);
          float4 foamcolor = tex2D(_FoamTex, foamuv);
          float4 color = (maincolor + (foamcolor * foamcolor)) / 2;
          o.Albedo = color * IN.vertColor.rgb;
      }
      ENDCG

    } 
    Fallback "Diffuse"
  }
