package aprotHx.type;

class Vector2 implements hxbitmini.Serializable
{
	public function new(x: Float, y: Float)
	{
		this.x = x;
		this.y = y;
	}

	public function copy(): Vector2
	{
		return new Vector2(x, y);
	}

	@:s public var x: Float;
	@:s public var y: Float;
}
