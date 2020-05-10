package proto;

import aprotHx.type.Vector2;
import haxe.Serializer;
import haxe.Unserializer;
import proto.component.*;

class Main
{
	static public function main(): Void
	{
		var entities = new Array<Array<Dynamic>>();

		var entity1 = new Array<Dynamic>();
		entity1.push(new Transform(new Vector2(1, 5)));
		entity1.push(new Velocity(new Vector2(2, 2)));
		entities.push(entity1);

		var entity2 = new Array<Dynamic>();
		entity2.push(new Transform(new Vector2(9, 2)));
		entities.push(entity2);

		printEntities(entities);

		var serializedEntities = Serializer.run(entities);
		var inputWorld = new InputWorld(serializedEntities);
		var inputString = Serializer.run(inputWorld);
		var outputString = update(inputString);
		var outputWorld = Unserializer.run(outputString);

		printEntities(Unserializer.run(outputWorld.entities));
	}

	static private function printEntities(entities: Array<Array<Dynamic>>): Void
	{
		trace("print entities");
		for (entity in entities)
		{
			trace("-- entity");
			for (component in entity)
			{
				trace('---- component: ${component} ${haxe.Json.stringify(component)}');
			}
		}
	}

	static public function update(input: String): String
	{
		var inputWorld = Unserializer.run(input);
		var entities = Unserializer.run(inputWorld.entities);
		var outputWorld = new OutputWorld(Serializer.run(entities));
		return Serializer.run(outputWorld);
	}
}
