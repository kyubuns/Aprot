package component;

import core.Vector2;
import aprot.Component;

class Transform implements Component
{
	public function new(position: Vector2)
	{
		this.position = position;
	}

	public var position: Vector2;
}
