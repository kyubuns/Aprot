package proto;

import haxe.Unserializer;
import proto.inputContext.InputContext;
import haxe.Serializer;
import aprotHx.*;
import aprotHx.type.*;
import proto.system.*;
import proto.outputContext.*;
import proto.component.*;

@:expose
class Bridge
{
	static public function serializeInputContext(inputContext: InputContext): String
	{
		return Serializer.run(inputContext);
	}

	static public function deserializeOutputContext(serializedOutputContext: String): OutputContext
	{
		return cast(Unserializer.run(serializedOutputContext), OutputContext);
	}
}
