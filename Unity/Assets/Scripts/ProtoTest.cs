using System.Collections.Generic;
using System.Linq;
using Aprot;
using proto.inputContext;
using UnityEngine;
using UnityEngine.UI;
using Time = UnityEngine.Time;

namespace Proto
{
    public class ProtoTest : MonoBehaviour
    {
        [SerializeField] private Text debugText = default;
        [SerializeField] private InputField inputField = default;
        [SerializeField] private Button connectButton = default;
        [SerializeField] private GameObject box = default;
        private readonly List<GameObject> boxCache = new List<GameObject>();

        private Engine engine;
        private readonly FpsCounter fpsCounter = new FpsCounter();

        public void Start()
        {
            Application.targetFrameRate = 60;
            inputField.text = PlayerPrefs.GetString("DebugKey", "");
            connectButton.onClick.AddListener(() => { Connect(); });

            box.SetActive(false);
            if (Application.isEditor) Connect();
        }

        private void Connect()
        {
            Debug.Log($"Connect to {inputField.text}");
            PlayerPrefs.SetString("DebugKey", inputField.text);

            engine = new Engine();
            engine.ConnectDevelopmentServer(inputField.text);
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
            var inputKeys = new List<Key>();
            if (Input.GetKeyDown(KeyCode.W)) inputKeys.Add(Key.Up);
            if (Input.GetKeyDown(KeyCode.A)) inputKeys.Add(Key.Left);
            if (Input.GetKeyDown(KeyCode.S)) inputKeys.Add(Key.Down);
            if (Input.GetKeyDown(KeyCode.D)) inputKeys.Add(Key.Right);
            if (Input.GetKeyDown(KeyCode.Z)) inputKeys.Add(Key.A);
            if (Input.GetKeyDown(KeyCode.X)) inputKeys.Add(Key.B);
            var inputContext = new InputContext(time, inputKeys.ToHaxeArray());
            var outputContext = engine.Update(inputContext);
            if (outputContext?.renderer?.queue == null) return;

            var renderQueue = outputContext.renderer.queue.toTyped();
            foreach (var b in boxCache)
            {
                b.transform.localPosition = new Vector3(-100f, -100f, -100f);
            }
            foreach (var (x, i) in renderQueue.Select((x, i) => (x, i)))
            {
                if (boxCache.Count <= i)
                {
                    var newBox = Instantiate(box);
                    newBox.SetActive(true);
                    boxCache.Add(newBox);
                }

                boxCache[i].transform.localPosition = new Vector3((float) x.position.x, (float) x.position.y, 0f);
                foreach (var r in boxCache[i].GetComponentsInChildren<Renderer>())
                {
                    r.material.color = new Color32((byte) x.color.r, (byte) x.color.g, (byte) x.color.b, (byte) x.alpha);
                }
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
