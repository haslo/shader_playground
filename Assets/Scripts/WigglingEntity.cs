using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WigglingEntity : MonoBehaviour {
    private bool reverse = true;
    public float rotationSpeed = 80f;
    public float wiggleTime = 5;

    void Start() {
        StartCoroutine(Rotation());
        StartCoroutine(ToggleRotationDirection());
    }

    private IEnumerator Rotation() {
        while (true) {
            this.transform.Rotate(new Vector3(0, Time.deltaTime * rotationSpeed * (reverse ? -1 : 1), 0));
            yield return null;
        }
    }

    private IEnumerator ToggleRotationDirection() {
        while (true) {
            reverse = false;
            yield return new WaitForSeconds(wiggleTime);
            reverse = true;
            yield return new WaitForSeconds(wiggleTime);
        }
    }
}
