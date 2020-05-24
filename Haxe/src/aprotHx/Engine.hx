package aprotHx;

import haxe.Serializer;
import haxe.Unserializer;

class Engine
{
	@:generic
	public static function update<TInputContext, TOutputContext>(inputContext: TInputContext, entities: EntityList, outputContext: TOutputContext,
			systems: Array<System>): OutputWorld<TOutputContext>
	{
		var context = new Context<TInputContext, TOutputContext>(inputContext, outputContext);

		for (system in systems)
		{
			system.updateInternal(context, entities);
		}
		var outputWorld = new OutputWorld<TOutputContext>(outputContext, entities);
		return outputWorld;
	}
}
