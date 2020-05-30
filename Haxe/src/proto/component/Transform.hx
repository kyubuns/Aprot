package proto.component;

import aprotHx.type.*;

class Transform extends aprotHx.Component
{
	public function new(position: Vector2)
	{
		this.position = position;
	}

	@:s public var position: Vector2;
}
