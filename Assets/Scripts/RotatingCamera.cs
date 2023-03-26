using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotatingCamera : MonoBehaviour
{
    public float rotationSpeed = 10f;

    void Start()
    {
        StartCoroutine(RotateCamera());
    }

    IEnumerator RotateCamera()
    {
        while (true)
        {
            transform.RotateAround(Vector3.zero, Vector3.up, rotationSpeed * Time.deltaTime);
            transform.LookAt(new Vector3(0, 1f, 0));
            yield return null;
        }
    }
}
