using System;
using System.Net;
using System.Net.Sockets;
using Fleck;

namespace Server
{
    public static class Program
    {
        public static void Main()
        {
            const int port = 5555;
            var url = $"ws://{GetLocalIp()}:{port}";
            var webSocketServer = new WebSocketServer($"ws://0.0.0.0:{port}");

            webSocketServer.Start(socket =>
            {
                socket.OnOpen += () => { Console.WriteLine("OnOpen"); };
                socket.OnClose += () => { Console.WriteLine("OnClose"); };
                socket.OnError += e => { Console.WriteLine($"OnError {e}"); };
            });

            Console.WriteLine($"Start {url}");
            Console.ReadLine();
        }

        // https://stackoverflow.com/questions/6803073/get-local-ip-address
        private static string GetLocalIp()
        {
            var localIp = "0.0.0.0";
            using (var socket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, 0))
            {
                socket.Connect("8.8.8.8", 65530);
                if (socket.LocalEndPoint is IPEndPoint endPoint) localIp = endPoint.Address.ToString();
            }
            return localIp;
        }
    }
}
