using UnityEngine;
using System.Collections;

public class ConstRotator : MonoBehaviour {
    public Vector3 axis;
    public float speed;

    void Update () {
        this.transform.localRotation = transform.localRotation * Quaternion.Euler(axis * speed);
	}
}
