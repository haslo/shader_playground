using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotator : MonoBehaviour
{
    void Start()
    {
        StartCoroutine(Rotation());
    }

    private IEnumerator Rotation()
    {
        while (true)
        {
            this.transform.Rotate(new Vector3(0, Time.deltaTime * 80f, 0));
            yield return null;
        }
    }
}
