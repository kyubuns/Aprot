package aprotHx.type;

import haxe.ds.Vector;

@:generic
class ArrayWrapper<T>
{
	public function new() {}

	public var value: Array<T> = [];

	public function toTyped(): Vector<T>
	{
		var v = new Vector<T>(value.length);
		for (i in 0...value.length)
		{
			v[i] = value[i];
		}
		return v;
	}
}
