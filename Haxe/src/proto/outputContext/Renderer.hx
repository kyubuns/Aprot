package proto.outputContext;

import aprotHx.type.*;

class Renderer implements hxbit.Serializable
{
	public function new() {}

	@:s public var queue: ArrayWrapper<Vector2> = new ArrayWrapper<Vector2>();
}
