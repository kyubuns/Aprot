package proto.inputContext;

class InputContext implements hxbitmini.Serializable
{
	public function new(time: Time, keys: Array<Key>)
	{
		this.time = time;
		this.keys = keys;
	}

	@:s public var time: Time;
	@:s public var keys: Array<Key>;
}
