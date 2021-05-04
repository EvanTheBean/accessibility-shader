using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class moveCamera : MonoBehaviour
{
    CharacterController characterController;

    public float speed = 6.0f;
    public float jumpSpeed = 8.0f;
    public float gravity = 20.0f;

    private float yaw = 0.0F;
    public float turnSpeed = 1f;

    private Vector3 moveDirection = Vector3.zero;

    void Start()
    {
        characterController = GetComponent<CharacterController>();
        Physics.gravity = new Vector3(0, -10.0F, 0);
    }

    void Update()
    {
        moveDirection = transform.TransformDirection(new Vector3(Input.GetAxis("Horizontal"), Input.GetAxis("Up/Down"), Input.GetAxis("Vertical")));
        moveDirection *= speed;

        // Move the controller
        characterController.Move(moveDirection * Time.deltaTime);

        if (Input.GetKey(KeyCode.Escape))
        {
            Application.Quit();
        }
    }

    void FixedUpdate()
    {
        yaw += Input.GetAxis("Mouse X");
    }

    void LateUpdate()
    {
        Quaternion target = Quaternion.Euler(new Vector3(0.0f, yaw * turnSpeed, 0.0F));
        transform.rotation = target;
    }
}