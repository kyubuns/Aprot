package aprotHx;

import haxe.Serializer;
import haxe.Unserializer;
import aprotHx.world.*;
import aprotHx.core.*;
import aprotHx.system.*;
import aprotHx.component.*;
import aprotHx.context.*;

@:expose
class Main
{
	public static var inputWorld: InputWorld;
	public static var outputWorld: OutputWorld;

	public static function getSystems(): Array<System>
	{
		return [new Hoge(), new Fuga(), new CubeRenderer()];
	}

	public static function init(): Array<Dynamic>
	{
		return [
			{
				transform: new Transform(new Vector2(0, 0)),
				movable: new Movable()
			},
			{
				transform: new Transform(new Vector2(0, 100)),
			},
			{
				transform: new Transform(new Vector2(100, 100)),
				movable: new Movable()
			},
			{
				transform: new Transform(new Vector2(100, 200)),
			},
			{
				transform: new Transform(new Vector2(200, 200)),
				movable: new Movable()
			},
			{
				transform: new Transform(new Vector2(200, 300)),
			},
			{
				transform: new Transform(new Vector2(300, 300)),
				movable: new Movable()
			},
			{
				transform: new Transform(new Vector2(300, 400)),
			},
			{
				transform: new Transform(new Vector2(400, 400)),
				movable: new Movable()
			},
			{
				transform: new Transform(new Vector2(250, 50)),
			},
		];
	}

	public static function start(serializedInputWorld: String)
	{
		inputWorld = Unserializer.run(serializedInputWorld);
		outputWorld = new OutputWorld(new Renderer());
	}

	public static function finish(): String
	{
		return Serializer.run(outputWorld);
	}
}
