package proto.test;

import proto.inputContext.Key;
import aprotHx.type.Vector2;
import aprotHx.RefEntity;
import aprotHx.Context;
import proto.sceneContext.SceneContext;
import proto.outputContext.Renderer;
import proto.outputContext.OutputContext;
import proto.inputContext.Time;
import proto.inputContext.InputContext;
import utest.Assert;
import proto.system.*;
import proto.component.*;

class MoveSystemTest extends utest.Test
{
	var moveSystem: MoveSystem = new MoveSystem();

	function testMoveRight()
	{
		var inputContext = new InputContext(new Time(1.0), [Key.Right]);
		var outputContext = new OutputContext(new Renderer());
		var sceneContext = new SceneContext();
		var context = new Context(inputContext, outputContext, sceneContext);

		var entities = new Array<RefEntity<Transform>>();
		var entity1 = new RefEntity<Transform>(123, new Transform(new Vector2(5, 5)));
		entities.push(entity1);
		moveSystem.update(context, entities);

		Assert.equals(6, entity1.transform.position.x);
		Assert.equals(5, entity1.transform.position.y);
	}
}
