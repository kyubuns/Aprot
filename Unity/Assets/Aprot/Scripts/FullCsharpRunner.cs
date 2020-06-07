using aprotHx;
using proto.inputContext;
using proto.outputContext;
using proto.sceneContext;
using UnityEngine;

namespace Aprot
{
    public class FullCsharpRunner : IRunner
    {
        private SceneContext sceneContext;
        private EntityList currentEntities;

        public void ConnectDevelopmentServer(string url)
        {
            sceneContext = proto.Main.createInitSceneContextNative();
            currentEntities = proto.Main.createInitEntitiesNative();
            Debug.Log($"FullCsharpRunner");
        }

        public OutputContext Update(InputContext inputContext)
        {
            var outputContext = proto.Main.updateNative(inputContext, sceneContext, currentEntities);
            return outputContext;
        }

        public void Dispose()
        {
        }
    }
}
