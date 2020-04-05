using System;
using System.IO;
using UnityEngine;
using UnityEngine.UI;
using Jurassic;
using Jurassic.Library;

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
        LoadJs();

        entities = (ArrayInstance) mainObject.CallMemberFunction("init");
        Log(PrintEntities(entities));

        Log("Start - Finish");
    }

    private void LoadJs()
    {
        mainJsLastChanged = File.GetLastWriteTime(MainJs);

        Debug.Log($"LoadJs {mainJsLastChanged}");
        var rawText = File.ReadAllText(MainJs);
        if (string.IsNullOrWhiteSpace(rawText))
        {
            Debug.Log("text is null");
            return;
        }

        var engine = new ScriptEngine();
        engine.Evaluate(rawText);

        mainObject = engine.GetGlobalValue<ObjectInstance>("Main");
    }

    public void Update()
    {
        if (mainJsLastChanged != File.GetLastWriteTime(MainJs))
        {
            LoadJs();
        }

        var systems = (ArrayInstance) mainObject.CallMemberFunction("getSystems");
        foreach (ObjectInstance system in systems.ElementValues)
        {
            system.CallMemberFunction("run", entities);
        }

        // Log(PrintEntities(entities));

        var t = GetComponent((ObjectInstance) entities[0], "transform");
        var p = (ObjectInstance) t["position"];
        var v = new Vector2(ToFloat(p["x"]), ToFloat(p["y"]));
        square.transform.localPosition = v;
    }

    private float ToFloat(object n)
    {
        if (n is double d) return (float) d;
        if (n is int i) return i;
        throw new Exception($"unknown {n.GetType()}");
    }

    private ObjectInstance GetComponent(ObjectInstance entity, string key)
    {
        return (ObjectInstance) entity[key];
    }

    private string PrintEntities(ArrayInstance e)
    {
        var txt = "## PrintEntities";
        foreach (ObjectInstance entity in e.ElementValues)
        {
            txt += $"\n  - entity";
            txt += PrintObject(entity, "    ");
        }
        return txt;
    }

    private string PrintObject(ObjectInstance obj, string prefix)
    {
        var txt = "";
        foreach (var property in obj.Properties)
        {
            if (property.Value is ObjectInstance objectInstance)
            {
                txt += $"\n{prefix}- {property.Key}";
                txt += PrintObject(objectInstance, $"{prefix}  ");
                continue;
            }
            txt += $"\n{prefix}- {property.Key} = {property.Value}({property.Value.GetType()})";
        }
        return txt;
    }

    private void Log(string text)
    {
        Debug.Log(text);
        logText.text = $"{text}\n{logText.text}";
    }
}
