using aprotHx;
using proto.inputContext;
using proto.outputContext;
using UnityEngine;

namespace Aprot
{
    public class FullCsharpRunner : IRunner
    {
        private EntityList currentEntities;

        public void ConnectDevelopmentServer(string url)
        {
            currentEntities = proto.Main.createInitEntitiesNative();
            Debug.Log($"FullCsharpRunner");
        }

        public OutputContext Update(InputContext inputContext)
        {
            var outputContext = proto.Main.updateNative(inputContext, currentEntities);
            return outputContext;
        }

        public void Dispose()
        {
        }
    }
}
