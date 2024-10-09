Shader"Joshua/ToonShader"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (1, 1, 1, 1)
        _RampTex ("Ramp Texture", 2D) = "white" {}
        _LineSpeed ("Line Speed", Float) = 1.0 // Speed of the scanning lines
        _LineFrequency ("Line Frequency", Float) = 10.0 // Frequency of scan lines
        _LineColor ("Line Color", Color) = (0, 1, 1, 1) // Color of the scan lines
    }
    SubShader
    {
        Tags { "RenderPipeline" = "UniversalRenderPipeline" "RenderType" = "Opaque" }
    Pass
    {
        HLSLPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        // Vertex input structure
        struct Attributes
        {
            float4 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float2 uv : TEXCOORD1;
        };
       
        // Variables passed from vertex to fragment shader
        struct Varyings
        {
            float4 positionHCS : SV_POSITION; // Homogeneous clip-space position
            float3 normalWS : TEXCOORD0; // World space normal
            float2 uv : TEXCOORD1;
        };
        // Declare the base texture and sampler
        TEXTURE2D(_RampTex);
        SAMPLER(sampler_RampTex);
        float _LineSpeed;
        float _LineFrequency;
        float4 _LineColor;
        CBUFFER_START(UnityPerMaterial)
        float4 _BaseColor;
        CBUFFER_END
        // Vertex Shader
        Varyings vert(Attributes IN)
        {
            Varyings OUT;
            // Transform object space position to homogeneous clip space
            OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
            // Transform the object space normal to world space
            OUT.normalWS = normalize(TransformObjectToWorldNormal(IN.normalOS));
            OUT.uv = IN.uv;
            return OUT;
        }

        // Fragment Shader
        half4 frag(Varyings IN) : SV_Target
        {
        // Fetch main light direction and color
            Light mainLight = GetMainLight();
            half3 lightDirWS = normalize(mainLight.direction);
            half3 lightColor = mainLight.color;
        // Calculate Lambertian diffuse lighting (NdotL)
            half NdotL = saturate(dot(IN.normalWS, lightDirWS));
        // Sample the ramp texture using NdotL to get the correct shade
            half rampValue = SAMPLE_TEXTURE2D(_RampTex, sampler_RampTex, float2(NdotL, 0)).r;
        // Scrolling lines effect
            float lineValue = sin(IN.uv.y * _LineFrequency + _Time.y * _LineSpeed);
            half3 lineColor = _LineColor.rgb * step(0.5, lineValue);
        // Multiply the base color by the ramp value and light color
            half3 finalColor = _BaseColor.rgb * lightColor * rampValue + lineColor;
        
        // Return the final color with alpha
            return half4(finalColor, _BaseColor.a);
        }
        ENDHLSL
        }
    }
}