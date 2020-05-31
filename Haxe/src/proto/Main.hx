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

	static public function createInitEntities(): BytesData
	{
		var entities = new EntityList();

		var entity1 = new Array<Component>();
		entity1.push(new Transform(new Vector2(1, 5)));
		entity1.push(new Velocity(new Vector2(2, 2)));
		entities.add(entity1);

		var entity2 = new Array<Component>();

		entity2.push(new Transform(new Vector2(9, 2)));
		entities.add(entity2);

		var serializer = new hxbit.Serializer();
		return serializer.serialize(entities).getData();
	}

	static public function update(serializedInputContext: BytesData, serializedEntities: BytesData): Array<BytesData>
	{
		var serializer = new hxbit.Serializer();
		var inputContext = serializer.unserialize(haxe.io.Bytes.ofData(serializedInputContext), InputContext);
		var entities = serializer.unserialize(haxe.io.Bytes.ofData(serializedEntities), EntityList);
		var outputContext = createOutputContext();
		Engine.update(inputContext, entities, outputContext, createSystems());
		return [
			serializer.serialize(outputContext).getData(),
			serializer.serialize(entities).getData()
		];
	}
}
