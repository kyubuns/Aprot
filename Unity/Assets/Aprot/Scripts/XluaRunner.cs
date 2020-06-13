#if !FULL_CSHARP
using System;
using System.Text;
using proto.inputContext;
using proto.outputContext;
using UnityEngine;
using WebSocketSharp;
using XLua;

namespace Aprot
{
    public class XluaRunner : IRunner
    {
        private LuaFunction updateFunction;
        private string currentEntities;
        private string currentSceneContext;
        private WebSocket webSocket;
        private string requestUpdate;
        private byte[] bit32lua;

        public XluaRunner()
        {
            bit32lua = Resources.Load<TextAsset>("bit32.lua").bytes;
        }

        public void ConnectDevelopmentServer(string url)
        {
            if (webSocket != null) webSocket.Close();

            webSocket = new WebSocket(url);
            webSocket.Log.Level = LogLevel.Trace;

            webSocket.OnOpen += (sender, e) => { Debug.Log($"OnOpen {sender}, {e}"); };
            webSocket.OnClose += (sender, e) => { Debug.Log($"OnClose {sender}, {e.Reason}"); };
            webSocket.OnMessage += (sender, e) => { requestUpdate = e.Data; };
            webSocket.OnError += (sender, e) => { Debug.LogError($"OnError {sender} {e.Exception}"); };

            Debug.Log("Connecting...");
            webSocket.Connect();
        }

        private void RunLuaScript(string source)
        {
            var luaEnv = new LuaEnv();
            luaEnv.AddLoader((ref string filepath) =>
            {
                if (filepath == "bit") return Encoding.UTF8.GetBytes("return");
                if (filepath == "bit32") return bit32lua;
                throw new Exception($"Unknown require {filepath}");
            });

            var exports = (LuaTable) luaEnv.DoString(source)[0];

            var nameSpace = exports.Get<LuaTable>("proto");
            var mainClass = nameSpace.Get<LuaTable>("Main");

            updateFunction?.Dispose();
            updateFunction = mainClass.Get<LuaFunction>("update");
            if (string.IsNullOrWhiteSpace(currentEntities))
            {
                currentEntities = (string) mainClass.Get<LuaFunction>("createInitEntities").Call(new object[] { }, new[] { typeof(string) })[0];
                currentSceneContext = (string) mainClass.Get<LuaFunction>("createInitSceneContext").Call(new object[] { }, new[] { typeof(string) })[0];
                Debug.Log($"XluaRunner Init: {currentEntities.Length} | {currentEntities}");

                var dummy = proto.Main.createInitEntities();
                Debug.Log($"Cs__Runner Init: {dummy.Length} | {dummy}");
            }
        }

        public OutputContext Update(InputContext inputContext)
        {
            if (requestUpdate != null)
            {
                RunLuaScript(requestUpdate);
                requestUpdate = null;
            }

            if (updateFunction == null)
            {
                return null;
            }

            var serializedInputContext = proto.Bridge.serializeInputContext(inputContext);
            var output = (string[]) updateFunction.Call(new object[] { serializedInputContext, currentSceneContext, currentEntities }, new[] { typeof(string[]) })[0];
            var serializedOutputContext = output[0];
            currentSceneContext = output[1];
            currentEntities = output[2];
            return proto.Bridge.deserializeOutputContext(serializedOutputContext);
        }

        public void Dispose()
        {
            updateFunction?.Dispose();
            webSocket?.Close();
        }
    }
}
#endif
