package aprotHx.world;

import haxe.Unserializer;
import aprotHx.context.*;

class OutputWorld
{
	public function new(renderer: Renderer)
	{
		this.renderer = renderer;
	}

	public var renderer: Renderer;

	public static function serialize(serializedOutputWorld: String): OutputWorld
	{
		return Unserializer.run(serializedOutputWorld);
	}
}
