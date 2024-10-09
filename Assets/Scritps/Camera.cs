using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Camera : MonoBehaviour
{
    public Material m_renderMaterial;
    public Material lutMaterial;

    // Update is called once per frame
    void Update()
    {
        transform.position += new Vector3(0, 0, -0.1f);
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Debug.Log("OnRenderImage called"); // Check if this message appears
        if (lutMaterial != null)
        {
            Graphics.Blit(source, destination, lutMaterial);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}
