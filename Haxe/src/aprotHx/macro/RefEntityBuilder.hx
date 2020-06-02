package aprotHx.macro;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;

using haxe.macro.MacroStringTools;
using haxe.macro.TypeTools;

class RefEntityBuilder
{
	static function build(): ComplexType
	{
		return switch (Context.getLocalType())
		{
			case TInst(_, types):
				buildRefEntity(types);

			default:
				throw 'assert ${Context.getLocalType()}';
		}
	}

	static function buildRefEntity(types: Array<Type>): ComplexType
	{
		var pos = Context.currentPos();

		var arity = types.length;
		var name = 'RefEntity_${types.map(x -> x.getClass().name).join("_")}';
		var typeExists = try
		{
			Context.getType('aprotHx.$name');
			true;
		} catch (_:Any) false;

		if (!typeExists)
		{
			var fields: Array<Field> = [];
			var constructorArgs: Array<FunctionArg> = [];
			var constructorExprs: Array<Expr> = [];
			var typeParams: Array<TypeParamDecl> = [];

			var ct = TPath({ pack: [], name: 'Int' });
			constructorArgs.push({ name: "id", type: ct });
			constructorExprs.push(macro this.id = id);
			var meta: Metadata = [];
			fields.push({
				pos: pos,
				name: "id",
				access: [APublic],
				kind: FProp("default", "null", ct),
				meta: meta,
			});

			for (i in 0...arity)
			{
				var cls = types[i].getClass();
				var fieldName = cls.name.substr(0, 1).toLowerCase() + cls.name.substr(1);
				var typeName = 'T$i';
				var ct = TPath({ pack: [], name: typeName });
				typeParams.push({ name: typeName });
				constructorArgs.push({ name: fieldName, type: ct });
				constructorExprs.push(macro this.$fieldName = $i{fieldName});
				var meta: Metadata = [];
				fields.push({
					pos: pos,
					name: fieldName,
					access: [APublic],
					kind: FProp("default", "null", ct),
					meta: meta,
				});
			}

			// constructor
			fields.push({
				pos: pos,
				name: "new",
				access: [APublic, AInline],
				kind: FFun({
					args: constructorArgs,
					ret: macro:Void,
					expr: macro $b{constructorExprs}
				})
			});

			var meta: Metadata = [];
			Context.defineType({
				pos: pos,
				pack: ['aprotHx'],
				name: name,
				params: typeParams,
				meta: meta,
				kind: TDClass(),
				fields: fields
			});
		}

		return TPath({ pack: ['aprotHx'], name: name, params: [for (t in types) TPType(t.toComplexType())] });
	}
}
#end
