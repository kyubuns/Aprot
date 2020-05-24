package proto;

import aprotHx.*;
import haxe.Serializer;
import haxe.Unserializer;
import aprotHx.type.*;
import proto.inputContext.*;
import proto.outputContext.*;
import proto.component.*;

class Check
{
	static public function main(): Void
	{
		trace("Check.main");

		var entities = Unserializer.run(Main.createInitEntities());

		printEntities(entities);

		var time = new Time(1.0);
		var input = new Input(new Vector2(1.0, 0.0));
		var inputContext = new InputContext(time, input);

		var serializedEntities = Serializer.run(entities);
		var serializedInputContext = Serializer.run(inputContext);
		var outputString = Main.update(serializedInputContext, serializedEntities);
		var outputContext = cast(Unserializer.run(outputString[0]), OutputContext);
		var updatedEntities = cast(Unserializer.run(outputString[1]), EntityList);

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
