package proto;

import proto.inputContext.InputContext;
import proto.sceneContext.SceneContext;
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
		final renderer = new Renderer();
		return new OutputContext(renderer);
	}

	static private function createSystems(): Array<System>
	{
		return [new MoveSystem(), new Dummy2System(), new RenderSystem()];
	}

	static public function createInitEntitiesNative(): EntityList
	{
		final entities = new EntityList();

		final entity1 = new Array<Component>();
		entity1.push(new Transform(new Vector2(0, 1)));
		entity1.push(new Scene(0));
		entities.add(entity1);

		return entities;
	}

	static public function createInitEntities(): String
	{
		final serializer = new hxbitmini.Serializer();
		return serializer.serialize(createInitEntitiesNative()).toHex();
	}

	static public function createInitSceneContextNative(): SceneContext
	{
		return new SceneContext(0);
	}

	static public function createInitSceneContext(): String
	{
		final serializer = new hxbitmini.Serializer();
		return serializer.serialize(createInitSceneContextNative()).toHex();
	}

	static public function updateNative(inputContext: InputContext, sceneContext: SceneContext, entities: EntityList): OutputContext
	{
		final outputContext = createOutputContext();
		Engine.update(inputContext, outputContext, sceneContext, entities, createSystems());
		return outputContext;
	}

	static public function update(serializedInputContext: String, serializedSceneContext: String, serializedEntities: String): NativeArray<String>
	{
		final serializer = new hxbitmini.Serializer();
		final inputContext = serializer.unserialize(haxe.io.Bytes.ofHex(serializedInputContext), InputContext);
		final sceneContext = serializer.unserialize(haxe.io.Bytes.ofHex(serializedSceneContext), SceneContext);
		final entities = serializer.unserialize(haxe.io.Bytes.ofHex(serializedEntities), EntityList);
		final outputContext = updateNative(inputContext, sceneContext, entities);
		return [
			serializer.serialize(outputContext).toHex(),
			serializer.serialize(sceneContext).toHex(),
			serializer.serialize(entities).toHex()
		];
	}
}
