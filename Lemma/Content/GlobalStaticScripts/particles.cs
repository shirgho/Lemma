
ParticleSystem.Add(main, "InfectedShatter",
new ParticleSystem.ParticleSettings
{
	TextureName = "Particles\\spark",
	MaxParticles = 1000,
	Duration = TimeSpan.FromSeconds(1.0f),
	MinHorizontalVelocity = -4.0f,
	MaxHorizontalVelocity = 4.0f,
	MinVerticalVelocity = 0.0f,
	MaxVerticalVelocity = 5.0f,
	Gravity = new Vector3(0.0f, -8.0f, 0.0f),
	MinRotateSpeed = -2.0f,
	MaxRotateSpeed = 2.0f,
	MinStartSize = 0.1f,
	MaxStartSize = 0.3f,
	MinEndSize = 0.0f,
	MaxEndSize = 0.0f,
	BlendState = Microsoft.Xna.Framework.Graphics.BlendState.Additive,
	MinColor = new Vector4(2.0f, 0.75f, 0.75f, 1.0f),
	MaxColor = new Vector4(2.0f, 0.75f, 0.75f, 1.0f),
});

ParticleSystem.Add(main, "WhiteShatter",
new ParticleSystem.ParticleSettings
{
	TextureName = "Particles\\spark",
	MaxParticles = 1000,
	Duration = TimeSpan.FromSeconds(1.0f),
	MinHorizontalVelocity = -4.0f,
	MaxHorizontalVelocity = 4.0f,
	MinVerticalVelocity = 0.0f,
	MaxVerticalVelocity = 5.0f,
	Gravity = new Vector3(0.0f, -8.0f, 0.0f),
	MinRotateSpeed = -2.0f,
	MaxRotateSpeed = 2.0f,
	MinStartSize = 0.1f,
	MaxStartSize = 0.3f,
	MinEndSize = 0.0f,
	MaxEndSize = 0.0f,
	BlendState = Microsoft.Xna.Framework.Graphics.BlendState.Additive,
	MinColor = new Vector4(1.5f, 1.25f, 1.0f, 1.0f),
	MaxColor = new Vector4(1.5f, 1.25f, 1.0f, 1.0f),
});