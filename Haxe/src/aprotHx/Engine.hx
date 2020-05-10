package aprotHx;

import haxe.Serializer;
import haxe.Unserializer;

class Engine
{
	@:generic
	public static function update<TInputContext, TOutputContext>(inputContext: TInputContext, serializedEntities: String, outputContext: TOutputContext,
			systems: Array<System>): OutputWorld<TOutputContext>
	{
		var entities = cast(Unserializer.run(serializedEntities), EntityList);
		var context = new Context<TInputContext, TOutputContext>(inputContext, outputContext);

		for (system in systems)
		{
			system.updateInternal(context, entities);
		}
		var outputWorld = new OutputWorld<TOutputContext>(outputContext, Serializer.run(entities));
		return outputWorld;
	}
}
