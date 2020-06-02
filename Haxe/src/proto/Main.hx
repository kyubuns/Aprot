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
		var outputContext = new OutputContext();
		return outputContext;
	}

	static private function createSystems(): Array<System>
	{
		return [new Dummy1System(), new RenderSystem()];
	}

	static public function createInitEntities(): String
	{
		var entities = new EntityList();

		var entity1 = new Array<Component>();
		var v1 = new Vector2();
		v1.x = -1;
		v1.y = -5;
		entity1.push(new Transform(v1));
		var v2 = new Vector2();
		v2.x = 0.1;
		v2.y = 0.1;
		entity1.push(new Velocity(v2));
		entities.add(entity1);

		var entity2 = new Array<Component>();
		var v3 = new Vector2();
		v3.x = 3;
		v3.y = 2;
		entity2.push(new Transform(v3));
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
