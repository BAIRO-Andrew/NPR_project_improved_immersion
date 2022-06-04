Shader "Custom/ToonifyImprovedImmersion"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Brightness ("Brightness", Float) = 1.8
        _Satruation ("Saturation", Float) = 0.85
        _Constart ("Constart", Float) = 2.04
        _Para("para", Float) = 0.3
    }
    SubShader
    {


        ZTest Always Cull Off ZWrite Off
       
        Pass{
            
            //NAME "EDGES_EFFECT"

            CGPROGRAM
            #pragma vertex vert  
		    #pragma fragment frag 
            #include "UnityCG.cginc"

        

            sampler2D _MainTex;
            half4 _MainTex_TexelSize;
            half _Brightness;
            half _Satruation;
            half _Constart;
            half _Para;



            struct v2f{
                float4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
                //fixed3 mid_color : COLOR0;
            };


            // return the sum of rgb
            fixed getRGBSum(fixed3 color){
                return color.r + color.g + color.b;
            }


            // calculate the lumiance
            fixed lumiance(fixed3 color){
                return 0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b;
            }

            //median filter function
            fixed3 medianFilter(half2 uv){
                //half2 uv = f.uv;


                half2 tex7[49] = {uv + float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 3.0), uv + float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 3.0), uv + float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 3.0), uv + float2(0.0, _MainTex_TexelSize.y * 3.0), uv + float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 3.0), uv + float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 3.0), uv + float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 3.0), 
                                uv + float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 2.0), uv + float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 2.0), uv + float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 2.0), uv + float2(0.0, _MainTex_TexelSize.y * 2.0), uv + float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 2.0), uv + float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 2.0), uv + float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 2.0), 
                                uv + float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 1.0), uv + float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 1.0), uv + float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 1.0), uv + float2(0.0, _MainTex_TexelSize.y * 1.0), uv + float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 1.0), uv + float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 1.0), uv + float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 1.0), 
                                uv + float2(-_MainTex_TexelSize.x * 3.0, 0.0), uv + float2(-_MainTex_TexelSize.x * 2.0, 0.0), uv + float2(-_MainTex_TexelSize.x * 1.0, 0.0), uv, uv + float2(_MainTex_TexelSize.x * 1.0, 0.0), uv + float2(_MainTex_TexelSize.x * 2.0, 0.0), uv + float2(_MainTex_TexelSize.x * 3.0, 0.0), 
                                uv - float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 1.0), uv - float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 1.0), uv - float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 1.0), uv - float2(0.0, _MainTex_TexelSize.y * 1.0), uv - float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 1.0), uv - float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 1.0), uv - float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 1.0),
                                uv - float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 2.0), uv - float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 2.0), uv - float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 2.0), uv - float2(0.0, _MainTex_TexelSize.y * 2.0), uv - float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 2.0), uv - float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 2.0), uv - float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 2.0),
                                uv - float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 3.0), uv - float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 3.0), uv - float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 3.0), uv - float2(0.0, _MainTex_TexelSize.y * 3.0), uv - float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 3.0), uv - float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 3.0), uv - float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 3.0)};
                
           
                half2 tex9[9] = {uv + _MainTex_TexelSize.xy * half2(-1, 1), uv + _MainTex_TexelSize.xy * half2(0, 1), uv + _MainTex_TexelSize.xy * half2(1, 1), 
                                uv + _MainTex_TexelSize.xy * half2(-1, 0), uv, uv + _MainTex_TexelSize.xy * half2(1, 0),
                                uv + _MainTex_TexelSize.xy * half2(-1, -1), uv + _MainTex_TexelSize.xy * half2(0, -1), uv + _MainTex_TexelSize.xy * half2(1, -1)};

                
               
                fixed3 last = (0, 0, 0);
                fixed3 temp = tex2D(_MainTex, tex7[0]).rgb;
                [unroll]
                for(int i = 0; i < 25; i++){

                    [unroll]
                    for(int j = 0; j < 49; j++){
                        fixed3 color = tex2D(_MainTex, tex7[j]).rgb;
                        fixed w1 = step(color, temp);
                        fixed w2 = step(temp, last);
                        temp = lerp(temp, color, w1*w2);
                    }

                    last = temp;
                }


                return temp;
                


                /*
                fixed3 res = (0, 0, 0);
                [unroll]
                for(int i = 0; i < 9; i++){
                    fixed3 temp = tex2D(_MainTex, tex9[i]).rgb;
                    res += temp;
                }

                res = res / 9;

                return res;
                */
            }



            fixed3 GaussianFliter(half2 uv){
                half2 tex5[25] = {uv + _MainTex_TexelSize.xy * half2(-2, 2), uv + _MainTex_TexelSize.xy * half2(-1, 2), uv + _MainTex_TexelSize.xy * half2(0, 2), uv + _MainTex_TexelSize.xy * half2(1, 2), uv + _MainTex_TexelSize.xy * half2(2, 2), 
                                uv + _MainTex_TexelSize.xy * half2(-2, 1), uv + _MainTex_TexelSize.xy * half2(-1, 1), uv + _MainTex_TexelSize.xy * half2(0, 1), uv + _MainTex_TexelSize.xy * half2(1, 1), uv + _MainTex_TexelSize.xy * half2(2, 1), 
                                uv + _MainTex_TexelSize.xy * half2(-2, 0), uv + _MainTex_TexelSize.xy * half2(-1, 0), uv + _MainTex_TexelSize.xy * half2(0, 0), uv + _MainTex_TexelSize.xy * half2(1, 0), uv + _MainTex_TexelSize.xy * half2(2, 0), 
                                uv + _MainTex_TexelSize.xy * half2(-2, -1), uv + _MainTex_TexelSize.xy * half2(-1, -1), uv + _MainTex_TexelSize.xy * half2(0, -1), uv + _MainTex_TexelSize.xy * half2(1, -1), uv + _MainTex_TexelSize.xy * half2(2, -1), 
                                uv + _MainTex_TexelSize.xy * half2(-2, -2), uv + _MainTex_TexelSize.xy * half2(-1, -2), uv + _MainTex_TexelSize.xy * half2(0, -2), uv + _MainTex_TexelSize.xy * half2(1, -2), uv + _MainTex_TexelSize.xy * half2(2, -2)};
                
                half weight[25] = {0.0030, 0.0133, 0.0219, 0.0133, 0.0030,
                                   0.0133, 0.0596, 0.0983, 0.0596, 0.0133,
                                   0.0219, 0.0983, 0.1621, 0.0983, 0.0219, 
                                   0.0133, 0.0596, 0.0983, 0.0596, 0.0133,
                                   0.0030, 0.0133, 0.0219, 0.0133, 0.0030};

                fixed3 centerLum = lumiance(tex2D(_MainTex, tex5[12]).rgb);
                fixed3 res = (0, 0, 0);
                [unroll]
                for(int i = 0; i < 25; i++){
                    //res += tex2D(_MainTex, tex5[i]).rgb * weight[i] * normalize(Sobel(tex5[i]));
                    
                    fixed3 temp_color = tex2D(_MainTex, tex5[i]).rgb;
                    fixed final_weight = weight[i] * (1 - abs(centerLum - lumiance(temp_color)));
                    res += temp_color * final_weight;
                    
                }

                return res;
            }





        // color mapping function
            fixed3 ColorMapping(fixed3 color){
                const fixed ColorMap[256] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
                                     0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 0.0941, 
                                     0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 0.1882, 
                                     0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 0.2824, 
                                     0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 0.3765, 
                                     0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 0.4706, 
                                     0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 0.5647, 
                                     0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 0.6588, 
                                     0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 0.7529, 
                                     0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 0.8471, 
                                     0.9412, 0.9412, 0.9412, 0.9412, 0.9412, 0.9412, 0.9412, 0.9412, 0.9412, 0.9412, 0.9412, 0.9412, 0.9412, 0.9412, 0.9412, 0.9412};


            
                fixed red = color.r;
                fixed green = color.g;
                fixed blue = color.b;


                int red_index = int(floor(red * 255));
                int green_index = int(floor(green * 255));
                int blue_index = int(floor(blue * 255));

                fixed3 new_color = fixed3(ColorMap[red_index], ColorMap[green_index], ColorMap[blue_index]);
            
                return new_color;
            }


            // quantize color function
            fixed3 QuantizeColors(fixed3 color){
                return floor(color * 255 / 24) * 24 / 255;
                //return floor(color * 255 * 0.04166667) * 24 * 0.00392157;
                //return ColorMapping(color);
            }


       

            // final color function
            fixed3 ColorCalculation(fixed3 color){
                fixed3 finalColor = ColorMapping(color);
            
                // Brightness
                //finalColor = finalColor * _Brightness;
                //finalColor = finalColor * 1.1;

                // Saturation
                //finalColor = lerp(lumiance(color), finalColor, _Satruation);

                // Constart
                //finalColor = lerp(fixed3(0.5, 0.5, 0.5), finalColor, _Constart);
            
                return finalColor;
            }


            // calculate the color's luminance
            fixed luminance(fixed3 color){
                return 0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b;
            }



            half Sobel(half2 uv){
                const half Gx[9] = {-1, -2, -1, 
                            0, 0, 0, 
                            1, 2, 1};
                const half Gy[9] = {-1, 0, 1, 
                            -2, 0, 2,
                            -1, 0, 1};
            
                //half2 uv = f.uv[2];
                half2 tex[9] = {uv + _MainTex_TexelSize.xy * half2(-1, -1), uv + _MainTex_TexelSize.xy * half2(0, -1), uv + _MainTex_TexelSize.xy * half2(1, -1),
                            uv +  _MainTex_TexelSize.xy * half2(-1, 0), uv,  uv + _MainTex_TexelSize.xy * half2(1, 0), 
                            uv + _MainTex_TexelSize.xy * half2(-1, 1), uv + _MainTex_TexelSize.xy * half2(0, 1), uv + _MainTex_TexelSize.xy * half2(1, 1)};

                half texColor;
                half edgeX = 0;
                half edgeY = 0;
                [unroll]
                for(int i = 0; i < 9; i++){
                    texColor = luminance(tex2D(_MainTex, tex[i]).rgb);
                    edgeX += texColor * Gx[i];
                    edgeY += texColor * Gy[i];
                }

                half edge = 1 - abs(edgeX) - abs(edgeY);

                return edge;
            }



            //bilateral fliter function
            fixed3 BilateralFliter(half2 uv){
                half2 tex5[25] = {uv + _MainTex_TexelSize.xy * half2(-2, 2), uv + _MainTex_TexelSize.xy * half2(-1, 2), uv + _MainTex_TexelSize.xy * half2(0, 2), uv + _MainTex_TexelSize.xy * half2(1, 2), uv + _MainTex_TexelSize.xy * half2(2, 2), 
                                uv + _MainTex_TexelSize.xy * half2(-2, 1), uv + _MainTex_TexelSize.xy * half2(-1, 1), uv + _MainTex_TexelSize.xy * half2(0, 1), uv + _MainTex_TexelSize.xy * half2(1, 1), uv + _MainTex_TexelSize.xy * half2(2, 1), 
                                uv + _MainTex_TexelSize.xy * half2(-2, 0), uv + _MainTex_TexelSize.xy * half2(-1, 0), uv + _MainTex_TexelSize.xy * half2(0, 0), uv + _MainTex_TexelSize.xy * half2(1, 0), uv + _MainTex_TexelSize.xy * half2(2, 0), 
                                uv + _MainTex_TexelSize.xy * half2(-2, -1), uv + _MainTex_TexelSize.xy * half2(-1, -1), uv + _MainTex_TexelSize.xy * half2(0, -1), uv + _MainTex_TexelSize.xy * half2(1, -1), uv + _MainTex_TexelSize.xy * half2(2, -1), 
                                uv + _MainTex_TexelSize.xy * half2(-2, -2), uv + _MainTex_TexelSize.xy * half2(-1, -2), uv + _MainTex_TexelSize.xy * half2(0, -2), uv + _MainTex_TexelSize.xy * half2(1, -2), uv + _MainTex_TexelSize.xy * half2(2, -2)};
                

                half2 tex9[9] = {uv + _MainTex_TexelSize.xy * half2(-1, 1), uv + _MainTex_TexelSize.xy * half2(0, 1), uv + _MainTex_TexelSize.xy * half2(1, 1), 
                                uv + _MainTex_TexelSize.xy * half2(-1, 0), uv, uv + _MainTex_TexelSize.xy * half2(1, 0),
                                uv + _MainTex_TexelSize.xy * half2(-1, -1), uv + _MainTex_TexelSize.xy * half2(0, -1), uv + _MainTex_TexelSize.xy * half2(1, -1)};


                /*
                half weight[25] = {0.0030, 0.0133, 0.0219, 0.0133, 0.0030,
                                   0.0133, 0.0596, 0.0983, 0.0596, 0.0133,
                                   0.0219, 0.0983, 0.1621, 0.0983, 0.0219, 
                                   0.0133, 0.0596, 0.0983, 0.0596, 0.0133,
                                   0.0030, 0.0133, 0.0219, 0.0133, 0.0030};
                */


                //fixed3 centerLum = lumiance(tex2D(_MainTex, tex5[12]).rgb);
                fixed3 centerLum = lumiance(tex2D(_MainTex, tex9[4]).rgb);
                fixed3 res = (0, 0, 0);
                
                

                /*
                [unroll]
                for(int i = 0; i < 25; i++){
                    //res += tex2D(_MainTex, tex5[i]).rgb * weight[i] * normalize(Sobel(tex5[i]));
                    
                    fixed3 temp_color = tex2D(_MainTex, tex5[i]).rgb;
                    //fixed final_weight = weight[i] * (1 - abs(centerLum - lumiance(temp_color)));
                    fixed final_weight = exp(-0.5 * sqrt(abs((tex5[i].x - uv.x) + (tex5[i].y - uv.y)) / 1)) * exp(-0.5 * sqrt(1 - abs(centerLum - lumiance(temp_color)) / 0.05));
                    res += temp_color * final_weight;
                    
                }
                */

                [unroll]
                for(int i = 0; i < 9; i++){
                    fixed3 temp_color = tex2D(_MainTex, tex9[i]).rgb;
                    half distance = sqrt(pow(tex9[i].x - uv.x, 2) + pow(tex9[i].y - uv.y, 2));
                    fixed final_weight = exp(-0.5 * pow(abs(distance) / 0.01, 2)) * exp(-0.5 * sqrt(1 - abs(centerLum - lumiance(temp_color)) / _Para));
                    //fixed final_weight = weight[i] * (1 - abs(centerLum - lumiance(temp_color)));
                    res += temp_color * final_weight;
                }

                return res;
            }



            // this method is used to do the Expansion operation
            fixed3 edgeExtension(fixed3 cur_col, half2 uv){
                fixed3 res = cur_col;
                half2 tex8[8] = {uv + _MainTex_TexelSize.xy * half2(-1, 1), uv + _MainTex_TexelSize.xy * half2(0, 1), uv + _MainTex_TexelSize.xy * half2(1, 1), 
                                uv + _MainTex_TexelSize.xy * half2(-1, 0), uv + _MainTex_TexelSize.xy * half2(1, 0),
                                uv + _MainTex_TexelSize.xy * half2(-1, -1), uv + _MainTex_TexelSize.xy * half2(0, -1), uv + _MainTex_TexelSize.xy * half2(1, -1)};

                [unroll]
                for(int i = 0; i < 8; i++){
                    fixed3 temp = BilateralFliter(tex8[i]);
                    fixed index = step(lumiance(res), lumiance(temp));
                    res = lerp(temp, res, index);
                }

                return res;
            }


            // this method is used to fill color
            fixed4 ColorProcess(fixed4 color1, fixed4 color2){
                fixed3 temp_color1 = color1.rgb;
                fixed3 temp_color2 = color2.rgb;

                fixed selectNum = step(lumiance(temp_color1), lumiance(temp_color2));     // if color1 > color2: return 0 else return 1
                fixed3 res_color = lerp(temp_color2, temp_color1, selectNum);   // if color1 > color2: return color2 else: return color1

                return fixed4(res_color, 1);
            }


            v2f vert(appdata_img v){
                v2f f;
                f.pos = UnityObjectToClipPos(v.vertex);
                f.uv = v.texcoord;
                return f;
            }


            fixed4 frag(v2f f) : SV_Target{
                
                //fixed3 midColor = medianFilter(f.uv);
                fixed3 color = tex2D(_MainTex, f.uv).rgb;
                fixed3 temp_color = BilateralFliter(f.uv);
                fixed3 cal_color = QuantizeColors(GaussianFliter(f.uv) * medianFilter(f.uv));


                half edge = Sobel(f.uv);

                fixed4 edgeColor = fixed4(0, 0, 0, 1);
                fixed4 backgroundColor = fixed4(temp_color, 1);

                fixed4 onlyEdgeColor = lerp(edgeColor, backgroundColor, edge);



                temp_color = edgeExtension(temp_color, f.uv);

                return ColorProcess(fixed4(temp_color, 1), fixed4(cal_color, 1));

                //return fixed4(temp_color, 1);

                //return onlyEdgeColor;

                /*
                fixed alpha = onlyEdgeColor.a;
                fixed3 finalColor = ColorCalculation(onlyEdgeColor.rgb);

                return fixed4(finalColor.rgb, alpha);
                */
            }
            //#pragma enable_d3d11_debug_symbols







            ENDCG
        }

        
    }
    FallBack Off
}
