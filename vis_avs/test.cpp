#include <windows.h>
#include <stdio.h>
#include <time.h>
#include <conio.h>

#include "vis.h"
#include "vis_avs.h"
#pragma comment(lib, "vis_avs.lib")

#include "draw.h"
#pragma comment(lib, "ddraw.lib")

const char g_szClassName[] = "myWindowClass";

int resize(HWND hwnd)
{
	RECT r;
	GetClientRect(hwnd,&r);
	DDraw_Resize(r.right-r.left,r.bottom-r.top, 0);
	return 0;
}


// Step 4: the Window Procedure
LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    switch(msg)
    {
        case WM_CREATE:
            //
        break;
        case WM_SIZE:
            resize(hwnd);
        break;
        case WM_CLOSE:
            DestroyWindow(hwnd);
        break;
        case WM_DESTROY:
            PostQuitMessage(0);
        break;
		case WM_SYSKEYDOWN:
		case WM_KEYDOWN:
		  if (wParam == VK_SPACE)
			avs_random_preset();
		  else if (wParam==VK_LEFT)
			avs_next_preset();
		  else if (wParam==VK_RIGHT)
			avs_previous_preset();
		  else if (wParam == VK_ESCAPE)
			DestroyWindow(hwnd);
        default:
            return DefWindowProc(hwnd, msg, wParam, lParam);
    }
    return 0;
}

int WINAPI WinMain(      
    HINSTANCE hInstance,
    HINSTANCE hPrevInstance,
    LPSTR lpCmdLine,
    int nCmdShow
)
{ 

	//HINSTANCE hInstance = GetModuleHandle(NULL);
    //int nCmdShow = SW_SHOW;
    WNDCLASSEX wc;
    HWND hwnd;

    //Step 1: Registering the Window Class
    wc.cbSize        = sizeof(WNDCLASSEX);
    wc.style         = CS_DBLCLKS|CS_VREDRAW|CS_HREDRAW;
    wc.lpfnWndProc   = WndProc;
    wc.cbClsExtra    = 0;
    wc.cbWndExtra    = 0;
    wc.hInstance     = hInstance;
    wc.hIcon         = LoadIcon(NULL, IDI_APPLICATION);
    wc.hCursor       = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = (HBRUSH) GetStockObject(WHITE_BRUSH);
    wc.lpszMenuName  = NULL;
    wc.lpszClassName = g_szClassName;
    wc.hIconSm       = LoadIcon(NULL, IDI_APPLICATION);

    if(!RegisterClassEx(&wc))
    {
        MessageBox(NULL, "Window Registration Failed!", "Error!",
            MB_ICONEXCLAMATION | MB_OK);
        return 0;
    }

    // Step 2: Creating the Window
    hwnd = CreateWindowEx(
        WS_EX_CLIENTEDGE,
        g_szClassName,
        "The title of my window",
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT, 640, 480,
        NULL, NULL, hInstance, NULL);

    if(hwnd == NULL)
    {
        MessageBox(NULL, "Window Creation Failed!", "Error!",
            MB_ICONEXCLAMATION | MB_OK);
        return 0;
    }

    ShowWindow(hwnd, nCmdShow);
    UpdateWindow(hwnd);

	winampVisModule mod =
	{
		"Advanced Visualization Studio",
		hwnd,	// hwndParent
		GetModuleHandle(NULL),	// hDllInstance
		44100,		// sRate
		2,		// nCh
		1000/70,		// latencyMS
		1000/70,// delayMS
		2,		// spectrumNch
		2,		// waveformNch
		{ 0, },	// spectrumData
		{ 0, },	// waveformData
		NULL, // config
		NULL, // init
		NULL, // render
		NULL, // quit
		NULL, // userData
	};

	//printf("init...\n");
	DDraw_Init(hwnd);
	resize(hwnd);
	avs_init("");

	//printf("loop ...\n");
    // Step 3: The Message Loop
	int w, h;
	int *fb, *fb2;
	MSG msg;
	bool exitLoop = false;

	while (!exitLoop)
	{
		while (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE))
		{
			if (msg.message == WM_QUIT) exitLoop = true;
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}

		Sleep(mod.delayMs);
		
		DDraw_Enter(&w,&h,&fb,&fb2);
		int s = avs_render(fb, fb2, w, h, 0);
		DDraw_Exit(s);
	}

	avs_quit();
	DDraw_Quit();
	return 0;
}