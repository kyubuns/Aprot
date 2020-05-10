package proto;

import haxe.Serializer;
import haxe.Unserializer;
import aprotHx.*;
import proto.system.*;
import proto.outputContext.*;

class Main
{
	static public function update(input: String): String
	{
		var outputContext = createOutputContext();
		var inputWorld = cast(Unserializer.run(input), InputWorld);
		var entities = Unserializer.run(inputWorld.entities);
		var context = new Context(inputWorld.context, outputContext);
		var outputWorld = new OutputWorld(outputContext, Serializer.run(entities));
		return Serializer.run(outputWorld);
	}

	static public function createOutputContext(): OutputContext
	{
		var renderer = new Renderer();
		return new OutputContext(renderer);
	}

	static public function createSystems(): Array<System>
	{
		return [new Dummy1System()];
	}
}
