package aprotHx;

interface EntityAccess
{
	public function add(components: Array<Component>): Entity;
	public function delete(id: Int): Void;
}
