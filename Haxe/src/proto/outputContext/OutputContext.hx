package proto.outputContext;

class OutputContext
{
	public function new(renderer: Renderer)
	{
		this.renderer = renderer;
	}

	public var renderer: Renderer;
}
