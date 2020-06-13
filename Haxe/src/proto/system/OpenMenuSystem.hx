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

	public function update(context: Context<InputContext, OutputContext, SceneContext>)
	{
		if (!context.input.keys.contains(Key.A))
			return;

		if (context.scene.scene == 0)
		{
			// go to menu
			context.scene.scene = 1;
		} else
		{
			// close menu
			context.scene.scene = 0;
		}
	}
}
