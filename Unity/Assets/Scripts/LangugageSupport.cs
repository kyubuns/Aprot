using System.Collections.Generic;
using System.Linq;
using Jint;
using Jint.Native;
using Jint.Native.Array;
using Jint.Native.Object;
using Jint.Runtime;
using Jint.Runtime.Descriptors;

namespace DefaultNamespace
{
    public interface ILanguage
    {
        string LocalFilePath { get; }
        void Load(string rawScriptText);
        void Init();
        string Update(string serializedInputWorld);
    }

    public class JintJs : ILanguage
    {
        public string LocalFilePath => @"/Users/kyubuns/code/Aprot/Haxe/out/js/main.js";

        private Engine engine;
        private ObjectInstance mainObject;
        private ArrayInstance entities;

        public void Load(string rawScriptText)
        {
            engine = new Engine();
            engine.Execute(rawScriptText);

            var aprotHxNameSpace = engine.GetValue("aprotHx");
            mainObject = (ObjectInstance) aprotHxNameSpace.Get("Main");
        }

        public void Init()
        {
            entities = (ArrayInstance) mainObject.Get("init").Invoke();
        }

        public string Update(string serializedInputWorld)
        {
            mainObject.Get("start").Invoke(serializedInputWorld);

            var systems = (ArrayInstance) mainObject.Get("getSystems").Invoke();
            foreach (var system in systems)
            {
                var requireComponents = new List<string[]>();
                var rawRequireComponents = system.Get("get").Invoke().ToArray<ArrayInstance>();
                foreach (var a in rawRequireComponents)
                {
                    requireComponents.Add(a.ToArray<JsString>().Select(x => x.ToString()).ToArray());
                }
                var args = CreateEntities(requireComponents);
                system.Get("run").Invoke(args);
            }

            var serializedOutputWorld = mainObject.Get("finish").Invoke().AsString();
            return serializedOutputWorld;
        }

        private JsValue[] CreateEntities(List<string[]> requireComponents)
        {
            var args = new List<JsValue>();

            foreach (var require in requireComponents)
            {
                var targets = new List<ObjectInstance>();

                foreach (var tmp in entities)
                {
                    var entity = (ObjectInstance) tmp;
                    var components = entity.GetOwnPropertyKeys(Types.String).Select(x => x.ToString()).ToArray();
                    var isTarget = require.All(r => components.Contains(r));
                    if (isTarget) targets.Add(entity);
                }

                args.Add(new ArrayInstance(engine, targets.Select(x => new PropertyDescriptor(x, true, true, true)).ToArray()));
            }

            return args.ToArray();
        }
    }
}

public static class JintExtensions
{
    public static T[] ToArray<T>(this JsValue self) where T : Jint.Native.JsValue
    {
        var selfArray = self.AsArray();
        var result = new T[selfArray.Length];
        for (var i = 0; i < selfArray.Length; ++i)
        {
            result[i] = (T) selfArray[(uint) i];
        }
        return result;
    }
}
