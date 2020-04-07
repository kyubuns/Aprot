using System;
using System.Collections;
using System.IO;
using System.Threading.Tasks;
using Jint;
using Jint.Native;
using Jint.Native.Array;
using Jint.Native.Object;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

public class Test : MonoBehaviour
{
    [SerializeField] private Text logText = default;
    [SerializeField] private Image square = default;
    [SerializeField] private bool autoReload = true;

    private ObjectInstance mainObject;
    private ArrayInstance entities;
    private DateTime mainJsLastChanged;

    private const string MainJs = @"/Users/kyubuns/code/Aprot/Haxe/out/js/main.js";
    private const string MainServer = "http://192.168.86.24:5000/main.js";
    private bool loading = false;

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

        var aprotHxNameSpace = engine.GetValue("aprotHx");
        mainObject = (ObjectInstance) aprotHxNameSpace.Get("Main");
        loading = false;
        Log("Load Finished");
    }

    public void LoadJsFromWeb()
    {
        if (loading) return;
        loading = true;

        Log("LoadJsFromWeb");

        StartCoroutine(LoadJsFromWebInternal());
    }

    private IEnumerator LoadJsFromWebInternal()
    {
        var request = UnityWebRequest.Get(MainServer);
        yield return request.SendWebRequest();

        if (request.isNetworkError || request.isHttpError)
        {
            Log(request.error);
        }
        else
        {
            LoadJs(request.downloadHandler.text);
        }
    }

    private void LoadJsFromResources()
    {
        if (loading) return;
        loading = true;

        Log("LoadJsFromResources");

        var readText = ((TextAsset) Resources.Load("main")).text;
        LoadJs(readText);
    }

    private void LoadJsFromLocal()
    {
        if (loading) return;
        loading = true;

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
        if (mainObject == null) return;

        if (autoReload && Application.isEditor)
        {
            if (mainJsLastChanged != File.GetLastWriteTime(MainJs))
            {
                LoadJsFromLocal();
            }
        }

        var time = new aprotHx.context.Time(Time.deltaTime);
        var input = new aprotHx.context.Input(0f, 0f);
        var inputWorld = new aprotHx.world.InputWorld(time, input);
        var serializedInputWorld = aprotHx.world.InputWorld.serialize(inputWorld);

        mainObject.Get("start").Invoke(serializedInputWorld);

        var systems = (ArrayInstance) mainObject.Get("getSystems").Invoke();
        foreach (var system in systems)
        {
            system.Get("run").Invoke(entities);
        }

        var serializedOutputWorld = mainObject.Get("finish").Invoke().AsString();
        var outputWorld = aprotHx.world.OutputWorld.serialize(serializedOutputWorld);

        // Log(PrintEntities(entities));

        var renderQueue = outputWorld.renderer.queue.toTyped();

        var v = new Vector2((float) renderQueue[0].x, (float) renderQueue[0].y);
        square.transform.localPosition = v;
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
