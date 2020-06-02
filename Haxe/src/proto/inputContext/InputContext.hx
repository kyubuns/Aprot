package proto.inputContext;

class InputContext implements hxbitmini.Serializable
{
	public function new(time: Time, input: Input)
	{
		this.time = time;
		this.input = input;
	}

	@:s public var time: Time;
	@:s public var input: Input;
}
