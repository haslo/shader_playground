using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScalingEntity : MonoBehaviour {
    private float scale = 1;
    public float maxScale = 1f;
    public float minScale = 0.1f;
    public float scaleSpeed = 3f;

    void Start() {
        StartCoroutine(Rescale());
    }

    private void Update() {
        this.transform.localScale = new Vector3(scale, scale, scale);
    }

    private IEnumerator Rescale() {
        while (true) {
            while (scale < maxScale) {
                yield return null;
                scale += (1 / scaleSpeed) * Time.deltaTime;
            }
            while (scale > minScale) {
                yield return null;
                scale -= (1 / scaleSpeed) * Time.deltaTime;
            }
        }
    }
}
