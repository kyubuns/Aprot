package proto;

import haxe.io.BytesData;
import proto.inputContext.InputContext;
import proto.outputContext.*;

@:expose
class Bridge
{
	static public function serializeInputContext(inputContext: InputContext): String
	{
		final serializer = new hxbitmini.Serializer();
		return serializer.serialize(inputContext).toHex();
	}

	static public function deserializeOutputContext(serializedOutputContext: String): OutputContext
	{
		final serializer = new hxbitmini.Serializer();
		return serializer.unserialize(haxe.io.Bytes.ofHex(serializedOutputContext), OutputContext);
	}
}
