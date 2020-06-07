using System.Collections.Generic;
using haxe.root;

namespace Aprot
{
    public static class HaxeExtensions
    {
        public static Array<object> ToHaxeArray<T>(this IEnumerable<T> self)
        {
            var a = new Array<object>();
            foreach (var s in self)
            {
                a.push(s);
            }
            return a;
        }
    }
}
