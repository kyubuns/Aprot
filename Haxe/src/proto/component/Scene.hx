package proto.component;

class Scene extends aprotHx.Component
{
	public function new(scene: Int)
	{
		this.scene = scene;
	}

	@:s public var scene: Int;
}
