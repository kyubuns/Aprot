using System;
using System.Text;
using haxe.lang;
using haxe.root;
using proto;
using proto.inputContext;
using proto.outputContext;
using UnityEngine;
using WebSocketSharp;
using XLua;

namespace Aprot
{
    public class Engine : IDisposable
    {
        private LuaFunction updateFunction;
        private string currentEntities;
        private WebSocket webSocket;
        private byte[] bit32lua;

        public Engine()
        {
            bit32lua = Resources.Load<TextAsset>("bit32.lua").bytes;

            // register classes
            var dummyRenderer = new proto.outputContext.Renderer(EmptyObject.EMPTY);
            dummyRenderer.queue = new ArrayWrapper_Vector2();
            dummyRenderer.queue.value.push(new aprotHx.type.Vector2(1, 2));
            var dummyOutputContext = new proto.outputContext.OutputContext(dummyRenderer);
        }

        public void ConnectDevelopmentServer(string url)
        {
            if (webSocket != null) webSocket.Close();

            webSocket = new WebSocket(url);
            webSocket.Log.Level = LogLevel.Trace;

            webSocket.OnOpen += (sender, e) => { Debug.Log($"OnOpen {sender}, {e}"); };
            webSocket.OnClose += (sender, e) => { Debug.Log($"OnClose {sender}, {e.Reason}"); };
            webSocket.OnMessage += (sender, e) => { RunLuaScript(e.Data); };
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
            currentEntities = (string) mainClass.Get<LuaFunction>("createInitEntities").Call(new object[] { }, new[] { typeof(string) })[0];
            Debug.Log($"Init: {currentEntities}");

            Debug.Log($"CsIn: {proto.Main.createInitEntities()}");
        }

        public OutputContext Update(InputContext inputContext)
        {
            if (updateFunction == null)
            {
                return null;
            }

            var serializedInputContext = Bridge.serializeInputContext(inputContext);
            var output = (string[]) updateFunction.Call(new object[] { serializedInputContext, currentEntities }, new[] { typeof(string[]) })[0];
            var serializedOutputContext = output[0];
            currentEntities = output[1];
            return Bridge.deserializeOutputContext(serializedOutputContext);
        }

        public void Dispose()
        {
            updateFunction?.Dispose();
            webSocket?.Close();
        }
    }
}
