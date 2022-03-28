using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CallCamera : MonoBehaviour
{

    [HideInInspector]
    public WebCamTexture webTex;
    [HideInInspector]
    public string deviceName;
    //��ʾ����ͷ����
    public RawImage rawImage;


    //���������ı���
    //public Texture2D t = null;

    [Range(0, 5)]
    public float saturation = 1; // ���Ͷȵ������༭������  

    //Texture2D tt = null;



    // Use this for initialization
    void Start()
    {

        StartCoroutine(IECallCamera());
    }

    
    void Update()
    {
        //��Ⱦ
        /*
        for (int i = 0; i < 1920; i++)
        {
            for (int j = 0; j < 1080; j++)
            {
                Color temp = processColor(webTex.GetPixel(i, j));
                print(temp);
            }
        }
        */

        //print(webTex.GetPixels());
        //print(rawImage.Texture);

    }
    

    Color processColor(Color color)
    {
        Color c = color;
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
        Color res = new Color(R, G, B, 1); 

        return res;
    }


    IEnumerator IECallCamera()
    {
        yield return Application.RequestUserAuthorization(UserAuthorization.WebCam);
        if (Application.HasUserAuthorization(UserAuthorization.WebCam))
        {
            WebCamDevice[] devices = WebCamTexture.devices;
            deviceName = devices[0].name;
            //������������������    
            webTex = new WebCamTexture(deviceName, 1920, 1080, 120);
            webTex.Play();//��ʼ����    
 
            rawImage.texture = webTex;

        }
    }
}