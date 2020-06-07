package aprotHx;

class Context<TInputContext, TOutputContext, TSceneContext>
{
	public function new(input: TInputContext, output: TOutputContext, scene: TSceneContext)
	{
		this.input = input;
		this.output = output;
		this.scene = scene;
	}

	public var input: TInputContext;
	public var output: TOutputContext;
	public var scene: TSceneContext;
}
