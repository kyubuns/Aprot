package proto.system;

import proto.inputContext.InputContext;
import proto.outputContext.OutputContext;
import proto.component.*;
import aprotHx.*;

class Dummy1System implements aprotHx.System
{
	public function new() {}

	public function update(context: Context<InputContext, OutputContext>, entities: Array<Entity2<Transform, Velocity>>)
	{
		for (entity in entities)
		{
			entity.value1.position.x += entity.value2.vector.x * context.input.time.deltaTime;
			entity.value1.position.y += entity.value2.vector.y * context.input.time.deltaTime;
		}
	}
}
