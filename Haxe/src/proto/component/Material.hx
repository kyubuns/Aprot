package proto.component;

class Material extends aprotHx.Component
{
	public function new(r: Int, g: Int, b: Int)
	{
		this.r = r;
		this.g = g;
		this.b = b;
	}

	@:s public var r: Int;
	@:s public var g: Int;
	@:s public var b: Int;
}
