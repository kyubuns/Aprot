package aprotHx;

class Context<TInputContext, TOutputContext>
{
	public function new(input: TInputContext, output: TOutputContext)
	{
		this.input = input;
		this.output = output;
	}

	public var input: TInputContext;
	public var output: TOutputContext;
}
