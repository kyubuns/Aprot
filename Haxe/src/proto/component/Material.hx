package proto.component;

import aprotHx.type.Color;

class Material extends aprotHx.Component
{
	public function new(color: Color)
	{
		this.color = color;
	}

	@:s public var color: Color;
}
