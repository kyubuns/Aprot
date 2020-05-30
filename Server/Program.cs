using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.IO;
using System.Threading.Tasks;
using WebSocketSharp;
using WebSocketSharp.Server;
using ErrorEventArgs = WebSocketSharp.ErrorEventArgs;

namespace Server
{
    public static class Program
    {
        public static async Task Main(string[] args)
        {
            var fileWatcher = new FileWatcher(Path.GetFullPath(args[0]));
            var webServer = new WebServer(5555, fileWatcher);
            webServer.Start();
            Console.WriteLine($"Start Server {webServer.Url}");
            await Task.WhenAny(FileWatch(fileWatcher, webServer), WaitKey());
            webServer.Close();
            Console.WriteLine("Finish");
        }

        private static async Task WaitKey()
        {
            await Task.Run(() => Console.ReadLine());
        }

        private static async Task FileWatch(FileWatcher fileWatcher, WebServer webServer)
        {
            while (true)
            {
                await fileWatcher.WaitForUpdate();
                Console.WriteLine("Update");
                webServer.Broadcast();
            }
        }
    }

    public class WebServer
    {
        private readonly int port;
        private readonly FileWatcher fileWatcher;
        private WebSocketServer webSocketServer;

        public string Url => $"ws://{GetLocalIp()}:{port}";

        public WebServer(int port, FileWatcher fileWatcher)
        {
            this.port = port;
            this.fileWatcher = fileWatcher;
        }

        public void Start()
        {
            webSocketServer = new WebSocketServer($"ws://0.0.0.0:{port}");
            webSocketServer.AddWebSocketService("/aprot", () => new AprotServer(fileWatcher));
            webSocketServer.Start();
        }

        public void Broadcast()
        {
            webSocketServer.WebSocketServices["/aprot"].Sessions.Broadcast(fileWatcher.Current);
        }

        public void Close()
        {
            webSocketServer.Stop();
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

    public class AprotServer : WebSocketBehavior
    {
        private readonly FileWatcher fileWatcher;

        public AprotServer(FileWatcher fileWatcher)
        {
            this.fileWatcher = fileWatcher;
        }

        protected override void OnOpen()
        {
            Console.WriteLine($"OnOpen");
            Send(fileWatcher.Current);
        }

        protected override void OnMessage (MessageEventArgs e)
        {
            Console.WriteLine($"OnMessage {e.Data}");
        }

        protected override void OnError(ErrorEventArgs e)
        {
            Console.WriteLine($"OnError {e.Exception}");
        }

        protected override void OnClose(CloseEventArgs e)
        {
            Console.WriteLine($"OnClose {e.Reason}");
        }
    }

    public class FileWatcher
    {
        private readonly string filePath;

        public string Current { get; private set; }

        public FileWatcher(string filePath)
        {
            this.filePath = filePath;
            Current = File.ReadAllText(filePath, Encoding.UTF8);
        }

        public Task WaitForUpdate()
        {
            var taskCompletionSource = new TaskCompletionSource<bool>();
            var watcher = new FileSystemWatcher();
            watcher.IncludeSubdirectories = true;
            Console.WriteLine($"Path.GetDirectoryName(filePath) = {Path.GetDirectoryName(filePath)}");
            Console.WriteLine($"Path.GetFileName(filePath) = {Path.GetFileName(filePath)}");
            watcher.Path = Path.GetDirectoryName(filePath);
            watcher.Filter = Path.GetFileName(filePath);
            watcher.NotifyFilter = (NotifyFilters.LastAccess
                                    | NotifyFilters.LastWrite
                                    | NotifyFilters.FileName
                                    | NotifyFilters.DirectoryName
                                    | NotifyFilters.CreationTime
                                    | NotifyFilters.Size);

            void OnUpdate(object sender, FileSystemEventArgs e)
            {
                Console.WriteLine($"OnUpdate {sender}, {e.Name} {e.ChangeType} {e.FullPath}");
                try
                {
                    Current = File.ReadAllText(e.FullPath, Encoding.UTF8);
                }
                catch (FileNotFoundException)
                {
                    Console.WriteLine("File not found");
                    return;
                }
                watcher.Dispose();
                taskCompletionSource.SetResult(true);
            }

            watcher.Created += OnUpdate;
            watcher.Changed += OnUpdate;
            watcher.Deleted += OnUpdate;
            watcher.Renamed += OnUpdate;

            watcher.EnableRaisingEvents = true;
            return taskCompletionSource.Task;
        }
    }
}
