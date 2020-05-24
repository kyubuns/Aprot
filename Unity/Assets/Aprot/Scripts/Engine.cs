using System;
using System.Text;
using UnityEngine;
using WebSocketSharp;
using XLua;

namespace Aprot
{
    public class Engine
    {
        public static void ConnectDevelopmentServer(string url)
        {
            var webSocket = new WebSocket(url);
            webSocket.Log.Level = LogLevel.Trace;

            webSocket.OnOpen += (sender, e) => { Debug.Log($"OnOpen {sender}, {e}"); };
            webSocket.OnClose += (sender, e) => { Debug.Log($"OnClose {sender}, {e.Reason}"); };
            webSocket.OnMessage += (sender, e) => { Debug.Log($"OnMessage {sender} {e}"); };
            webSocket.OnError += (sender, e) => { Debug.LogError($"OnError {sender} {e}"); };

            Debug.Log("Connecting...");
            webSocket.Connect();
        }

        public static void LuaTest()
        {
            var luaSource = Resources.Load<TextAsset>("lua").text;

            var luaEnv = new LuaEnv();
            luaEnv.AddLoader((ref string filepath) =>
            {
                if (filepath == "bit" || filepath == "bit32") return Encoding.UTF8.GetBytes("return bit");
                throw new Exception($"Unknown require {filepath}");
            });

            var exports = (LuaTable) luaEnv.DoString(luaSource)[0];

            var nameSpace = exports.Get<LuaTable>("proto");
            var mainClass = nameSpace.Get<LuaTable>("Main");

            Debug.Log((string) mainClass.Get<LuaFunction>("createInitEntities").Call()[0]);
        }
    }
}
