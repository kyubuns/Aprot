package aprotHx;

class Engine
{
	public static function update<TInputContext, TOutputContext>(inputContext: TInputContext, serializedEntities: String, outputContext: TOutputContext,
			systems: Array<System>): OutputWorld<TOutputContext>
	{
		var dummy = new OutputWorld<TOutputContext>(outputContext, serializedEntities);
		return dummy;
	}
}
