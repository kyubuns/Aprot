package proto.system;

import aprotHx.*;
import aprotHx.type.*;
import proto.inputContext.InputContext;
import proto.outputContext.OutputContext;
import proto.component.*;

class Dummy1System extends aprotHx.System
{
	public function new() {}

	public function update(context: Context<InputContext, OutputContext>, entities: Array<RefEntity<Transform, Velocity>>)
	{
		for (entity in entities)
		{
			entity.transform.position.x += entity.velocity.vector.x * context.input.time.deltaTime;
			entity.transform.position.y += entity.velocity.vector.y * context.input.time.deltaTime;

			if (entity.transform.position.x < -3)
				entity.transform.position.x = 3;

			if (entity.transform.position.x > 3)
				entity.transform.position.x = -3;

			if (entity.transform.position.y < -3)
				entity.transform.position.y = 3;

			if (entity.transform.position.y > 3)
				entity.transform.position.y = -3;
		}
	}
}
