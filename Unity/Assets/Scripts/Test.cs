using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Jint;
using Jint.Native;
using Jint.Native.Array;
using Jint.Native.Object;
using Jint.Native.Set;
using Jint.Runtime.Descriptors;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;
using Types = Jint.Runtime.Types;

public class Test : MonoBehaviour
{
    [SerializeField] private Text logText = default;
    [SerializeField] private Image[] squares = default;
    [SerializeField] private bool autoReload = true;

    private Engine engine;
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
        engine = new Engine();
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
            var requireComponents = new List<string[]>();
            var rawRequireComponents = system.Get("get").Invoke().ToArray<ArrayInstance>();
            foreach (var a in rawRequireComponents)
            {
                requireComponents.Add(a.ToArray<JsString>().Select(x => x.ToString()).ToArray());
            }
            var args = CreateEntities(requireComponents);
            PrintEntities((ArrayInstance) args[0]);
            system.Get("run").Invoke(args);
        }

        var serializedOutputWorld = mainObject.Get("finish").Invoke().AsString();
        var outputWorld = aprotHx.world.OutputWorld.serialize(serializedOutputWorld);

        // Log(PrintEntities(entities));

        var renderQueue = outputWorld.renderer.queue.toTyped();
        var i = 0;
        for (;i < Mathf.Min(squares.Length, renderQueue.Length); ++i)
        {
            var v = new Vector2((float) renderQueue[i].x, (float) renderQueue[i].y);
            squares[i].transform.localPosition = v;
            if (!squares[i].gameObject.activeSelf) squares[i].gameObject.SetActive(true);
        }
        for (; i < squares.Length; ++i)
        {
            if (squares[i].gameObject.activeSelf) squares[i].gameObject.SetActive(false);
        }
    }

    private JsValue[] CreateEntities(List<string[]> requireComponents)
    {
        var args = new List<JsValue>();

        foreach (var require in requireComponents)
        {
            var targets = new List<ObjectInstance>();

            foreach (var tmp in entities)
            {
                var entity = (ObjectInstance) tmp;
                var components = entity.GetOwnPropertyKeys(Types.String).Select(x => x.ToString()).ToArray();
                var isTarget = require.All(r => components.Contains(r));
                if (isTarget) targets.Add(entity);
            }

            args.Add(new ArrayInstance(engine, targets.Select(x => new PropertyDescriptor(x, true, true, true)).ToArray()));
        }

        return args.ToArray();
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

public static class JintExtensions
{
    public static T[] ToArray<T>(this JsValue self) where T : Jint.Native.JsValue
    {
        var selfArray = self.AsArray();
        var result = new T[selfArray.Length];
        for (var i = 0; i < selfArray.Length; ++i)
        {
            result[i] = (T) selfArray[(uint) i];
        }
        return result;
    }
}
