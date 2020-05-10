package proto;

import aprotHx.*;
import haxe.Serializer;
import haxe.Unserializer;
import aprotHx.type.*;
import proto.inputContext.*;
import proto.component.*;

class Check
{
	static public function main(): Void
	{
		trace("Check.main");

		var entities = new EntityList();

		var entity1 = new Array<Component>();
		entity1.push(new Transform(new Vector2(1, 5)));
		entity1.push(new Velocity(new Vector2(2, 2)));
		entities.add(entity1);

		var entity2 = new Array<Component>();
		entity2.push(new Transform(new Vector2(9, 2)));
		entities.add(entity2);

		printEntities(entities);

		var time = new Time(1.0);
		var input = new Input(new Vector2(1.0, 0.0));
		var inputContext = new InputContext(time, input);

		var serializedEntities = Serializer.run(entities);
		var serializedInputContext = Serializer.run(inputContext);
		var outputString = Main.update(serializedInputContext, serializedEntities);
		var outputWorld = Unserializer.run(outputString);

		printEntities(Unserializer.run(outputWorld.entities));
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
