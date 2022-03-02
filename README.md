# Wing-offset-based-On-Unity

#### 需要用到的文件

**【模型】**

Model / fuselage_wings.prefab

Model / TestModel.fbx

一个是网上找到机翼模型，另一个是我自己用Blender制作的一个有4w多个顶点的长方体，作测试用。

**【shader】**

Shader / test05.shader

**【脚本】**

Shader / GetVertex.cs



其余文件可以忽略

#### 使用方法

1. 在unity中新建一个material，将 test05.shader 拖到该 material 上
2. 点击 GetVertex.cs 脚本，将上面创建的 material 拖到脚本inspector面板底下的 Mat 上
3. 导入模型，直接拖到unity中即可，如果是prefab注意要将其 Read/Write 选项勾上
4. 将上述 GetVertex.cs 和 创建的 material 拖到模型上
5. 点击模型，调节shader面板下的各个属性即可



#### 效果截图

![y轴偏移](https://s3.bmp.ovh/imgs/2022/03/39400e5ec86fe4e6.png)



![yz轴偏移](https://s3.bmp.ovh/imgs/2022/03/d5d62a55da13e0a9.png)

