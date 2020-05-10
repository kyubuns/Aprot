package proto.system;

import aprotHx.*;
import aprotHx.type.*;
import proto.inputContext.InputContext;
import proto.outputContext.OutputContext;
import proto.component.*;

class RenderSystem implements aprotHx.System
{
	public function new() {}

	public function update(context: Context<InputContext, OutputContext>, entities: Array<Entity1<Transform>>)
	{
		var tmp = new Array<Vector2>();
		for (entity in entities)
		{
			tmp.push(entity.value1.position);
		}
		context.output.renderer.queue.value = tmp;
	}
}
