package proto;

class InputWorld
{
	public function new(context: proto.inputContext.InputContext, entities: String)
	{
		this.context = context;
		this.entities = entities;
	}

	public var context: proto.inputContext.InputContext;
	public var entities: String;
}
