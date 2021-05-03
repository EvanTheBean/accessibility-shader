using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class postProcessingCamera : MonoBehaviour
{
    public Material simulation;
    public Material fix;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, simulation);
    }
}
