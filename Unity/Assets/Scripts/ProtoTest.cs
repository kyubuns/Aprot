using System;
using Aprot;
using proto.inputContext;
using UnityEngine;
using UnityEngine.UI;
using Vector2 = aprotHx.type.Vector2;

namespace Proto
{
    public class ProtoTest : MonoBehaviour
    {
        [SerializeField] private Text debugText = default;
        [SerializeField] private InputField inputField = default;
        [SerializeField] private Button connectButton = default;

        private Engine engine;

        public void Start()
        {
            inputField.text = PlayerPrefs.GetString("DebugKey", "");
            connectButton.onClick.AddListener(() =>
            {
                Debug.Log($"Connect to {inputField.text}");
                PlayerPrefs.SetString("DebugKey", inputField.text);

                engine = new Engine();
                engine.ConnectDevelopmentServer(inputField.text);
            });
        }

        public void Update()
        {
            if (engine == null) return;

            var time = new proto.inputContext.Time(UnityEngine.Time.deltaTime);
            var input = new proto.inputContext.Input(new Vector2(0, 0));
            var inputContext = new InputContext(time, input);
            var outputContext = engine.Update(inputContext);

            var renderQueue = outputContext.renderer.queue.toTyped();
            Debug.Log($"{renderQueue[0].x}, {renderQueue[0].y}");
        }

        public void OnDestroy()
        {
            engine?.Dispose();
        }
    }
}
