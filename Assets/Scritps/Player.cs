using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    Rigidbody rb;
    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        rb.AddForce(new Vector3(0,0,-1),ForceMode.Force);
        if (Input.GetKeyDown(KeyCode.Space))
        {
            rb.AddForce(Vector3.up, ForceMode.Impulse);
        }
    }
}
