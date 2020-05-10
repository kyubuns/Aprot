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
		var dummy = new OutputWorld<TOutputContext>(outputContext, Serializer.run(entities));
		return dummy;
	}
}
