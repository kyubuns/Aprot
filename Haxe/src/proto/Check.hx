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

		var serializer = new hxbit.Serializer();
		var entities = serializer.unserialize(haxe.io.Bytes.ofData(Main.createInitEntities()), EntityList);

		printEntities(entities);

		var time = new Time(1.0);
		var input = new Input(new Vector2(1.0, 0.0));
		var inputContext = new InputContext(time, input);

		var serializedEntities = serializer.serialize(entities).getData();
		var serializedInputContext = serializer.serialize(inputContext).getData();
		var output = Main.update(serializedInputContext, serializedEntities);
		var outputContext = serializer.unserialize(haxe.io.Bytes.ofData(output[0]), OutputContext);
		var updatedEntities = serializer.unserialize(haxe.io.Bytes.ofData(output[1]), EntityList);

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
