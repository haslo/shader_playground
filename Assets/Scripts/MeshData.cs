using UnityEngine;

public class MeshData : MonoBehaviour {
    void Start() {
        var mesh = GetComponent<MeshFilter>().mesh;
        foreach (var v in mesh.vertices) {
            // Debug.Log(v);
        }
    }
}
