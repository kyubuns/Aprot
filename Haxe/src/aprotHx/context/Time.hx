package aprotHx.context;

import aprotHx.core.*;

class Time implements InputContext
{
	public function new(deltaTime: Float)
	{
		this.deltaTime = deltaTime;
	}

	public var deltaTime: Float;
}
