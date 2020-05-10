package aprotHx;

@:generic
class Entity2<T1:Component, T2:Component>
{
	public function new(value1: T1, value2: T2)
	{
		this.value1 = value1;
		this.value2 = value2;
	}

	public var value1: T1;
	public var value2: T2;
}
