using UnityEngine;
using WebSocketSharp;

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
    }
}
