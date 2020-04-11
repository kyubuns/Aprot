using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using DefaultNamespace;
using UnityEngine;
using UnityEngine.UI;
using Debug = UnityEngine.Debug;

public class Test : MonoBehaviour
{
    [SerializeField] private Text logText = default;
    [SerializeField] private Image[] squares = default;
    [SerializeField] private bool autoReload = true;

    private DateTime scriptLastChanged;
    private readonly ILanguage language = new JintJs();

    private int test1 = 0;
    private List<long> test2 = new List<long>();

    public void Start()
    {
        logText.text = "Init...";

        Log("Start");

        var rawScriptText = LoadScriptFromLocal();
        language.Load(rawScriptText);
        language.Init();

        Log("Start - Finish");
    }

    private string LoadScriptFromLocal()
    {
        scriptLastChanged = File.GetLastWriteTime(language.LocalFilePath);

        Debug.Log($"LoadJsFromLocal {scriptLastChanged}");
        var rawText = File.ReadAllText(language.LocalFilePath);
        if (string.IsNullOrWhiteSpace(rawText))
        {
            Debug.LogError("text is null");
            return null;
        }
        return rawText;
    }

    public void Update()
    {
        if (autoReload && Application.isEditor)
        {
            if (scriptLastChanged != File.GetLastWriteTime(language.LocalFilePath))
            {
                var rawScriptText = LoadScriptFromLocal();
                if (!string.IsNullOrWhiteSpace(rawScriptText))
                {
                    language.Load(rawScriptText);
                }
            }
        }

        var time = new aprotHx.context.Time(Time.deltaTime);
        var input = new aprotHx.context.Input(0f, 0f);
        var inputWorld = new aprotHx.world.InputWorld(time, input);
        var serializedInputWorld = aprotHx.world.InputWorld.serialize(inputWorld);

        var sw = Stopwatch.StartNew();
        var serializedOutputWorld = language.Update(serializedInputWorld);
        sw.Stop();
        test1++;
        if (test1 > 100)
        {
            test2.Add(sw.ElapsedMilliseconds);
            if (test2.Count == 100)
            {
                var sum = test2.Sum() / test2.Count;
                Debug.Log($"Result: [{language}] avg: {sum:0.00}ms, min: {test2.Min():0.00}ms, max: {test2.Max():0.00}ms");
            }
        }

        var outputWorld = aprotHx.world.OutputWorld.serialize(serializedOutputWorld);
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

    private void Log(string text)
    {
        Debug.Log(text);
        logText.text = $"{text}\n{logText.text}";
    }
}

