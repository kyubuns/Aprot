package proto;

import haxe.io.BytesData;
import proto.inputContext.InputContext;
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
		entity1.push(new Transform(new Vector2(-1, -5)));
		entity1.push(new Velocity(new Vector2(0.1, 0.1)));
		entities.add(entity1);

		var entity2 = new Array<Component>();

		entity2.push(new Transform(new Vector2(9, 2)));
		entities.add(entity2);

		var serializer = new hxbitmini.Serializer();
		return serializer.serialize(entities).toString();
	}

	static public function update(serializedInputContext: String, serializedEntities: String): Array<String>
	{
		var serializer = new hxbitmini.Serializer();
		var inputContext = serializer.unserialize(haxe.io.Bytes.ofString(serializedInputContext), InputContext);
		var entities = serializer.unserialize(haxe.io.Bytes.ofString(serializedEntities), EntityList);
		var outputContext = createOutputContext();
		Engine.update(inputContext, entities, outputContext, createSystems());
		return [
			"dummy",
			serializer.serialize(outputContext).toString(),
			serializer.serialize(entities).toString()
		];
	}
}
