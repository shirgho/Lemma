// Shadow map
texture2D ShadowMapTexture;
sampler2D ShadowMapSampler = sampler_state
{
	Texture = <ShadowMapTexture>;
	MinFilter = point;
	MagFilter = point;
	MipFilter = point;
	MaxAnisotropy = 1;
	AddressU = CLAMP;
	AddressV = CLAMP;
};
float ShadowMapSize;

texture2D DetailShadowMapTexture;
sampler2D DetailShadowMapSampler = sampler_state
{
	Texture = <DetailShadowMapTexture>;
	MinFilter = point;
	MagFilter = point;
	MipFilter = point;
	MaxAnisotropy = 1;
	AddressU = CLAMP;
	AddressV = CLAMP;
};
float DetailShadowMapSize;

// Shadow map sampling with simple filtering
float GetShadowValueFromClip(float2 clipPos, float depth, float bias)
{
	if (abs(clipPos.x) > 1.0f || abs(clipPos.y) > 1.0f)
		return 1.0f;

	// UV coordinates of the uppermost, leftmost pixel
	float2 pos = floor(clipPos * ShadowMapSize) / ShadowMapSize;
	
	// Collect samples from the surrounding four shadow map pixels
	// These will all evaluate to 1.0 or 0.0
	float inverseShadowSize = 1 / ShadowMapSize;
	float bl = tex2D(ShadowMapSampler, pos + float2(0, 0)).r - bias < depth; // Bottom left sample
	float br = tex2D(ShadowMapSampler, pos + float2(inverseShadowSize, 0)).r - bias < depth; // Bottom right sample
	float tl = tex2D(ShadowMapSampler, pos + float2(0, inverseShadowSize)).r - bias < depth; // Top left sample
	float tr = tex2D(ShadowMapSampler, pos + float2(inverseShadowSize, inverseShadowSize)).r - bias < depth; // Top right sample
	
	// Blend between the four samples
	float horizontalBlend = (clipPos.x - pos.x) * ShadowMapSize;
	float verticalBlend = (clipPos.y - pos.y) * ShadowMapSize;
	float bottom = (bl * (1.0f - horizontalBlend)) + (br * horizontalBlend);
	float top = (tl * (1.0f - horizontalBlend)) + (tr * horizontalBlend);
	return (bottom * (1.0f - verticalBlend)) + (top * verticalBlend);
}

// Shadow map sampling with simple filtering
float GetShadowValueFromClipDetail(float2 clipPos, float depth, float bias)
{
	if (abs(clipPos.x) > 1.0f || abs(clipPos.y) > 1.0f)
		return 1.0f;

	// UV coordinates of the uppermost, leftmost pixel
	float2 pos = floor(clipPos * DetailShadowMapSize) / DetailShadowMapSize;
	
	// Collect samples from the surrounding four shadow map pixels
	// These will all evaluate to 1.0 or 0.0
	float inverseShadowSize = 1 / DetailShadowMapSize;
	float bl = tex2D(DetailShadowMapSampler, pos + float2(0, 0)).r - bias < depth; // Bottom left sample
	float br = tex2D(DetailShadowMapSampler, pos + float2(inverseShadowSize, 0)).r - bias < depth; // Bottom right sample
	float tl = tex2D(DetailShadowMapSampler, pos + float2(0, inverseShadowSize)).r - bias < depth; // Top left sample
	float tr = tex2D(DetailShadowMapSampler, pos + float2(inverseShadowSize, inverseShadowSize)).r - bias < depth; // Top right sample
	
	// Blend between the four samples
	float horizontalBlend = (clipPos.x - pos.x) * DetailShadowMapSize;
	float verticalBlend = (clipPos.y - pos.y) * DetailShadowMapSize;
	float bottom = (bl * (1.0f - horizontalBlend)) + (br * horizontalBlend);
	float top = (tl * (1.0f - horizontalBlend)) + (tr * horizontalBlend);
	return (bottom * (1.0f - verticalBlend)) + (top * verticalBlend);
}

float GetShadowValue(float4 position, float bias)
{
	// Get the shadow map depth value for this pixel
	float depth = 1.0f - (position.z / position.w);

	// Convert from clip space to UV coordinate space
	float2 ShadowTexClipPosition = (0.5f * (position.xy / position.w)) + float2(0.5f, 0.5f);
	ShadowTexClipPosition.y = 1.0f - ShadowTexClipPosition.y;

	return GetShadowValueFromClip(ShadowTexClipPosition, depth, bias);
}

float GetShadowValueDetail(float4 detailPosition, float4 position, float bias)
{
	detailPosition.xyz /= detailPosition.w;

	if (abs(detailPosition.x) < 1.0f && abs(detailPosition.y) < 1.0f)
	{
		float2 ShadowTexClipPosition = (0.5f * detailPosition.xy) + float2(0.5f, 0.5f);

		// Convert from clip space to UV coordinate space
		ShadowTexClipPosition = (0.5f * detailPosition.xy) + float2(0.5f, 0.5f);
		ShadowTexClipPosition.y = 1.0f - ShadowTexClipPosition.y;

		float depth = 1.0f - detailPosition.z;

		return GetShadowValueFromClipDetail(ShadowTexClipPosition, depth, bias);
	}
	else
	{
		position.xyz /= position.w;

		float depth = 1.0f - position.z;

		float2 ShadowTexClipPosition = (0.5f * position.xy) + float2(0.5f, 0.5f);

		// Convert from clip space to UV coordinate space
		ShadowTexClipPosition = (0.5f * position.xy) + float2(0.5f, 0.5f);
		ShadowTexClipPosition.y = 1.0f - ShadowTexClipPosition.y;

		return GetShadowValueFromClip(ShadowTexClipPosition, depth, bias);
	}

}