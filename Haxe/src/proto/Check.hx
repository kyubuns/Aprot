package proto;

import aprotHx.*;
import aprotHx.type.*;
import proto.inputContext.*;
import proto.outputContext.*;
import proto.sceneContext.*;
import proto.component.*;

class Check
{
	static public function main(): Void
	{
		trace("Check.main");

		final serializer = new hxbitmini.Serializer();
		final entities = serializer.unserialize(haxe.io.Bytes.ofHex(Main.createInitEntities()), EntityList);
		final sceneContext = serializer.unserialize(haxe.io.Bytes.ofHex(Main.createInitSceneContext()), SceneContext);

		printEntities(entities);

		final time = new Time(1.0);
		final inputContext = new InputContext(time, [Key.Up]);

		final serializedEntities = serializer.serialize(entities).toHex();
		final serializedInputContext = serializer.serialize(inputContext).toHex();
		final serializedSceneContext = serializer.serialize(sceneContext).toHex();
		final output = Main.update(serializedInputContext, serializedSceneContext, serializedEntities);
		final outputContext = serializer.unserialize(haxe.io.Bytes.ofHex(output[0]), OutputContext);
		final sceneContext = serializer.unserialize(haxe.io.Bytes.ofHex(output[1]), SceneContext);
		final updatedEntities = serializer.unserialize(haxe.io.Bytes.ofHex(output[2]), EntityList);

		printEntities(updatedEntities);
	}

	static private function printEntities(entities: EntityList): Void
	{
		trace("print entities");
		for (entity in entities.entities.value)
		{
			trace('-- entity ${entity.id}');
			for (component in entity.components.value)
			{
				trace('---- component: ${component} ${haxe.Json.stringify(component)}');
			}
		}
	}
}
