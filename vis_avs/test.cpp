#include <windows.h>
#include <stdio.h>
#include <time.h>
#include <conio.h>

#include "vis.h"
#pragma comment(lib, "vis_avs.lib")

extern "C" {
	__declspec( dllexport ) winampVisHeader* winampVisGetHeader();
}
//typedef winampVisHeader* (*winampVisGetHeader)();

int main()
{ 
	/*
	HINSTANCE hDll;
	hDll = LoadLibrary("vis_avs.dll");
	if (!hDll) {
		printf("dll not found\n");
		return 0;
	}

	winampVisGetHeader getHeader = (winampVisGetHeader) GetProcAddress(hDll , "winampVisGetHeader");
	*/

	printf("mod->Init(...)\n");
	winampVisHeader *vis = winampVisGetHeader();
	winampVisModule *mod = vis->getModule(0);
	mod->hwndParent = NULL;
	mod->hDllInstance = GetModuleHandle(NULL);
	mod->sRate = 44100;
	mod->nCh = 2;
	mod->spectrumNch = 2;
	mod->waveformNch = 2;

	printf("for ...\n");
	int x, y;
    for (x = 0; x < 2; x++)
    {
		for (y = 0; y < 576; y++)
		{
				mod->spectrumData[x][y] = 0;
				mod->waveformData[x][y] = 0;
		}
    }

	mod->Init(mod);

	printf("loop ...\n");
    // Step 3: The Message Loop
	MSG msg;
	while (kbhit() == 0)
	{
		while (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE))
		{
			if (msg.message == WM_QUIT) return TRUE;
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}

		Sleep(mod->delayMs);
		//mod->Render(mod);
	}

	//FreeLibrary(hDll);
	return 0;
}