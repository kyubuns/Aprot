package aprotHx.context;

import aprotHx.core.*;

class Input implements InputContext
{
	public function new(x: Float, y: Float)
	{
		this.x = x;
		this.y = y;
	}

	public var x: Float;
	public var y: Float;
}
