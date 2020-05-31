package proto.outputContext;

class OutputContext implements hxbit.Serializable
{
	public function new(renderer: Renderer)
	{
		this.renderer = renderer;
	}

	@:s public var renderer: Renderer;
}
