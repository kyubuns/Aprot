package aprotHx;

@:generic
class Entity1<T1:Component>
{
	public function new(value1: T1)
	{
		this.value1 = value1;
	}

	public var value1: T1;
}
