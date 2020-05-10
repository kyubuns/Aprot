package proto.component;

import aprotHx.type.Vector2;

class Velocity implements aprotHx.Component
{
	public function new(vector: Vector2)
	{
		this.vector = vector;
	}

	public var vector: Vector2;
}
