extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

















#Unity Pathfinding and grid generation script gl translating
#using System.Collections;
#using System.Collections.Generic;
#using System.Linq;
#using TMPro;
#using Unity.VisualScripting;
#using UnityEditor.Build.Reporting;
#using UnityEngine;
#
#
#public class GridBehaviour : MonoBehaviour
#{
#    public bool findDistance = false;
#    public bool setDistance = false;
#    public int rows = 10;
#    public int columns = 10;
#    public int scale = 1;
#    public GameObject gridPrefab;
#    public Vector3 leftBottomLocation = new Vector3(0.5f,0.05f,0.5f);
#    public GameObject[,] gridArray;
#    public int startX = 0;
#    public int startY = 0;
#    public int endX = 1;
#    public int endY = 1;
#    public List<GameObject> path;
#    private LineRenderer lineRenderer;
#    private bool isSet = false;
#
#    public List<GameObject> getPath() { return path; } 
#    private void Awake()
#    {
#        gridArray = new GameObject[columns,rows];
#        if (gridPrefab)
#            GenerateGrid();
#
#        else print("missing gridprefab");
#        lineRenderer = GetComponent<LineRenderer>();
#
#    }
#
#    // Update is called once per frame
#    void Update()
#    {
#        SetEndPoint();
#        if (isSet)
#        {
#            SetDistance();
#            SetPath();
#            DrawPath();
#        }
#
#    }
#
#    void SetEndPoint()
#    {
#        foreach(GameObject obj in gridArray)
#        {
#            if (obj.GetComponent<OnHoverAppear>().visible)
#            {
#                endX= obj.GetComponent<GridStat>().x;
#                endY= obj.GetComponent<GridStat>().y;
#                isSet=true;
#            }
#
#        }
#
#    }
#
#    void GenerateGrid()
#    {
#        for(int i=0; i<columns; i++)
#        {
#            for(int j=0; j<rows; j++) 
#            {
#                GameObject obj = Instantiate(gridPrefab,new Vector3(leftBottomLocation.x + scale * i ,leftBottomLocation.y ,leftBottomLocation.z+ scale * j),Quaternion.identity);
#                obj.transform.SetParent(gameObject.transform);
#                obj.GetComponent<GridStat>().x = i;
#                obj.GetComponent<GridStat>().y = j;
#                gridArray[i,j] = obj;
#            }
#        }
#    }
#    void InitialSetup()
#    {
#        foreach(GameObject obj in gridArray)
#        {
#            obj.GetComponent<GridStat>().visited = -1;
#        }
#        gridArray[startX, startY].GetComponent<GridStat>().visited = 0;
#    }
#    bool TestDirection(int x, int y, int step, int direction)
#    {
#        //int direction tells which case to use 1 is N, 2 is NE, 3 is E, 4 is SE, 5 is S, 6 is SW, 7 is W, 8 is NW
#        switch (direction) // Checked
#        {
#            case 1: // North 
#                if (y + 1 < rows && gridArray[x, y + 1] && gridArray[x, y + 1].GetComponent<GridStat>().visited == step && !gridArray[x, y + 1].GetComponent<GridStat>().inAx) return true;
#                else return false;
#            case 2: // North East
#                if (y + 1 < rows && x + 1 < columns && gridArray[x + 1, y + 1] && gridArray[x + 1, y + 1].GetComponent<GridStat>().visited == step && !gridArray[x + 1, y + 1].GetComponent<GridStat>().inAx) return true;
#                else return false;
#            case 3: // East
#                if (x + 1 < columns && gridArray[x + 1, y] && gridArray[x + 1, y].GetComponent<GridStat>().visited == step && !gridArray[x + 1, y].GetComponent<GridStat>().inAx) return true;
#                else return false;
#            case 4: // South East
#                if (y - 1 > -1 && x + 1 < columns && gridArray[x + 1, y - 1] && gridArray[x + 1, y - 1].GetComponent<GridStat>().visited == step && !gridArray[x + 1, y - 1].GetComponent<GridStat>().inAx) return true;
#                else return false;
#            case 5: // South
#                if (y - 1 > -1 && gridArray[x, y - 1] && gridArray[x, y - 1].GetComponent<GridStat>().visited == step && !gridArray[x, y - 1].GetComponent<GridStat>().inAx) return true;
#                else return false;
#            case 6: // South West
#                if (y - 1 > -1 && x - 1 > -1 && gridArray[x - 1, y - 1] && gridArray[x - 1, y - 1].GetComponent<GridStat>().visited == step && !gridArray[x - 1, y - 1].GetComponent<GridStat>().inAx) return true;
#                else return false;
#            case 7: // West
#                if (x - 1 > -1 && gridArray[x - 1, y] && gridArray[x - 1, y].GetComponent<GridStat>().visited == step && !gridArray[x - 1, y].GetComponent<GridStat>().inAx) return true;
#                else return false;
#            case 8: // North West
#                if (y + 1 < rows && x - 1 > -1 && gridArray[x - 1, y + 1] && gridArray[x - 1, y + 1].GetComponent<GridStat>().visited == step && !gridArray[x - 1, y + 1].GetComponent<GridStat>().inAx) return true;
#                else return false;
#            default:
#                return false;
#        }
#    }
#
#    void SetDistance()
#    {
#        InitialSetup();
#        int x = startX;
#        int y = startY;
#        int[] testArray = new int[rows * columns];
#        for(int step = 1; step < rows *columns; step++)
#        {
#            foreach(GameObject obj in gridArray)
#            {
#                if(obj && !obj.GetComponent<GridStat>().inAx && obj.GetComponent<GridStat>().visited == step - 1)
#                {
#                    TestAllDirections(obj.GetComponent<GridStat>().x, obj.GetComponent<GridStat>().y, step); 
#                }
#            }
#        }
#    }
#
#    void SetPath()
#    {
#        int step;
#        int x = endX;
#        int y = endY;
#        List<GameObject> tempList = new List<GameObject>();
#        path.Clear();
#        if (gridArray[endX, endY] && !gridArray[endX, endY].GetComponent<GridStat>().inAx && gridArray[endX,endY].GetComponent<GridStat>().visited > 0)
#        {
#            path.Add(gridArray[x, y]);
#            step = gridArray[x,y].GetComponent<GridStat>().visited - 1;
#        }
#        else
#        {
#            return;
#        }
#        for(int i = step; step > -1; step--)
#        {
#            if (TestDirection(x, y, step, 1)) // N
#                tempList.Add(gridArray[x, y + 1]);
#
#            if (TestDirection(x, y, step, 2)) // NE
#                tempList.Add(gridArray[x + 1, y + 1]);
#
#            if (TestDirection(x, y, step, 3)) // E
#                tempList.Add(gridArray[x + 1, y]);
#
#            if (TestDirection(x, y, step, 4)) // SE
#                tempList.Add(gridArray[x + 1, y - 1]);
#
#            if (TestDirection(x, y, step, 5)) // S
#                tempList.Add(gridArray[x, y - 1]);
#
#            if (TestDirection(x, y, step, 6)) // SW
#                tempList.Add(gridArray[x - 1, y - 1]);
#
#            if (TestDirection(x, y, step, 7)) // W
#                tempList.Add(gridArray[x - 1, y]);
#
#            if (TestDirection(x, y, step, 8)) // NW
#                tempList.Add(gridArray[x - 1, y + 1]);
#            GameObject tempObj = FindClosest(gridArray[endX, endY].transform, tempList);
#            path.Add(tempObj);
#            x = tempObj.GetComponent<GridStat>().x;
#            y = tempObj.GetComponent<GridStat>().y;
#            tempList.Clear();
#        }
#    }
#
#    void TestAllDirections(int x, int y, int step)
#    {
#        if (TestDirection(x, y, -1, 1)) // N
#            SetVisited(x, y + 1, step);
#
#        if (TestDirection(x, y, -1, 2)) // NE
#            SetVisited(x + 1, y + 1, step);
#
#        if (TestDirection(x, y, -1, 3)) // E
#            SetVisited(x + 1, y, step);
#
#        if (TestDirection(x, y, -1, 4)) // SE
#            SetVisited(x + 1, y - 1, step);
#
#        if (TestDirection(x, y, -1, 5)) // S
#            SetVisited(x, y - 1, step);
#
#        if (TestDirection(x , y, -1, 6)) // SW
#            SetVisited(x - 1, y - 1, step);
#
#        if (TestDirection(x, y, -1, 7)) // W
#            SetVisited(x - 1, y, step);
#
#        if (TestDirection(x, y, -1, 8)) // NW
#            SetVisited(x - 1, y + 1, step);
#
#    }
#
#    void SetVisited (int x, int y, int step)
#    {
#        if (gridArray[x, y])
#        {
#            gridArray[x, y].GetComponent<GridStat>().visited = step;
#        }   
#    }
#
#    GameObject FindClosest(Transform targetLocation, List<GameObject> list)
#    {
#        float currentDistance = scale * rows * columns;
#        int indexNumber = 0;
#        for(int i =0; i < list.Count; i++)
#        {
#            float distance = Vector3.Distance(targetLocation.position, list[i].transform.position);
#            if (distance < currentDistance)
#            {
#                currentDistance = distance;
#                indexNumber = i;
#            }
#
#        }
#        return list[indexNumber];
#    }
#    void DrawPath()
#    {
#        if (!path.IsUnityNull())
#        {
#            int curX;
#            int curY;
#            int step = -1;
#            lineRenderer.positionCount = path.Count();
#            foreach (GameObject obj in path)
#            {
#                step++;
#                curX = obj.GetComponent<GridStat>().x;
#                curY = obj.GetComponent<GridStat>().y;
#
#                lineRenderer.SetPosition(step, new Vector3(curX + 0.5f, 0f,curY + 0.5f));
#            }
#        }
#    }
#
#}
