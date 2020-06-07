package proto.system;

import aprotHx.*;
import aprotHx.type.*;
import proto.inputContext.InputContext;
import proto.outputContext.OutputContext;
import proto.sceneContext.SceneContext;
import proto.component.*;

class RenderSystem extends aprotHx.System
{
	public function new() {}

	public function update(context: Context<InputContext, OutputContext, SceneContext>, entities: Array<RefEntity<Transform>>)
	{
		var tmp = new Array<Vector2>();
		for (entity in entities)
		{
			tmp.push(entity.transform.position);
		}
		context.output.renderer.queue.value = tmp;
	}
}
