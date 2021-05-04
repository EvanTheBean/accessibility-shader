using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class cameraPitch : MonoBehaviour
{
    public float pitch = 0.0f;
    public float turnSpeed = 0.0f;
    public float pitchMax, pitchMin;

    void FixedUpdate()
    {
        pitch -= Input.GetAxis("Mouse Y");
    }

    void LateUpdate()
    {
        Quaternion target;

        if (pitch < pitchMin)
        {
            pitch = pitchMin;
        }
        else if (pitch > pitchMax)
        {
            pitch = pitchMax;
        }

        target = Quaternion.Euler(new Vector3(pitch * turnSpeed, transform.parent.eulerAngles.y, 0.0F)) ;
        transform.rotation = target;
    }

    void Update()
    {
        if (Input.GetKey(KeyCode.Escape))
        {
            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;
        }
        else
        {
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }
    }
}
