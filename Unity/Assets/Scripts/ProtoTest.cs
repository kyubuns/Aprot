using Aprot;
using haxe.lang;
using UnityEngine;
using UnityEngine.UI;

namespace Proto
{
    public class ProtoTest : MonoBehaviour
    {
        [SerializeField] private Text debugText = default;
        [SerializeField] private InputField inputField = default;
        [SerializeField] private Button connectButton = default;

        public void Start()
        {
            inputField.text = PlayerPrefs.GetString("DebugKey", "");
            connectButton.onClick.AddListener(() =>
            {
                Debug.Log($"Connect to {inputField.text}");
                PlayerPrefs.SetString("DebugKey", inputField.text);

                Engine.ConnectDevelopmentServer(inputField.text);
            });

            Engine.LuaTest();
        }
    }
}
