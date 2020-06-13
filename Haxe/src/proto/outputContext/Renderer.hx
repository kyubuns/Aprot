package proto.outputContext;

import aprotHx.type.*;

class Renderer implements hxbitmini.Serializable
{
	public function new()
	{
	}

	@:s public var queue: ArrayWrapper<RenderElement> = new ArrayWrapper<RenderElement>();
}

class RenderElement implements hxbitmini.Serializable
{
	public function new(position: Vector2, color: Color, alpha: Int)
	{
		this.position = position;
		this.color = color;
		this.alpha = alpha;
	}

	@:s public var position: Vector2;
	@:s public var color: Color;
	@:s public var alpha: Int;
}
