package proto;

class DummyMain
{
	static function main()
	{
		untyped __lua__("_G.math.pow = function(a, b) return a ^ b; end;");
	}
}
