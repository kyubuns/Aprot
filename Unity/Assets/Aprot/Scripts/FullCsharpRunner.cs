using proto.inputContext;
using proto.outputContext;
using UnityEngine;

namespace Aprot
{
    public class FullCsharpRunner : IRunner
    {
        private string currentEntities;
        public void ConnectDevelopmentServer(string url)
        {
            currentEntities = proto.Main.createInitEntities();
            Debug.Log($"FullCsharpRunner Init: {currentEntities.Length}");
        }

        public OutputContext Update(InputContext inputContext)
        {
            var serializedInputContext = proto.Bridge.serializeInputContext(inputContext);
            var output = proto.Main.update(serializedInputContext, currentEntities);
            var serializedOutputContext = output[0];
            currentEntities = output[1];
            return proto.Bridge.deserializeOutputContext(serializedOutputContext);
        }

        public void Dispose()
        {
        }
    }
}
