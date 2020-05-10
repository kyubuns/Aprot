package proto;

class Context
{
	public function new(inputContext: proto.inputContext.InputContext, outputContext: proto.outputContext.OutputContext)
	{
		this.inputContext = inputContext;
		this.outputContext = outputContext;
	}

	var inputContext: proto.inputContext.InputContext;
	var outputContext: proto.outputContext.OutputContext;
}
