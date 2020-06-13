package aprotHx;

class Engine
{
	@:generic
	public static function update<TInputContext, TOutputContext, TSceneContext>(inputContext: TInputContext, outputContext: TOutputContext,
			sceneContext: TSceneContext, entities: EntityList, systems: Array<System>): Void
	{
		var context = new Context<TInputContext, TOutputContext, TSceneContext>(inputContext, outputContext, sceneContext, entities);

		for (system in systems)
		{
			system.updateInternal(context, entities);
		}
	}
}
