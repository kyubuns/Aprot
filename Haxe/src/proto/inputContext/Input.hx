package proto.inputContext;

import aprotHx.type.Vector2;

class Input implements hxbitmini.Serializable
{
	public function new(vector: Vector2)
	{
		this.vector = vector;
	}

	@:s public var vector: Vector2;
}
