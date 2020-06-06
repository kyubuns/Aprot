using System;
using proto.inputContext;
using proto.outputContext;

namespace Aprot
{
    public class Engine : IDisposable
    {
        private readonly IRunner runner;

        public Engine()
        {
#if FULL_CSHARP
            runner = new FullCsharpRunner();
#else
            runner = new XluaRunner();
#endif
        }

        public void ConnectDevelopmentServer(string url)
        {
            runner.ConnectDevelopmentServer(url);
        }

        public OutputContext Update(InputContext inputContext)
        {
            return runner.Update(inputContext);
        }

        public void Dispose()
        {
            runner?.Dispose();
        }
    }

    public interface IRunner : IDisposable
    {
        void ConnectDevelopmentServer(string url);
        OutputContext Update(InputContext inputContext);
    }
}
