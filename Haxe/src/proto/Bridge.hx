package proto;

import haxe.io.BytesData;
import proto.inputContext.InputContext;
import proto.outputContext.*;

@:expose
class Bridge
{
	static public function serializeInputContext(inputContext: InputContext): String
	{
		var serializer = new hxbitmini.Serializer();
		return serializer.serialize(inputContext).toString();
	}

	static public function deserializeOutputContext(serializedOutputContext: String): OutputContext
	{
		var serializer = new hxbitmini.Serializer();
		return serializer.unserialize(haxe.io.Bytes.ofString(serializedOutputContext), OutputContext);
	}
}
