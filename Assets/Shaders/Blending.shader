Shader "haslo/Blending" {
    Properties {
        _MainTex ("Texture", 2D) = "black" {}
    }
    SubShader {
        Tags {
            "Queue" = "Transparent"
        }

        // Blend SrcAlpha OneMinusSrcAlpha
        Blend DstColor Zero
        // see https://docs.unity3d.com/Manual/SL-Blend.html
        Cull off

        Pass {
            SetTexture [_MainTex] { combine texture }
        }
    }
    // FallBack "Diffuse"
}
