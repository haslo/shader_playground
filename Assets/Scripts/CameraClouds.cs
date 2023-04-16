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

    private Camera theCamera;
    [SerializeField] private Material theMaterial;

    public Material TheMaterial {
        get {
            if (theMaterial == null && cloudShader != null) {
                theMaterial = new Material(cloudShader);
            }

            if (theMaterial != null && cloudShader == null) {
                DestroyImmediate(theMaterial);
            }

            if (theMaterial != null && cloudShader != null && cloudShader != theMaterial.shader) {
                DestroyImmediate(theMaterial);
                theMaterial = new Material(cloudShader);
            }

            return theMaterial;
        }
    }

    public void Start() {
        if (theMaterial.shader == null) {
            DestroyImmediate(theMaterial);
            theMaterial = TheMaterial;
        }
    }

    [ImageEffectOpaque]
    public void OnRenderImage(RenderTexture source, RenderTexture destination) {
        if (theMaterial == null || valueNoiseImage == null) {
            Graphics.Blit(source, destination);
            return;
        }

        if (theCamera == null) {
            theCamera = GetComponent<Camera>();
        }

        TheMaterial.SetTexture("_ValueNoise", valueNoiseImage);
        if (sun != null) {
            TheMaterial.SetVector("_SunDir", sun.forward);
        } else {
            TheMaterial.SetVector("_SunDir", Vector3.up);
        }

        TheMaterial.SetFloat("_MinHeight", minHeight);
        TheMaterial.SetFloat("_MaxHeight", maxHeight);
        TheMaterial.SetFloat("_FadeDist", fadeDist);
        TheMaterial.SetFloat("_Scale", scale);
        TheMaterial.SetFloat("_Steps", steps);

        TheMaterial.SetMatrix("_FrustumCornersWS", GetFrustumCorners());
        TheMaterial.SetMatrix("_CameraInvViewMatrix", theCamera.cameraToWorldMatrix);
        TheMaterial.SetVector("_CameraPosWS", theCamera.transform.position);

        CustomGraphicsBlit(source, destination, TheMaterial, 0);
    }

    private Matrix4x4 GetFrustumCorners() {
        Matrix4x4 frustumCorners = Matrix4x4.identity;
        Vector3[] frustumCornerVectors = new Vector3[4];

        theCamera.CalculateFrustumCorners(new Rect(0, 0, 1, 1),
            theCamera.farClipPlane,
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
        if (theMaterial) {
            DestroyImmediate(theMaterial);
        }
    }
}
