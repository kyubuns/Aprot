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
		return [new Hoge(), new CubeRenderer()];
	}

	public static function init(): Array<Dynamic>
	{
		return [
			{
				transform: new Transform(new Vector2(5, 10)),
				movable: new Movable()
			},
			{
				transform: new Transform(new Vector2(0, 100)),
			}
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
