using System.Collections.Generic;
using System.Linq;
using Aprot;
using proto.inputContext;
using UnityEngine;
using UnityEngine.UI;
using Time = UnityEngine.Time;
using Vector2 = aprotHx.type.Vector2;

namespace Proto
{
    public class ProtoTest : MonoBehaviour
    {
        [SerializeField] private Text debugText = default;
        [SerializeField] private InputField inputField = default;
        [SerializeField] private Button connectButton = default;
        [SerializeField] private GameObject box = default;
        private List<GameObject> boxCache = new List<GameObject>();

        private Engine engine;
        private readonly FpsCounter fpsCounter = new FpsCounter();

        public void Start()
        {
            Application.targetFrameRate = 60;
            inputField.text = PlayerPrefs.GetString("DebugKey", "");
            connectButton.onClick.AddListener(() =>
            {
                Debug.Log($"Connect to {inputField.text}");
                PlayerPrefs.SetString("DebugKey", inputField.text);

                engine = new Engine();
                engine.ConnectDevelopmentServer(inputField.text);
            });

            box.SetActive(false);
        }

        public void Update()
        {
            UpdateEngine();
            UpdateFpsCounter();
        }

        private void UpdateEngine()
        {
            if (engine == null) return;

            var time = new proto.inputContext.Time(Time.deltaTime);
            var input = new proto.inputContext.Input(new Vector2());
            var inputContext = new InputContext(time, input);
            var outputContext = engine.Update(inputContext);
            if (outputContext?.renderer?.queue == null) return;

            var renderQueue = outputContext.renderer.queue.toTyped();
            foreach (var (x, i) in renderQueue.Select((x, i) => (x, i)))
            {
                if (boxCache.Count <= i)
                {
                    var newBox = GameObject.Instantiate(box);
                    newBox.SetActive(true);
                    boxCache.Add(newBox);
                }

                boxCache[i].transform.localPosition = new Vector3((float) x.x, (float) x.y, 0f);
            }
        }

        private void UpdateFpsCounter()
        {
            fpsCounter.Update();
            debugText.text = $"{fpsCounter.Fps:0.0}FPS";
        }

        public void OnDestroy()
        {
            engine?.Dispose();
        }
    }

    // https://techblog.kayac.com/approximate-average-fps
    public class FpsCounter
    {
        public float Fps => 1f / avgTime;

        private const float K = 0.05f;
        private float avgTime;

        public void Update()
        {
            var dt = Time.deltaTime;
            avgTime *= 1f - K;
            avgTime += dt * K;
        }
    }
}
