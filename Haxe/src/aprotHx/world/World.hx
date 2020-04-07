package aprotHx.world;

import haxe.Unserializer;
import aprotHx.context.Renderer;

class World
{
	public function new() {}

	public var renderer: Renderer;

	public static function deserialize(s: String): World
	{
		return Unserializer.run(s);
	}
}
