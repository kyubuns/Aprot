using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test : MonoBehaviour
{
    void Start()
    {
        var luaText = Resources.Load<TextAsset>("lua");
        Debug.Log(luaText);
    }
}
