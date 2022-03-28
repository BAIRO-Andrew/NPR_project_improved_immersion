using UnityEngine;
using System.Collections;

public class ImageProcessTest : MonoBehaviour
{

    //public Texture2D t;

    [Range(0, 5)]
    public float saturation = 1; // 饱和度调整，编辑器设置  

    Texture2D tt;

    void Start()
    {

        Texture2D t = new Texture2D(Screen.width, Screen.height);

        if (tt != null)
        {
            Destroy(tt);
        }




        transform.localScale = new Vector3((float)t.width / (float)t.height, 1);
        tt = new Texture2D(t.width, t.height);
        for (int y = 0; y < t.height; y++)
        {
            for (int x = 0; x < t.width; x++)
            {
                Color c = t.GetPixel(x, y);

                float r = c.r;
                float g = c.g;
                float b = c.b;

                float Y = (r * 0.299f) + (g * 0.587f) + (b * 0.114f);
                float U = -(r * 0.147f) - (g * 0.289f) + (b * 0.436f);
                float V = (r * 0.615f) - (g * 0.515f) - (b * 0.1f);

                U *= saturation;
                V *= saturation;

                float R = Y + (V * 1.14f);
                float G = Y - (U * 0.39f) - (V * 0.58f);
                float B = Y + (U * 2.03f);

                tt.SetPixel(x, y, new Color(R, G, B));
            }
        }
        tt.Apply();
        GetComponent<Renderer>().material.mainTexture = tt;
    }
}