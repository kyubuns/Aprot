package proto;

import haxe.io.BytesData;
import proto.inputContext.InputContext;
import proto.outputContext.*;

@:expose
class Bridge
{
	static public function serializeInputContext(inputContext: InputContext): BytesData
	{
		var serializer = new hxbit.Serializer();
		return serializer.serialize(inputContext).getData();
	}

	static public function deserializeOutputContext(serializedOutputContext: BytesData): OutputContext
	{
		var serializer = new hxbit.Serializer();
		return serializer.unserialize(haxe.io.Bytes.ofData(serializedOutputContext), OutputContext);
	}
}
