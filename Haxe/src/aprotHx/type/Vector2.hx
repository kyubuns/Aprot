package aprotHx.type;

class Vector2 implements hxbitmini.Serializable
{
	public function new(x: Float, y: Float)
	{
		this.x = x;
		this.y = y;
	}

	@:s public var x: Float;
	@:s public var y: Float;
}
