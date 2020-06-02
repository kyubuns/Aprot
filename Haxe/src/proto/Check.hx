package proto;

import aprotHx.*;
import aprotHx.type.*;
import proto.inputContext.*;
import proto.outputContext.*;
import proto.component.*;

class Check
{
	static public function main(): Void
	{
		trace("Check.main");

		var serializer = new hxbitmini.Serializer();
		var entities = serializer.unserialize(haxe.io.Bytes.ofString(Main.createInitEntities()), EntityList);

		printEntities(entities);

		var time = new Time(1.0);
		var v1 = new Vector2();
		v1.x = 1;
		v1.y = 0;
		var input = new Input(v1);
		var inputContext = new InputContext(time, input);

		var serializedEntities = serializer.serialize(entities).toString();
		var serializedInputContext = serializer.serialize(inputContext).toString();
		var output = Main.update(serializedInputContext, serializedEntities);
		var outputContext = serializer.unserialize(haxe.io.Bytes.ofString(output[1]), OutputContext);
		var updatedEntities = serializer.unserialize(haxe.io.Bytes.ofString(output[2]), EntityList);

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
