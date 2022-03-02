
using UnityEngine;
using System.Collections;
 
/// <summary>
/// 获取模型的所有顶点坐标
/// </summary>
[ExecuteAlways]
public class GetVertex : MonoBehaviour 
{
	public Material mat;
	void OnValidate()
	{
		// 读取mesh网格
		Mesh mesh = GetComponent<MeshFilter>().mesh;	
		Vector3[] vertices = mesh.vertices;
		Debug.Log(vertices.Length);


		// 找到距离相差最大的两个位置，进行缩放操作
		float minx =vertices[0].x;
		float miny =vertices[0].y;
		float minz =vertices[0].z;
		float maxx =vertices[0].x;
		float maxy =vertices[0].y;
		float maxz =vertices[0].z;

		foreach(Vector3 vertex in vertices)
		{
			minx = Mathf.Min(minx,vertex.x);
			miny = Mathf.Min(miny,vertex.y);
			minz = Mathf.Min(minz,vertex.z);
			maxx = Mathf.Max(maxx,vertex.x);
			maxy = Mathf.Max(maxy,vertex.y);
			maxz = Mathf.Max(maxz,vertex.z);				
		}
		Debug.Log("Before");
		Debug.Log("min:"+minx+" "+miny+" "+minz);
		Debug.Log("max:"+maxx+" "+maxy+" "+maxz);

		// 计算缩放系数
		float scale = Mathf.Max((maxx-minx),(maxy-miny),(maxz-minz));

		// 将缩放系数传递至Shader
		mat.SetFloat("_Scale",1/scale);

		// 设置缩放矩阵
        Matrix4x4 m1 = Matrix4x4.identity;
        m1.SetTRS(new Vector3(0,0,0), Quaternion.Euler(Vector3.up * 0), Vector3.one *(1/scale) );

		// 对顶点进行缩放操作		
		for(int i=0;i<vertices.Length;i++)
		{
			vertices[i] = m1.MultiplyPoint3x4(vertices[i]);
		}

		// 找到三个坐标轴上离原点最远的位置，进行平移操作
		minx =vertices[0].x;
		miny =vertices[0].y;
		minz =vertices[0].z;
		maxx =vertices[0].x;
		maxy =vertices[0].y;
		maxz =vertices[0].z;

		foreach(Vector3 vertex in vertices)
		{
			minx = Mathf.Min(minx,vertex.x);
			miny = Mathf.Min(miny,vertex.y);
			minz = Mathf.Min(minz,vertex.z);
			maxx = Mathf.Max(maxx,vertex.x);
			maxy = Mathf.Max(maxy,vertex.y);
			maxz = Mathf.Max(maxz,vertex.z);				
		}
		
		// 设置平移矩阵
		m1.SetTRS(new Vector3(-minx,-miny,-minz), Quaternion.Euler(Vector3.up * 0), Vector3.one);

		// 将平移参数传递至Shader
		mat.SetFloat("_tx",-minx);
		mat.SetFloat("_ty",-miny);
		mat.SetFloat("_tz",-minz);



		// 以下为Debug用，可删除

		// 对每个点进行平移操作
		for(int i=0;i<vertices.Length;i++)
		{
			vertices[i] = m1.MultiplyPoint3x4(vertices[i]);
		}

		// 找到平移后的最大最小位置
		minx =vertices[0].x;
		miny =vertices[0].y;
		minz =vertices[0].z;
		maxx =vertices[0].x;
		maxy =vertices[0].y;
		maxz =vertices[0].z;

		foreach(Vector3 vertex in vertices)
		{
			minx = Mathf.Min(minx,vertex.x);
			miny = Mathf.Min(miny,vertex.y);
			minz = Mathf.Min(minz,vertex.z);
			maxx = Mathf.Max(maxx,vertex.x);
			maxy = Mathf.Max(maxy,vertex.y);
			maxz = Mathf.Max(maxz,vertex.z);				
		}		
		Debug.Log("After");
		Debug.Log("min:"+minx+" "+miny+" "+minz);
		Debug.Log("max:"+maxx+" "+maxy+" "+maxz);
	}
 
}
