package proto;

import haxe.Unserializer;
import proto.inputContext.InputContext;
import haxe.Serializer;
import aprotHx.*;
import aprotHx.type.*;
import proto.system.*;
import proto.outputContext.*;
import proto.component.*;

@:expose
class Main
{
	static private function createOutputContext(): OutputContext
	{
		var renderer = new Renderer();
		return new OutputContext(renderer);
	}

	static private function createSystems(): Array<System>
	{
		return [new Dummy1System(), new RenderSystem()];
	}

	static public function createInitEntities(): String
	{
		var entities = new EntityList();

		var entity1 = new Array<Component>();
		entity1.push(new Transform(new Vector2(1, 5)));
		entity1.push(new Velocity(new Vector2(2, 2)));
		entities.add(entity1);

		var entity2 = new Array<Component>();

		entity2.push(new Transform(new Vector2(9, 2)));
		entities.add(entity2);

		return Serializer.run(entities);
	}

	static public function update(serializedInputContext: String, serializedEntities: String): Array<String>
	{
		var inputContext = cast(Unserializer.run(serializedInputContext), InputContext);
		var entities = cast(Unserializer.run(serializedEntities), EntityList);
		trace("update!!!!!!!!");
		trace(entities);
		var outputContext = createOutputContext();
		Engine.update(inputContext, entities, outputContext, createSystems());
		trace("1");
		trace(outputContext);
		var a = Serializer.run(outputContext);
		trace("2");
		trace(entities);
		var b = Serializer.run(entities);
		trace("3");
		return [Serializer.run(outputContext), Serializer.run(entities)];
	}
}
