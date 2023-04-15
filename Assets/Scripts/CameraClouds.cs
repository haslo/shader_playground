using System;
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

    public void Start() {
        if (material) {
            DestroyImmediate(material);
        }
    }

    [ImageEffectOpaque]
    public void OnRenderImage(RenderTexture source, RenderTexture destination) {
        if (material == null || valueNoiseImage == null) {
            Graphics.Blit(source, destination);
            return;
        }

        if (camera == null) {
            camera = GetComponent<Camera>();
        }

        Material.SetTexture("_ValueNoise", valueNoiseImage);
        if (sun != null) {
            Material.SetVector("_SunDir", sun.forward);
        } else {
            Material.SetVector("_SunDir", Vector3.up);
        }

        Material.SetFloat("_MinHeight", minHeight);
        Material.SetFloat("_MaxHeight", maxHeight);
        Material.SetFloat("_FadeDist", fadeDist);
        Material.SetFloat("_Scale", scale);
        Material.SetFloat("_Steps", steps);

        Material.SetMatrix("_FrustumCornersWS", GetFrustumCorners());
        Material.SetMatrix("_CameraInvViewMatrix", camera.cameraToWorldMatrix);
        Material.SetVector("_CameraPosWS", camera.transform.position);

        CustomGraphicsBlit(source, destination, Material, 0);
    }

    private Matrix4x4 GetFrustumCorners() {
        Matrix4x4 frustumCorners = Matrix4x4.identity;
        Vector3[] frustumCornerVectors = new Vector3[4];

        camera.CalculateFrustumCorners(new Rect(0, 0, 1, 1),
            camera.farClipPlane,
            Camera.MonoOrStereoscopicEye.Mono,
            frustumCornerVectors);
        frustumCorners.SetRow(0, frustumCornerVectors[1]);
        frustumCorners.SetRow(1, frustumCornerVectors[2]);
        frustumCorners.SetRow(2, frustumCornerVectors[3]);
        frustumCorners.SetRow(3, frustumCornerVectors[0]);

        return frustumCorners;
    }
    
    static void CustomGraphicsBlit(RenderTexture source, RenderTexture dest, Material fxMaterial, int passNr) {
        RenderTexture.active = dest;
        fxMaterial.SetTexture("_MainTex", source);
        GL.PushMatrix();
        GL.LoadOrtho();
        fxMaterial.SetPass(passNr);
        GL.Begin(GL.QUADS);
        GL.MultiTexCoord2(0, 0.0f, 0.0f);
        GL.Vertex3(0.0f, 0.0f, 3.0f); // BL
        GL.MultiTexCoord2(0, 1.0f, 0.0f);
        GL.Vertex3(1.0f, 0.0f, 2.0f); // BR
        GL.MultiTexCoord2(0, 1.0f, 1.0f);
        GL.Vertex3(1.0f, 1.0f, 1.0f); // TR
        GL.MultiTexCoord2(0, 0.0f, 1.0f);
        GL.Vertex3(0.0f, 1.0f, 0.0f); // TL
        GL.End();
        GL.PopMatrix();
    }

    protected void OnDisable() {
        if (material) {
            DestroyImmediate(material);
        }
    }
}
