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

		var updateFunction = fields.filter(x -> x.name == "update")[0];
		var updateFunctionArgsType = MacroUtil.getArgsType(updateFunction.kind);
		var refEntityType = MacroUtil.getArrayType(updateFunctionArgsType[1].type);
		var refParams = MacroUtil.getGenericTypes(refEntityType);
		var refParamNames = refParams.map(x -> MacroUtil.tpTypeToName(x));
		var typePath = { name: "RefEntity", pack: [], params: refParams };

		var createRefEntities = [];
		for (refParamName in refParamNames)
		{
			createRefEntities.push(macro refComponents.push(entity.components.value.filter(x -> Std.isOfType(x, $i{MacroUtil.getName(refParamName)}))));
		}

		var refEntitiesInitializer = [];
		refEntitiesInitializer.push(macro entity.id);
		for (index in 0...refParamNames.length)
		{
			var refParamName = refParamNames[index];
			var a: haxe.macro.Expr = {
				expr: EConst(CInt('$index')),
				pos: pos
			};
			refEntitiesInitializer.push(macro cast(refComponents[$a][0], $refParamName));
		}

		var code = macro
			{
				var entities = new Array<$refEntityType>();
				for (entity in entityList.entities.value)
				{
					var refComponents = [];
					$a{createRefEntities};
					if (refComponents.filter(x -> x.length == 0).length == 0)
					{
						entities.push(new $typePath($a{refEntitiesInitializer}));
					}
				}
				update(context, entities);
			};

		fields.push({
			name: "updateInternal",
			access: [APublic, AOverride],
			kind: FFun({
				args: args,
				ret: null,
				expr: code
			}),
			pos: pos
		});
		return fields;
	}
}
#end
