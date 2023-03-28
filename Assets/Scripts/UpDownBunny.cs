using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UpDownBunny : MonoBehaviour
{
    private float _direction = 1;
    
    void Start()
    {
        StartCoroutine(UpDown());
    }

    private void Update()
    {
        this.transform.position = new Vector3(this.transform.position.x, this.transform.position.y + _direction * Time.deltaTime * 0.2f, this.transform.position.z);
    }

    private IEnumerator UpDown()
    {
        while (true)
        {
            _direction = 1;
            yield return new WaitForSeconds(1f);
            _direction = -1;
            yield return new WaitForSeconds(1f);
        }
    }
}
