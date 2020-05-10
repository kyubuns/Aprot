package proto.system;

import aprotHx.*;
import aprotHx.type.*;
import proto.inputContext.InputContext;
import proto.outputContext.OutputContext;
import proto.component.*;

class RenderSystem extends aprotHx.System
{
	public function new() {}

	public function dummyUpdateInternal(context: Dynamic, entityList: EntityList)
	{
		var entities = new Array<RefEntity<Transform>>();
		for (entity in entityList.entities.value)
		{
			var t1 = entity.components.value.filter(x -> Std.is(x, Transform));
			if (t1.length > 0)
			{
				entities.push(new RefEntity<Transform>(cast(t1[0], Transform)));
			}
		}
		update(context, entities);
	}

	public function update(context: Context<InputContext, OutputContext>, entities: Array<RefEntity<Transform>>)
	{
		var tmp = new Array<Vector2>();
		for (entity in entities)
		{
			tmp.push(entity.transform.position);
		}
		context.output.renderer.queue.value = tmp;
	}
}
