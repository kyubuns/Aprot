package proto;

import haxe.Unserializer;
import proto.inputContext.InputContext;
import haxe.Serializer;
import aprotHx.*;
import proto.system.*;
import proto.outputContext.*;

class Main
{
	static public function createOutputContext(): OutputContext
	{
		var renderer = new Renderer();
		return new OutputContext(renderer);
	}

	static public function createSystems(): Array<System>
	{
		return [new Dummy1System(), new RenderSystem()];
	}

	static public function update(serializedInputContext: String, serializedEntities: String): String
	{
		var inputContext = cast(Unserializer.run(serializedInputContext), InputContext);
		var entities = cast(Unserializer.run(serializedEntities), EntityList);
		var outputWorld = Engine.update(inputContext, entities, createOutputContext(), createSystems());
		return Serializer.run(outputWorld);
	}
}
