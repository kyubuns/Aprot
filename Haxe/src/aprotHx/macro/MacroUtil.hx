package aprotHx.macro;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;

using haxe.macro.MacroStringTools;
using haxe.macro.TypeTools;

class MacroUtil
{
	public static function getArgsType(kind: FieldType)
	{
		switch (kind)
		{
			case FFun(func):
				return func.args;
			default:
				throw 'getArgsTypeError';
		}
	}

	public static function getArrayType(value: ComplexType)
	{
		switch (value)
		{
			case TPath(a):
				switch (a.params[0])
				{
					case TPType(b):
						return b;
					default:
						throw 'getArrayTypeError';
				}
			default:
				throw 'getArrayTypeError';
		}
	}

	public static function getGenericTypes(value: ComplexType)
	{
		switch (value)
		{
			case TPath(a):
				return a.params;
			default:
				throw 'getArrayTypeError';
		}
	}

	public static function tpTypeToName(value: TypeParam)
	{
		switch (value)
		{
			case TPType(a):
				{
					switch (a)
					{
						case TPath(b):
							return b.name;
						default:
							throw 'getArrayTypeError';
					}
				}
			default:
				throw 'getArrayTypeError';
		}
	}
}
#end
