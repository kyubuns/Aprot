using UnityEngine;
using UnityEngine.UI;

public class Test : MonoBehaviour
{
    [SerializeField] private Text logText = default;

    void Start()
    {
        logText.text = "Init...";
    }
}
