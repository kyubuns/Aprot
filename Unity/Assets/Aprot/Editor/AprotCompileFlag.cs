using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace Aprot.Editor
{
    public static class AprotCompileFlag
    {
        [MenuItem("Aprot/Full C#")]
        public static void ChangeToFullCsharp()
        {
            Debug.Log("ChangeToFullCsharp");

            var di = new DirectoryInfo(Path.Combine(Application.dataPath, "Aprot", "Plugins"));
            di.Delete(true);
            File.Delete(Path.Combine(Application.dataPath, "Aprot", "Plugins.meta"));

            var buildTargetGroup = EditorUserBuildSettings.selectedBuildTargetGroup;
            var defines = PlayerSettings.GetScriptingDefineSymbolsForGroup(buildTargetGroup).Split(';').ToList();
            defines.Add("FULL_CSHARP");
            PlayerSettings.SetScriptingDefineSymbolsForGroup(buildTargetGroup, string.Join(";", defines));

            AssetDatabase.Refresh();
        }
    }
}
