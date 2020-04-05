using UnityEngine;
using UnityEngine.UI;
using Jurassic;
using Jurassic.Library;

public class Test : MonoBehaviour
{
    [SerializeField] private Text logText = default;

    public void Start()
    {
        logText.text = "Init...";

        Log("Start");

        var rawText = System.IO.File.ReadAllText(@"/Users/kyubuns/code/Aprot/Haxe/out/js/main.js");
        Debug.Log(rawText);

        var engine = new ScriptEngine();
        engine.Evaluate(rawText);

        var mainObject = engine.GetGlobalValue<ObjectInstance>("Main");
        Log($"mainObject = {mainObject}");

        var entities = (ArrayInstance) mainObject.CallMemberFunction("init");
        Log(PrintEntities(entities));

        var systems = (ArrayInstance) mainObject.CallMemberFunction("getSystems");
        foreach (ObjectInstance system in systems.ElementValues)
        {
            system.CallMemberFunction("run", entities);
        }

        Log(PrintEntities(entities));

        Log("Finish");
    }

    private string PrintEntities(ArrayInstance entities)
    {
        var txt = "## PrintEntities";
        foreach (ObjectInstance entity in entities.ElementValues)
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
