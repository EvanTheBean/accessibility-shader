using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

/*
    Post processing pipelline for color deficiency shaders
    Made by Evan Koppers
*/

public class postProcessingCamera : MonoBehaviour
{
    public RenderTexture middleStep;
    public Text words;
    public float estimationDifference;

    public Material simulation;
    public Material fix;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if(Settings.fixOn && Settings.simulationOn)
        {
            Graphics.Blit(source, middleStep, fix);
            Graphics.Blit(middleStep, destination, simulation);
        }
        else if(Settings.fixOn && !Settings.simulationOn)
        {
            Graphics.Blit(source, destination, fix);
        }
        else if(Settings.simulationOn && !Settings.fixOn)
        {
            Graphics.Blit(source, destination, simulation);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

    private void Update()
    {
        if(Input.GetKeyDown(KeyCode.Z))
        {
            Settings.simulationOn = !Settings.simulationOn;
        }

        if (Input.GetKeyDown(KeyCode.X))
        {
            Settings.fixOn = !Settings.fixOn;
        }

        if (Input.GetKeyDown(KeyCode.C))
        {
            Settings.type += 1;
            Settings.type = Settings.type %= 3;
            Shader.SetGlobalInt("type", Settings.type);
        }

        Shader.SetGlobalFloat("estimations", estimationDifference);

        words.text = "Type: ";
        if(Settings.type == 0)
        {
            words.text += "Protanope";
        }
        else if (Settings.type == 1)
        {
            words.text += "Deuteranope";
        }
        else if (Settings.type == 2)
        {
            words.text += "Tritanope";
        }
        words.text += "\nSimulation: " + (Settings.simulationOn ? "On" : "Off") + "\nFix: " + (Settings.fixOn ? "On" : "Off");
    }
}
