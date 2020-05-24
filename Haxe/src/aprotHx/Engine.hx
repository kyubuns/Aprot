package aprotHx;

class Engine
{
	@:generic
	public static function update<TInputContext, TOutputContext>(inputContext: TInputContext, entities: EntityList, outputContext: TOutputContext,
			systems: Array<System>): Void
	{
		var context = new Context<TInputContext, TOutputContext>(inputContext, outputContext);

		for (system in systems)
		{
			system.updateInternal(context, entities);
		}
	}
}
