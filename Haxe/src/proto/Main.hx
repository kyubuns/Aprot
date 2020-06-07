package proto;

import haxe.io.Bytes;
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

	static public function createInitEntitiesNative(): EntityList
	{
		var entities = new EntityList();

		var entity1 = new Array<Component>();
		entity1.push(new Transform(new Vector2(-1, -4)));
		entity1.push(new Velocity(new Vector2(1, 1)));
		entities.add(entity1);

		var entity2 = new Array<Component>();

		entity2.push(new Transform(new Vector2(9, 2)));
		entities.add(entity2);

		return entities;
	}

	static public function createInitEntities(): String
	{
		var serializer = new hxbitmini.Serializer();
		return serializer.serialize(createInitEntitiesNative()).toHex();
	}

	static public function updateNative(inputContext: InputContext, entities: EntityList): OutputContext
	{
		var outputContext = createOutputContext();
		Engine.update(inputContext, entities, outputContext, createSystems());
		return outputContext;
	}

	static public function update(serializedInputContext: String, serializedEntities: String): NativeArray<String>
	{
		var serializer = new hxbitmini.Serializer();
		var inputContext = serializer.unserialize(haxe.io.Bytes.ofHex(serializedInputContext), InputContext);
		var entities = serializer.unserialize(haxe.io.Bytes.ofHex(serializedEntities), EntityList);
		var outputContext = updateNative(inputContext, entities);
		return [
			serializer.serialize(outputContext).toHex(),
			serializer.serialize(entities).toHex()
		];
	}
}
