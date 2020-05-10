package proto.inputContext;

class InputContext
{
	public function new(time: Time, input: Input)
	{
		this.time = time;
		this.input = input;
	}

	public var time: Time;
	public var input: Input;
}
