package proto.system;

import proto.outputContext.Renderer;
import aprotHx.*;
import aprotHx.type.*;
import proto.inputContext.InputContext;
import proto.outputContext.OutputContext;
import proto.sceneContext.SceneContext;
import proto.component.*;

class RenderSystem extends aprotHx.System
{
	public function new()
	{
	}

	public function update(context: Context<InputContext, OutputContext, SceneContext>, entities: Array<RefEntity<Transform, Material>>)
	{
		var tmp = new Array<RenderElement>();
		for (entity in entities)
		{
			tmp.push(new RenderElement(entity.transform.position, entity.material.color));
		}
		context.output.renderer.queue.value = tmp;
	}
}
