package proto.component;

import aprotHx.type.Vector2;

class Velocity extends aprotHx.Component
{
	public function new(vector: Vector2)
	{
		this.vector = vector;
	}

	@:s public var vector: Vector2;
}
