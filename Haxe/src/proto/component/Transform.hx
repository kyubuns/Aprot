package proto.component;

import aprotHx.type.*;

class Transform implements aprotHx.Component
{
	public function new(position: Vector2)
	{
		this.position = position;
	}

	public var position: Vector2;
}
