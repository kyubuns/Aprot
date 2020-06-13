package proto.system;

import proto.inputContext.Key;
import aprotHx.*;
import aprotHx.type.*;
import proto.inputContext.InputContext;
import proto.outputContext.OutputContext;
import proto.sceneContext.SceneContext;
import proto.component.*;

class MoveSystem extends aprotHx.System
{
	public function new()
	{
	}

	public function update(context: Context<InputContext, OutputContext, SceneContext>, entities: Array<RefEntity<Transform, Scene, Material>>)
	{
		for (entity in entities)
		{
			if (entity.scene.scene != context.scene.scene)
				continue;

			if (context.input.keys.contains(Key.Up))
			{
				shadow(context, entity);
				entity.transform.position.y += 1.0;
			}
			if (context.input.keys.contains(Key.Down))
			{
				shadow(context, entity);
				entity.transform.position.y -= 1.0;
			}
			if (context.input.keys.contains(Key.Right))
			{
				shadow(context, entity);
				entity.transform.position.x += 1.0;
			}
			if (context.input.keys.contains(Key.Left))
			{
				shadow(context, entity);
				entity.transform.position.x -= 1.0;
			}
		}
	}

	private function shadow(context: Context<InputContext, OutputContext, SceneContext>, entity: RefEntity<Transform, Scene, Material>)
	{
		context.scene.shadow.push(new BoxShadow(0.0, entity.transform.position.copy(), entity.material.color));
	}
}
