package proto.system;

import proto.inputContext.Key;
import aprotHx.*;
import aprotHx.type.*;
import proto.inputContext.InputContext;
import proto.outputContext.OutputContext;
import proto.sceneContext.SceneContext;
import proto.component.*;

class OpenMenuSystem extends aprotHx.System
{
	public function new()
	{
	}

	public function update(context: Context<InputContext, OutputContext, SceneContext>, entities: Array<RefEntity<Scene>>)
	{
		if (!context.input.keys.contains(Key.A))
			return;

		if (context.scene.scene == 0)
		{
			// go to menu
			context.scene.scene = 1;

			final entity1 = new Array<Component>();
			entity1.push(new Transform(new Vector2(0, 0)));
			entity1.push(new Scene(1));
			context.entities.add(entity1);
		} else
		{
			// close menu
			context.scene.scene = 0;

			for (target in entities.filter(x -> x.scene.scene == 1).map(x -> x.id))
			{
				context.entities.delete(target);
			}
		}
	}
}
