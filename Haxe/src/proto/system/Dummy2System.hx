package proto.system;

import proto.inputContext.Key;
import aprotHx.*;
import aprotHx.type.*;
import proto.inputContext.InputContext;
import proto.outputContext.OutputContext;
import proto.sceneContext.SceneContext;
import proto.component.*;

class Dummy2System extends aprotHx.System
{
	public function new() {}

	public function update(context: Context<InputContext, OutputContext, SceneContext>)
	{
		// trace("Dummy2!");
	}
}
