package aprotHx;

class OutputWorld<TOutputContext>
{
	public function new(outputContext: TOutputContext, entities: String)
	{
		this.outputContext = outputContext;
		this.entities = entities;
	}

	public var outputContext: TOutputContext;
	public var entities: String;
}
