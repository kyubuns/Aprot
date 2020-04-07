package aprotHx.core;

#if cs
import cs.system.collections.generic.List_1;
#end

@:generic
class ArrayWrapper<T>
{
	public function new() {}

	public var value: Array<T> = [];

	#if cs
	public function toTyped(): List_1<T>
	{
		var v = new List_1<T>();
		for (e in value)
		{
			v.Add(e);
		}
		return v;
	}
	#end
}
