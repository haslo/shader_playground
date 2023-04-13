using System.Collections;
using UnityEngine;
using Random = UnityEngine.Random;

public class PlaneModifier : MonoBehaviour {

    private Renderer matRenderer;
    
    private float targetUVX = 1;
    private float targetUVY = 1;
    private float deltaUVX = 1;
    private float deltaUVY = 1;
    
    private float targetUVOffsetX = 0;
    private float targetUVOffsetY = 0;
    private float deltaUVOffsetX = 0;
    private float deltaUVOffsetY = 0;
    
    private static readonly int SCALE_UVX = Shader.PropertyToID("_ScaleUVX");
    private static readonly int SCALE_UVY = Shader.PropertyToID("_ScaleUVY");
    private static readonly int OFFSET_UVX = Shader.PropertyToID("_OffsetUVX");
    private static readonly int OFFSET_UVY = Shader.PropertyToID("_OffsetUVY");

    void Start() {
        matRenderer = GetComponent<Renderer>();
        StartCoroutine(TargetUVSelectionX());
        StartCoroutine(TargetUVSelectionY());
        StartCoroutine(TargetOffsetSelectionX());
        StartCoroutine(TargetOffsetSelectionY());
    }

    IEnumerator TargetUVSelectionX() {
        while (true) {
            var waitTime = Random.Range(1f, 4f);
            var currentUVX = matRenderer.material.GetFloat(SCALE_UVX);
            targetUVX = Random.Range(0.1f, 20f);
            deltaUVX = (targetUVX - currentUVX) / waitTime;
            yield return new WaitForSeconds(waitTime);
        }
    }
    IEnumerator TargetUVSelectionY() {
        while (true) {
            var waitTime = Random.Range(1f, 4f);
            var currentUVY = matRenderer.material.GetFloat(SCALE_UVY);
            targetUVY = Random.Range(0.1f, 20f);
            deltaUVY = (targetUVY - currentUVY) / waitTime;
            yield return new WaitForSeconds(waitTime);
        }
    }

    IEnumerator TargetOffsetSelectionX() {
        while (true) {
            var waitTime = Random.Range(1f, 4f);
            var currentUVOffsetX = matRenderer.material.GetFloat(OFFSET_UVX);
            targetUVOffsetX = Random.Range(0f, 20f);
            deltaUVOffsetX = (targetUVOffsetX - currentUVOffsetX) / waitTime;
            yield return new WaitForSeconds(waitTime);
        }
    }
    IEnumerator TargetOffsetSelectionY() {
        while (true) {
            var waitTime = Random.Range(1f, 4f);
            var currentUVOffsetY = matRenderer.material.GetFloat(OFFSET_UVY);
            targetUVOffsetY = Random.Range(0f, 20f);
            deltaUVOffsetY = (targetUVOffsetY - currentUVOffsetY) / waitTime;
            yield return new WaitForSeconds(waitTime);
        }
    }
    
    void Update()
    {
        var currentUVX = matRenderer.material.GetFloat(SCALE_UVX);
        var currentUVY = matRenderer.material.GetFloat(SCALE_UVY);
        matRenderer.material.SetFloat(SCALE_UVX, currentUVX + deltaUVX * Time.deltaTime);
        matRenderer.material.SetFloat(SCALE_UVY, currentUVY + deltaUVY * Time.deltaTime);
        var currentUVOffsetX = matRenderer.material.GetFloat(OFFSET_UVX);
        var currentUVOffsetY = matRenderer.material.GetFloat(OFFSET_UVY);
        matRenderer.material.SetFloat(OFFSET_UVX, currentUVOffsetX + deltaUVOffsetX * Time.deltaTime);
        matRenderer.material.SetFloat(OFFSET_UVY, currentUVOffsetY + deltaUVOffsetY * Time.deltaTime);
    }
}
