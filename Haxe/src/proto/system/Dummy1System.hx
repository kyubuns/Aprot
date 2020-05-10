package proto.system;

import aprotHx.*;
import aprotHx.type.*;
import proto.inputContext.InputContext;
import proto.outputContext.OutputContext;
import proto.component.*;

class Dummy1System extends aprotHx.System
{
	public function new() {}

	public function dummyUpdateInternal(context: Dynamic, entityList: EntityList)
	{
		var entities = new Array<RefEntity<Transform, Velocity>>();
		for (entity in entityList.entities.value)
		{
			var refComponents = [];
			refComponents.push(entity.components.value.filter(x -> Std.is(x, Transform)));
			refComponents.push(entity.components.value.filter(x -> Std.is(x, Velocity)));
			if (refComponents.filter(x -> x.length == 0).length == 0)
			{
				entities.push(new RefEntity<Transform, Velocity>(cast(refComponents[0][0], Transform), cast(refComponents[1][0], Velocity)));
			}
		}
		update(context, entities);
	}

	public function update(context: Context<InputContext, OutputContext>, entities: Array<RefEntity<Transform, Velocity>>)
	{
		for (entity in entities)
		{
			entity.transform.position.x += entity.velocity.vector.x * context.input.time.deltaTime;
			entity.transform.position.y += entity.velocity.vector.y * context.input.time.deltaTime;
		}
	}
}
