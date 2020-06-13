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
	public function new() {}

	public function update(context: Context<InputContext, OutputContext, SceneContext>, entities: Array<RefEntity<Transform, Scene>>)
	{
		for (entity in entities)
		{
			if (entity.scene.scene != context.scene.scene)
				continue;

			if (context.input.keys.contains(Key.Up))
			{
				entity.transform.position.y += 1.0;
			}
			if (context.input.keys.contains(Key.Down))
			{
				entity.transform.position.y -= 1.0;
			}
			if (context.input.keys.contains(Key.Right))
			{
				entity.transform.position.x += 1.0;
			}
			if (context.input.keys.contains(Key.Left))
			{
				entity.transform.position.x -= 1.0;
			}
		}
	}
}
