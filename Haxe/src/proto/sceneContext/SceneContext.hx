package proto.sceneContext;

class SceneContext implements hxbitmini.Serializable
{
	public function new(scene: Int)
	{
		this.scene = scene;
	}

	@:s public var scene: Int;
}
