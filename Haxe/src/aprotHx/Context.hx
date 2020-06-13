package aprotHx;

class Context<TInputContext, TOutputContext, TSceneContext>
{
	public function new(input: TInputContext, output: TOutputContext, scene: TSceneContext, entities: EntityAccess)
	{
		this.input = input;
		this.output = output;
		this.scene = scene;
		this.entities = entities;
	}

	public var input: TInputContext;
	public var output: TOutputContext;
	public var scene: TSceneContext;
	public var entities: EntityAccess;
}
