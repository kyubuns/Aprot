package aprotHx.type;

import haxe.ds.Vector;

// C#から型付きでアクセス出来るようにするためのArray
#if !macro
@:genericBuild(aprotHx.macro.ArrayWrapperBuilder.build())
#end
class ArrayWrapper<T> {}
