package aprotHx;

import haxe.Serializer;
import aprotHx.world.*;
import aprotHx.core.*;
import aprotHx.system.*;
import aprotHx.context.*;
import aprotHx.component.*;

@:expose
class Main
{
	public static var world: World;

	public static function getSystems(): Array<System>
	{
		return [new Hoge(), new CubeRenderer()];
	}

	public static function init(): Array<Dynamic>
	{
		world = new World();
		world.renderer = new Renderer();
		world.renderer.queue = new Array<Vector2>();
		world.renderer.queue.push(new Vector2(1, 2));
		world.renderer.queue.push(new Vector2(3, 4));

		return [
			{
				transform: new Transform(new Vector2(5, 10)),
				movable: new Movable()
			},
			{
				transform: new Transform(new Vector2(6, 10)),
				movable: new Movable()
			}
		];
	}

	public static function serializeWorld(): String
	{
		return Serializer.run(world);
	}
}
