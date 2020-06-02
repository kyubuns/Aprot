package proto.inputContext;

class Time implements hxbitmini.Serializable
{
	public function new(deltaTime: Float)
	{
		this.deltaTime = deltaTime;
	}

	@:s public var deltaTime: Float;
}
