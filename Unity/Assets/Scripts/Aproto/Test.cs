using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;

public class Test : MonoBehaviour
{
    void Start()
    {
        var luaSource = Resources.Load<TextAsset>("lua").text;
        Debug.Log(luaSource);

        var luaenv = new LuaEnv();
        var exports = (LuaTable) luaenv.DoString(luaSource)[0];

        var nameSpace = exports.Get<LuaTable>("proto");
        var mainClass = nameSpace.Get<LuaTable>("Main");

        Debug.Log((string) mainClass.Get<LuaFunction>("createInitEntities").Call()[0]);
    }
}
