package aprotHx.macro;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;

using haxe.macro.MacroStringTools;
using haxe.macro.TypeTools;

class ArrayWrapperBuilder
{
	static function build(): ComplexType
	{
		return switch (Context.getLocalType())
		{
			case TInst(_, [t1]):
				buildArrayWrapper(t1);

			default:
				throw 'assert ${Context.getLocalType()}';
		}
	}

	static function buildArrayWrapper(type: Type): ComplexType
	{
		var pos = Context.currentPos();

		var name = 'ArrayWrapper_${type.getClass().name}';
		var typeExists = try
		{
			Context.getType(name);
			true;
		} catch (_:Any) false;

		if (!typeExists)
		{
			var fields: Array<Field> = [];

			// constructor
			fields.push({
				pos: pos,
				name: "new",
				access: [APublic, AInline],
				kind: FFun({
					args: [],
					ret: macro:Void,
					expr: macro {}
				})
			});

			// value
			{
				var ct: ComplexType = TPath({ pack: [], name: 'Array', params: [TPType(type.toComplexType())] });
				fields.push({
					pos: pos,
					name: "value",
					access: [APublic],
					kind: FVar(ct, macro []),
					meta: [{ name: ":s", pos: pos }]
				});
			}

			// func
			{
				var vectorType = { pack: ['haxe', 'ds'], name: 'Vector', params: [TPType(type.toComplexType())] }
				fields.push({
					pos: pos,
					name: "toTyped",
					access: [APublic],
					kind: FFun({
						args: [],
						ret: TPath(vectorType),
						expr: macro
						{
							var v = new $vectorType(value.length);
							for (i in 0...value.length)
							{
								v[i] = value[i];
							}
							return v;
						}
					}),
					meta: []
				});
			}

			var meta: Metadata = [];
			Context.defineType({
				pos: pos,
				pack: [],
				name: name,
				meta: meta,
				kind: TDClass(null, [{ pack: ['hxbit'], name: 'Serializable', params: [] }]),
				fields: fields
			});
		}

		return TPath({
			pack: [],
			name: name,
			params: []
		});
	}
}
#end
