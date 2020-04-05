import world.World;
import haxe.Serializer;
import core.Vector2;
import aprot.System;
import system.Hoge;
import system.CubeRenderer;
import component.Transform;
import component.Movable;

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
		world.renderer = new context.Renderer();
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
