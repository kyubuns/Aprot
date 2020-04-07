package aprotHx.world;

import haxe.Serializer;
import aprotHx.context.*;

class InputWorld
{
	public function new(time: Time, input: Input)
	{
		this.time = time;
		this.input = input;
	}

	public var time: Time;
	public var input: Input;

	public static function serialize(inputWorld: InputWorld): String
	{
		return Serializer.run(inputWorld);
	}
}
