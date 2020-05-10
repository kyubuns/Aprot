package aprotHx.macro;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;

using haxe.macro.MacroStringTools;
using haxe.macro.TypeTools;

class SystemBuilder
{
	static function build(): Array<Field>
	{
		var pos = Context.currentPos();
		var fields = Context.getBuildFields();
		var args: Array<FunctionArg> = [];
		args.push({ name: "context", type: macro:Dynamic });
		args.push({ name: "entityList", type: macro:EntityList });

		var dummy = fields.filter(x -> x.name == "dummyUpdateInternal")[0];

		var code = [];
		code.push(macro trace('before update $pos'));
		code.push(macro $i{dummy.name}($i{"context"}, $i{"entityList"}));
		code.push(macro trace('after update $pos'));

		fields.push({
			name: "updateInternal",
			access: [APublic, AOverride],
			kind: FFun({
				args: args,
				ret: null,
				expr: macro $b{code}
			}),
			pos: pos
		});
		return fields;
	}
}
#end
