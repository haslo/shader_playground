using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotatingBunny : MonoBehaviour
{
    public float rotationSpeed = 80f;
    
    void Start()
    {
        StartCoroutine(Rotation());
    }

    private IEnumerator Rotation()
    {
        while (true)
        {
            this.transform.Rotate(new Vector3(0, Time.deltaTime * rotationSpeed, 0));
            yield return null;
        }
    }
}
