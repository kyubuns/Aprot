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

    public void Start()
    {
        logText.text = "Init...";

        Log("Start");

        var rawText = System.IO.File.ReadAllText(@"/Users/kyubuns/code/Aprot/Haxe/out/js/main.js");
        Debug.Log(rawText);

        var engine = new ScriptEngine();
        engine.Evaluate(rawText);

        mainObject = engine.GetGlobalValue<ObjectInstance>("Main");
        Log($"mainObject = {mainObject}");

        entities = (ArrayInstance) mainObject.CallMemberFunction("init");
        Log(PrintEntities(entities));

        Log("Start - Finish");
    }

    public void Update()
    {
        Log("Update");

        var systems = (ArrayInstance) mainObject.CallMemberFunction("getSystems");
        foreach (ObjectInstance system in systems.ElementValues)
        {
            system.CallMemberFunction("run", entities);
        }

        Log(PrintEntities(entities));

        var t = GetComponent((ObjectInstance) entities[0], "transform");
        var p = (ObjectInstance) t["position"];
        var v = new Vector2((float) (double) p["x"], (float) (double) p["y"]);
        square.transform.localPosition = v;

        Log("Update - Finish");
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
            txt += $"\n{prefix}- {property.Key} = {property.Value}";
        }
        return txt;
    }

    private void Log(string text)
    {
        Debug.Log(text);
        logText.text = $"{text}\n{logText.text}";
    }
}
