using System.ComponentModel;
using UnityEngine;

[ExecuteInEditMode]
public class CameraClouds : MonoBehaviour {
    [SerializeField] private Shader cloudShader;
    [SerializeField] private float minHeight = 0.0f;
    [SerializeField] private float maxHeight = 5.0f;
    [SerializeField] private float fadeDist = 2.0f;
    [SerializeField] private float scale = 5.0f;
    [SerializeField] private float steps = 50.0f;
    [SerializeField] private Texture valueNoiseImage;
    [SerializeField] private Transform sun;

    private Camera camera;
    private Material material;

    public Material Material {
        get {
            if (material == null && cloudShader != null) {
                material = new Material(cloudShader);
            }

            if (material != null && cloudShader == null) {
                DestroyImmediate(material);
            }
            if (material != null && cloudShader != null && cloudShader != material.shader) {
                DestroyImmediate(material);
                material = new Material(cloudShader);
            }
            return material;
        }
    }
}
