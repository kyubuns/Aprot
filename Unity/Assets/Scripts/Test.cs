using System;
using System.IO;
using Jint;
using Jint.Native;
using Jint.Native.Array;
using Jint.Native.Object;
using UnityEngine;
using UnityEngine.UI;

public class Test : MonoBehaviour
{
    [SerializeField] private Text logText = default;
    [SerializeField] private Image square = default;

    private ObjectInstance mainObject;
    private ArrayInstance entities;
    private DateTime mainJsLastChanged;

    private const string MainJs = @"/Users/kyubuns/code/Aprot/Haxe/out/js/main.js";

    public void Start()
    {
        logText.text = "Init...";

        Log("Start");

        Application.targetFrameRate = 30;

        if (Application.isEditor)
        {
            LoadJsFromLocal();
        }
        else
        {
            LoadJsFromResources();
        }

        entities = (ArrayInstance) mainObject.Get("init").Invoke();
        Log(PrintEntities(entities));

        Log("Start - Finish");
    }

    private void LoadJs(string rawText)
    {
        var engine = new Engine();
        engine.Execute(rawText);

        mainObject = (ObjectInstance) engine.GetValue("Main");
    }

    private void LoadJsFromResources()
    {
        Log("LoadJsFromResources");

        var readText = ((TextAsset) Resources.Load("main")).text;
        LoadJs(readText);
    }

    private void LoadJsFromLocal()
    {
        mainJsLastChanged = File.GetLastWriteTime(MainJs);

        Debug.Log($"LoadJsFromLocal {mainJsLastChanged}");
        var rawText = File.ReadAllText(MainJs);
        if (string.IsNullOrWhiteSpace(rawText))
        {
            Debug.Log("text is null");
            return;
        }
        LoadJs(rawText);
    }

    public void Update()
    {
        if (Application.isEditor)
        {
            if (mainJsLastChanged != File.GetLastWriteTime(MainJs))
            {
                LoadJsFromLocal();
            }
        }

        var systems = (ArrayInstance) mainObject.Get("getSystems").Invoke();
        foreach (var system in systems)
        {
            system.Get("run").Invoke(entities);
        }

        // Log(PrintEntities(entities));

        var t = GetComponent((ObjectInstance) entities[0], "transform");
        var p = (ObjectInstance) t.Get("position");
        var v = new Vector2(ToFloat(p.Get("x")), ToFloat(p.Get("y")));
        square.transform.localPosition = v;
    }

    private float ToFloat(object n)
    {
        var number = (JsNumber) n;
        return (float) number.AsNumber();
    }

    private ObjectInstance GetComponent(ObjectInstance entity, string key)
    {
        return (ObjectInstance) entity.Get(key);
    }

    private string PrintEntities(ArrayInstance e)
    {
        var txt = "## PrintEntities";
        foreach (var entity in e)
        {
            txt += $"\n  - entity";
            txt += PrintObject((ObjectInstance) entity, "    ");
        }
        return txt;
    }

    private string PrintObject(ObjectInstance obj, string prefix)
    {
        var txt = "";
        foreach (var property in obj.GetOwnProperties())
        {
            if (property.Value.Value is ObjectInstance objectInstance)
            {
                txt += $"\n{prefix}- {property.Key}";
                txt += PrintObject(objectInstance, $"{prefix}  ");
                continue;
            }
            txt += $"\n{prefix}- {property.Key} = {property.Value.Value}({property.Value.Value.GetType()})";
        }
        return txt;
    }

    private void Log(string text)
    {
        Debug.Log(text);
        logText.text = $"{text}\n{logText.text}";
    }
}
