Shader "haslo/EffectsWaves" {
    Properties {
      _MainTex("Diffuse", 2D) = "white" {}
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
          float tZ = _Time * _Speed * 0.5;
          float waveHeightX = sin(tX + v.vertex.x * _Freq) * _Amp;
          float waveHeightZ = sin(tZ + v.vertex.z * _Freq) * _Amp;
          v.vertex.y = v.vertex.y + waveHeightX + waveHeightZ;
          v.normal = normalize(float3(v.normal.x + waveHeightX, v.normal.y, v.normal.z + waveHeightZ));
          o.vertColor = (waveHeightX + waveHeightZ) * 5 + 2;

      }

      sampler2D _MainTex;
      void surf (Input IN, inout SurfaceOutput o) {
          float2 newuv = IN.uv_MainTex + float2(_Time.y * 0.05, _SinTime.z * 0.1);
          float4 c = tex2D(_MainTex, newuv);
          o.Albedo = c * IN.vertColor.rgb;
      }
      ENDCG

    } 
    Fallback "Diffuse"
  }
