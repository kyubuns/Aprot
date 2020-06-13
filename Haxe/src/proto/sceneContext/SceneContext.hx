package proto.sceneContext;

import aprotHx.type.Color;
import aprotHx.type.Vector2;

class SceneContext implements hxbitmini.Serializable
{
	public function new(scene: Int)
	{
		this.scene = scene;
	}

	@:s public var scene: Int;
	@:s public var shadow: Array<BoxShadow> = new Array<BoxShadow>();
}

class BoxShadow implements hxbitmini.Serializable
{
	public function new(time: Float, position: Vector2, color: Color)
	{
		this.time = time;
		this.position = position;
		this.color = color;
	}

	@:s public var time: Float;
	@:s public var position: Vector2;
	@:s public var color: Color;
}
