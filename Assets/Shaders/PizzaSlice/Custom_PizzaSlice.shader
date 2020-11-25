Shader "Custom/Pizza Slice"
{
    Properties
    {
        _BaseMap ("Base Map", 2D) = "white" {}
        _BaseColor ("Base Color", Color) = (1,1,1,1)
        _AngleStart ("Angle Start", Range(0.0, 1.0)) = 0.0
        _FillAmount ("Fill Amount", Range(0.0, 1.0)) = 0.7
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            TEXTURE2D(_BaseMap); SAMPLER(sampler_BaseMap); float4 _BaseMap_ST;
            half4 _BaseColor;
            float _AngleStart; float _FillAmount;

            Varyings vert(Attributes input)
            {
                Varyings output = (Varyings)0;
                output.uv = TRANSFORM_TEX(input.texcoord, _BaseMap);

                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                output.positionCS = vertexInput.positionCS;

                return output;
            }

            half4 frag (Varyings input) : SV_Target
            {
                half4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.uv) * _BaseColor;

                float2 tocenter = (float2)0.5 - input.uv;
                float angle = atan2(tocenter.y, tocenter.x) / 6.2831853072 + 0.5;
                float radius = length(tocenter);

                angle = (angle + _AngleStart) % 1;
                angle = 1 - step(_FillAmount, angle);
                radius = 1 - step(0.5, radius);

                clip(radius * angle - 0.01);

                return color;
            }
            ENDHLSL
        }
    }
}
