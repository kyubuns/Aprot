package proto;

class OutputWorld
{
	public function new(outputContext: proto.outputContext.OutputContext, entities: String)
	{
		this.outputContext = outputContext;
		this.entities = entities;
	}

	public var outputContext: proto.outputContext.OutputContext;
	public var entities: String;
}
