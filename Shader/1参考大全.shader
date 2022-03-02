Shader "Shader参考大全"//名称目录，对应着面板上的选择目录，Shader.Find方法搜索需要输入这里""中的全路径
{
    //属性，最终显示在材质面板上可调节的参数
    Properties
    {
        //属性按常用顺序排列
        //[Space] 前缀会在前面添加一个竖直间隔空行，[Space(30)]可自定义空格距离
        //[Header(This is a Texture)] 前缀添加一个头描述，不支持中文
        [Header(This is a Texture)]_MainTex ("Base (RGB)", 2D) = "white" {}    //创建一个纹理，允许拖拽一个纹理到这个shader上。缺省值既可以是一个空字符串也可以是某个内置的缺省纹理："white", "black", "gray" or "bump"
        _Range("Range Test",Range(0, 10)) = 1   //创建一个float类型的滚动条，范围在Range(min,max) 
        //[IntRange] 指定范围的整数滑块
        //[PowerSlider(3.0)] 显示一个带范围着色器属性的非线性响应的滑块
        _Color("Color Test",Color) = (1,1,1,1) //四个值分别代表rgba（红绿蓝和alpha值（透明度））  
        [Toggle]_Float("Float Test?",Float) = 1.3 //定义一个float变量
        //[Toggle] 前缀可以使属性栏为布尔值可选项，限定到0和1范围内,当它打开时，将设置具有大写属性名称“_ON”的着色器关键字，或者明确指定的着色器关键字[ Toggle（ENABLE_FANCY）] 
        //[KeywordEnum(A,B,C,D,E,F,G,H,J)] 前缀可以添加一个自定义可选项，最多可以指定9个名称/值对
        //[Enum(MyShaderTest)] 前缀可添加一个自定义枚举可选项  public enum MyShaderTest{shader1,shader2,shader3} 最多可以指定7个名称/值对
        _Vector("Vector Test",Vector) = (1,1,1,1) //定义四个向量组成的属性 
        _Rect("Rect Test",Rect) = "white"{} //定义长方形（非2次方）纹理属性  
        _Cube("Cube Test",Cube) = "white"{} //定义立方贴图纹理属性  
        _3DTex ("3DTex", 3D) = "white" {}
        //      [HideInInspector] 在材料检查员中不显示属性值。
        //        [NoScaleOffset] 材质检查器不会显示纹理属性的纹理贴图/偏移字段。
        //        [Normal] 表示纹理属性需要一个法线贴图。
        //        [HDR] 表示纹理属性需要高动态范围（HDR）纹理。
        //        [Gamma] 表示在UI中将float / vector属性指定为sRGB值（就像颜色一样），并且可能需要根据使用的颜色空间进行转换。请参阅着色器程序中的属性。
        //        [PerRendererData] 表示纹理属性将来自以每个渲染器数据的MaterialPropertyBlock的形式。材质检查器会更改这些属性的纹理插槽UI。
    }

    //一个Shader可以有多个SubShader
    //SubShader会按顺序执行，直到执行到能运行的SubShader
    //至少有一个SubShader
    SubShader
    {
        //Tags主要是对一些Unity提供的描述进行赋值，从而实现设定材质的渲染顺序、灯光设置等效果
        //对本SubShader所有Pass生效
        //这篇总结各种Tag的设置比较好：https://blog.csdn.net/qq_17347313/article/details/106173791
        Tags//以下标签,必须位于SubShader部分内，而不在Pass中
        {
            "Queue"="Geometry"
            //          Background：值为1000。比如用于天空盒。 
            //            Geometry：值为2000。大部分物体在这个队列。不透明的物体也在这里。其他队列的物体都是按空间位置的从远到近进行渲染。 
            //            AlphaTest：值为2450。已进行AlphaTest的物体在这个队列。 
            //            Transparent：值为3000。透明物体。这个渲染队列在Geometry之后渲染，并且AlphaTest按照前后顺序呈现。任何alpha混合（即不写入深度缓冲区的着色器）应该在这里（玻璃，粒子效应）
            //            Overlay：值为4000。这个渲染队列是为了覆盖效果,比如镜头光晕。 
            //            用户可以定义任意值，比如”Queue”=”Geometry+10” 2500以下为不透明对象，以上为透明对象
            "RenderType"="Opaque" //Unity可以运行时替换符合特定RenderType的所有Shader
            //          Opaque：绝大部分不透明的物体都使用这个
            //          Transparent：绝大部分透明的物体、包括粒子特效都使用这个
            //            TransparentCutout：透明镂空
            //          Background：天空盒都使用这个
            //          Overlay：GUI、镜头光晕都使用这个
            "IgnoreProjector"="False"//值为“True”，则使用该着色器的对象不会受到投影机的影响。这对半透明对象来说最为有用，因为投影机没有好的方法来影响它们
            "DisableBatching"="False"//当启用禁止批处理的时候，顶点变形将不被处理，因为批处理将所有几何体转换为世界空间
            //            True：总是禁用此着色器的批处理
            //            False：不禁用批处理;这是默认值
            //            LODFading：当LOD衰落处于活动状态时禁用批处理;主要用于树）
            "ForceNoShadowCasting"="False"//值为“True”，表示不接受阴影，则使用此子级别渲染的对象将永远不会投射阴影。当您在透明对象上使用着色器替换，并且不会继承其他子元素的阴影传递时，这一点非常有用
            "CanUseSpriteAtlas"="True"//如果着色器用于精灵，请将标签设置为“False”，并将它们打包到地图集中时不起作用
            "PreviewType"="Plane"//指示材料检查员预览应如何显示材料。默认情况下，材质显示为球体，但PreviewType也可以设置为“Plane”（将显示为2D）或“Skybox”（将显示为skybox）
        }

        //LOD设置
        LOD 200

        //一个SubShader（渲染方案）是由一个个Pass块来执行的
        //为了达到特殊的渲染目的，可能某个物体要多遍渲染.这是就要多个pass
        //具体一点比如卡通勾边，第一个pass渲染边框，第二个pass上不渐变的颜色
        //每个Pass都会消耗对应的一个DrawCall。在满足渲染效果的情况下尽可能地减少Pass的数量
        Pass
        {
            //仅对本Pass生效，不常用，此处通常省略
            Tags{//标签基本上是键值对。内部通行标签用于控制照明管道（环境，顶点照明，像素点亮等）中的此角色以及其他一些选项
                "LightMode"="ForwardBase"//标签在照明管道中定义了Pass'角色
                //                Always：永远都渲染，但不处理光照
                //                ForwardBase：用于前向渲染，环境，主要定向光，顶点/ SH灯和光照贴图
                //                ForwardAdd：用于转发渲染 ; 添加每像素光，每光一次
                //                Deferred：延期遮蔽 ; 呈现g缓冲区
                //                ShadowCaster：将对象深度渲染到阴影贴图或深度纹理中
                //                MotionVectors：用于计算每个对象的运动矢量
                //                PrepassBase：用于传统延迟照明，渲染法线和镜面指数
                //                PrepassFinal：用于传统延迟照明，通过组合纹理，照明和发射渲染最终颜色
                //                Vertex：当对象不被光照时，用于遗留的顶点点亮渲染; 所有顶点灯都被应用
                //                VertexLMRGBM：在对象被光照时用于旧版顶点渲染渲染; 在光标为RGBM编码的平台上（PC＆控制台）
                //                VertexLM：当对象被光照时用于旧版顶点渲染渲染; 在平台上，lightmap是双LDR编码（移动平台）
                "PassFlags"=""//通过可以指示改变渲染管道如何将数据传递给它的标志。这是通过使用PassFlags标记，具有空格分隔的标志名称的值来完成的。唯一支持：当用于ForwardBase pass类型时，该标志使它只能将主要定向光和环境/光源数据传递到着色器中。这意味着非重要光源的数据不会传递到顶点光或球面谐波着色器变量中
                "RequireOptions"="SoftVegetation"//这是通过使用RequireOptions标签完成的，其值是一个空格分隔的选项的字符串。目前Unity支持的选项有：SoftVegetation：仅在质量设置中打开软植被时才渲染此通行证
            }

            //其他的描述
            Cull Back//控制多边形的哪一边应该被淘汰（未绘制）
            //            Back 不要将多边形面向远离查看器（默认）
            //            Front 不要将多边形面向观察者。用于将物体转入内部
            //            Off 禁用剔除 - 绘制所有面。用于特效
            ZWrite On//控制来自该对象的像素是否被写入深度缓冲区（默认为On）。如果您画的是固体物体，请将其保留。如果您正在绘制半透明效果，请切换到ZWrite Off
            ZTEST LEqual//Less | Greater | LEqual | GEqual | Equal | NotEqual | Always 深度测试应如何进行 默认值为LEqual（将对象从或距离绘制为现有对象;在其后隐藏对象）
            Offset 0,0//允许您使用两个参数指定深度偏移。因素和单位。相对于多边形的X或Y，因子可以计算最大Z斜率，单位缩放最小可分辨深度缓冲区值。这允许您强制一个多边形绘制在另一个顶部，尽管它们实际上处于相同的位置。例如Offset 0，-1将多边形靠近相机，忽略多边形的斜率，而偏移-1，-1则会在观察掠角时将多边形拉近
            Blend Off
            //            Blend Off：关闭混合（这是默认值）
            //            Blend SrcFactor DstFactor：配置并启用混合。生成的颜色乘以SrcFactor。已经在屏幕上的颜色乘以DstFactor，并将两者加在一起。
            //            Blend SrcFactor DstFactor, SrcFactorA DstFactorA：与上述相同，但使用不同的因素来混合Alpha通道。
            //            BlendOp Op：不是一起添加混合颜色，而是对它们执行不同的操作。
            //            BlendOp OpColor, OpAlpha：与上述相同，但对颜色（RGB）和Alpha（A）通道使用不同的混合操作。
            //            常用：
            //            Blend SrcAlpha OneMinusSrcAlpha // Traditional transparency
            //            Blend One OneMinusSrcAlpha // Premultiplied transparency
            //            Blend One One // Additive
            //            Blend OneMinusDstColor One // Soft Additive
            //            Blend DstColor Zero // Multiplicative
            //            Blend DstColor SrcColor // 2x Multiplicative
            /*Color (0,0,1,1)//将对象设置为纯色。颜色是括号中的四个RGBA值，或方括号中的颜色属性名称*/
            /*Material {Material Block}//材质块用于定义对象的材质属性
            Material {
                Diffuse [_Color]
                Ambient [_Color]
            }
            */
            /*Lighting On//On | Off对于“材质”块中定义的设置有任何影响，必须使用“ 亮起”命令启用“ 照明”。如果指示灯熄灭，颜色将直接从Color命令中取出*/
            /*SeparateSpecular On//On | Off该命令使镜面光照添加到着色器通过的末尾，因此镜面照明不受纹理化的影响。仅在使用照明灯时才起作用*/
            /*ColorMaterial AmbientAndDiffuse //AmbientAndDiffuse | Emission使用每顶点颜色，而不是材质中设置的颜色。AmbientAndDiffuse替代了材料的环境和漫反射值; 排放取代材料的排放值*/
            AlphaTest Off//渲染所有的像素（默认）或...AlphaTest Greater 0.5
            //            Greater    只渲染其Alpha值大于AlphaValue的像素。
            //            GEqual    只渲染其Alpha值大于或等于AlphaValue的像素。
            //            Less    只渲染其Alpha值小于AlphaValue的像素。
            //            LEqual    仅渲染Alpha值小于或等于AlphaValue的像素。
            //            Equal    只渲染其Alpha值等于AlphaValue的像素。
            //            NotEqual    仅渲染Alpha值与AlphaValue不同的像素。
            //            Always    渲染所有像素。这在功能上等同于AlphaTest Off。
            //            Never    不要渲染任何像素。
            /*Fog {Fog Commands}//在大括号内指定如下指令
            Mode Off//Off | Global | Linear | Exp | Exp2定义雾模式。默认为全局，根据“渲染设置”中是否打开雾，转换为“关”或“失效”
            Color ColorValue//设置雾色
            Density FloatValue//设定指数雾的密度
            Range FloatValue, FloatValue//设置线性雾的近和远的范围
            */
            /*BindChannels { Bind "source", target }//指定顶点数据源映射到硬件目标
            //            source来源可以是以下之一：
            //            Vertex：顶点位置
            //            Normal：顶点法线
            //            Tangent：顶点切线
            //            Texcoord：主UV坐标
            //            Texcoord1：辅助UV坐标
            //            Color：每顶点颜色
            //
            //            target目标可以是以下之一：
            //            Vertex：顶点位置
            //            Normal：顶点法线
            //            Tangent：顶点切线
            //            Texcoord0，Texcoord1，...：相应纹理阶段的纹理坐标
            //            Texcoord：所有纹理阶段的纹理坐标
            //            Color：顶点颜色
            BindChannels {
                Bind "Vertex", vertex
                Bind "texcoord", texcoord
                Bind "Color", color
            }
            */

            //此处标记开始CG语法，Unity也支持HLSL语法
            CGPROGRAM
            //下面两行是Unity2019自己生成的，删了他还会重新生成，目测是为了修复DX11的啥问题
            // Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct v2f members pos)
            #pragma exclude_renderers d3d11

            //这里定义了vertex顶点着色器的函数名为vert，fragment片元着色器的函数名为frag
            #pragma vertex vert
            #pragma fragment frag

            //引入库文件
            //还有很多其他的比如灯光库啥的，用到的时候在查吧
            #include "UnityCG.cginc"

            //公共变量（属性需要生成对应名字的变量才可以被读取）
            //这3种基本数值类型可以再组成vector和matrix，比如half3是由3个half组成、float4x4是由16个float组成，HLSL/CG的访问接口MyMatrix[3]返回的是第3行
            float _float;//32位高精度浮点数
            half _half;//16位中精度浮点数。范围是[-6万, +6万]，能精确到十进制的小数点后3.3位，尽量使用half
            fixed _fixed;//11位低精度浮点数。范围是[-2, 2]，精度是1/256，颜色和单位向量，使用fixed
            int _int;//32 位整形数据
            bool _bool;//布尔数据
            string _string;//字符串类型，几乎不用
            sampler2D _MainTex;//图片类型，还有sampler, sampler1D, sampler2D, sampler3D, samplerCUBE, 和 samplerRECT
            /*
            float1x1 matrix1;//等价于 float matirx1; x 是字符，并不是乘号！  
            float2x3 matrix2;// 表示 2*3 阶矩阵，包含 6 个 float 类型数据  
            float4x2 matrix3;// 表示 4*2 阶矩阵，包含 8 个 float 类型数据  
            float4x4 matrix4;//表示 4*4 阶矩阵，这是最大的维数 
            */

            //定义了a2v输出结构体，a表示application就是app即程序，2就是To的缩写，v就是vertex函数，业内通常使用这种写法
            //即定义从Unity的Renderer（包括MeshRenderer和SkinnedMeshRenderer）组键发送过来哪些数据
            //根据shader需要去取数据，因此内容是受到限制的
            /*
            #include "UnityCG.cginc"中自带的结构体有如下4种
            appdata_img：POSITION和一个TEXCOORD0。
            appdata_base：POSITION，NORMAL和一个TEXCOORD0。
            appdata_tan：POSITION，TANGENT，NORMAL和一个TEXCOORD0。
            appdata_full：POSITION，TANGENT，NORMAL，四个TEXCOORD0和COLOR
            appdata_full全部内容如下：
            struct appdata_full {
                float4 vertex : POSITION;//顶点坐标
                float4 tangent : TANGENT;//切线方向
                float3 normal : NORMAL;//法线方向
                float4 texcoord : TEXCOORD0;//该顶点的纹理坐标，第一组纹理坐标uv 也就是第一张贴图的坐标、为了实现多重纹理贴图，比如子弹打在墙上的弹痕等
                float4 texcoord1 : TEXCOORD1;//第二套UV坐标其实都不常用，通常为了节省CPU资源做一些模型相关的特殊效果的时候才会使用第二套UV坐标
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                fixed4 color : COLOR;//顶点颜色
            };
            常用输入语义总结：
            COLOR 漫反射和镜面颜色 float4
            NORMAL 法线向量 float4
            POSITION 对象空间中的顶点位置 float4
            TANGENT 切线 float4
            TEXCOORD 纹理坐标 float4
            POSITIONT 变形顶点位置 float4
            PSIZE 点大小 float
            */
            struct a2v{
                //用POSITION告诉Uinty用模型空间顶点坐标来填充vertex变量
                float4 vertex:POSITION;
                //用NORMAL语义告诉Unity用模型空间的法线方向来填充normal变量
                float3 normal:NORMAL;
                //用模型第一套纹理坐标（UV坐标）来填充texcoord
                float4 texcoord:TEXCOORD0;
            };

            //定义了v2f输出结构体，v2f即vertex to fragment
            //主要是用于将顶点着色器的数据传输给片元着色器使用
            /*
            常用输出语义总结：
            COLOR 漫反射和镜面颜色 float4
            FOG 顶点雾 float
            POSITION 顶点在同质空间中的位置。通过将（x，y，z）除以w来计算屏幕空间中的位置。每个顶点着色器必须用这个语义写出一个参数 float4
            PSIZE 点大小 float
            TESSFACTOR 细分因子 float
            TEXCOORD 纹理坐标 float4
            */
            struct v2f{
                //SV_POSITION语义告诉Unity，pos里包含了顶点在裁剪空间中的位置信息
                float4 pos:SV_POSITION;
                //COLOR0语义可以用于存储颜色信息
                fixed3 color:COLOR0;
            };

            //顶点shader函数
            v2f vert(a2v v)
            {
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);
                return o;
            }

            //片元shader函数
            fixed4 frag(v2f i):SV_TARGET
            {
                return fixed4(1.0,1.0,1.0,1.0);
            }

            //表示结束CG语言
            ENDCG
        }
    }
    
    //当本Shader的所有SubShader都不支持当前显卡，就会使用FallBack语句指定的另一个Shader。FallBack最好指定Unity自己预制的Shader实现，因其一般能够在当前所有显卡运行
    Fallback "Diffuse"
}