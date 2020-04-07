package aprotHx.component;

import aprotHx.core.*;

class Transform implements Component
{
	public function new(position: Vector2)
	{
		this.position = position;
	}

	public var position: Vector2;
}
