Shader "haslo/DotProduct"
{
    Properties
    {
        _rimColor ("rimColor", Color) = (0, 0.5, 0.5, 0.0)
        _rimPower ("Rim Power", Range(0.5, 8)) = 3
        _stripeSize ("Stripe Size", Range(0.1, 2)) = 0.5
        _texture ("Texture", 2D) = "white" {}
        _texLevel ("Tex Level", Range(0, 5)) = 1
        _texScale ("Texture Scale", Range(0, 10)) = 1
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float3 viewDir;
            float3 worldPos;
            float2 uv_texture;
        };

        float4 _rimColor;
        half _rimPower;
        half _stripeSize;
        sampler2D _texture;
        half _texLevel;
        half _texScale;

        void surf(Input IN, inout SurfaceOutput o)
        {
            // half dotp = dot(IN.viewDir, o.Normal);
            // o.Albedo = float3(1 - dotp, dotp, 1);
            // o.Albedo = float3(dot(IN.viewDir,o.Normal),1,1-dot(IN.viewDir,o.Normal));
            // o.Albedo.r = 1-dot(IN.viewDir,o.Normal);
            half rim = 1 - saturate(dot(normalize(IN.viewDir), normalize(o.Normal)));
            // o.Emission = _rimColor.rgb * pow(rim, _rimPower);
            // o.Emission = _rimColor.rgb * rim > 0.5 ? rim : 0;
            o.Emission = frac(IN.worldPos.y * 10 * _stripeSize) >= (_stripeSize) ? float3(0, 1, 0) * pow(rim, _rimPower) : float3(1, 0, 0) * pow(rim, _rimPower);
            o.Albedo.rgb = (tex2D(_texture, IN.uv_texture.yx * _texScale) * _texLevel).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
