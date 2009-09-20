/*
  LICENSE
  -------
Copyright 2005 Nullsoft, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer. 

  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution. 

  * Neither the name of Nullsoft nor the names of its contributors may be used to 
    endorse or promote products derived from this software without specific prior written permission. 
 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR 
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND 
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT 
OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/
#include <windows.h>
#include <math.h>
#include <process.h>
#include "r_defs.h"
#include "render.h"
#include "vis.h"
#include "wnd.h"
#include "cfgwnd.h"
#include "resource.h"
#include "bpm.h"
#include "AVS2Unity.h"

#include <string>
#include <vector>
#include <stdio.h>

#ifdef WA3_COMPONENT
#include "wasabicfg.h"
#include "../studio/studio/api.h"
#endif

#include "debug.h"
#include "avs_eelif.h"

extern void GetClientRect_adj(HWND hwnd, RECT *r);

static unsigned char g_logtab[256];

char *verstr=
#ifndef LASER
"Advanced Visualization Studio"
#else
"AVS/Laser"
#endif
" v2.81d"
;

static unsigned int WINAPI RenderThread(LPVOID a);

//HANDLE g_hThread;
//volatile int g_ThreadQuit;

#ifndef WA3_COMPONENT
static CRITICAL_SECTION g_cs;
#endif

static unsigned char g_visdata[2][2][576];
static int g_visdata_pstat;

CRITICAL_SECTION g_render_cs;
static int g_is_beat;
char g_path[1024];

int beat_peak1,beat_peak2, beat_cnt,beat_peak1_peak;

#if 0//syntax highlighting
HINSTANCE hRich;
#endif

std::string g_init_path;

int avs_init(const char* path)
{
	g_init_path = path;

	DWORD id;
  FILETIME ft;
#if 0//syntax highlighting
  if (!hRich) hRich=LoadLibrary("RICHED32.dll");
#endif

	GetSystemTimeAsFileTime(&ft);
	srand(ft.dwLowDateTime|ft.dwHighDateTime^GetCurrentThreadId());


	strncpy(g_path, path, MAX_PATH);

#ifdef LASER
  strcat(g_path,"avs_laser");
#else
  strcat(g_path,"avs");
#endif
  CreateDirectory(g_path,NULL);

#ifndef WA3_COMPONENT
	//InitializeCriticalSection(&g_cs);
#endif
	//InitializeCriticalSection(&g_render_cs);
	//g_ThreadQuit=0;
	g_visdata_pstat=1;

	AVS_EEL_IF_init();

	if (Wnd_Init(path))
	{
		int x;
		for (x = 0; x < 256; x ++)
		{
			double a=log(x*60.0/255.0 + 1.0)/log(60.0);
			int t=(int)(a*255.0);
			if (t<0)t=0;
			if (t>255)t=255;
			g_logtab[x]=(unsigned char )t;
		}
	}

	initBpm();

	Render_Init(path);

	//CfgWnd_Create(this_mod);

	//g_hThread=(HANDLE)_beginthreadex(NULL,0,RenderThread,0,0,(unsigned int *)&id);
  //main_setRenderThreadPriority();

  return 0;
}

std::vector<int> fb;
std::vector<int> fb2;

int avs_render(void* colors, int width, int height, float time)
{
	//TODO: fill these with audio output
	unsigned char spectrumData[2][576];
	unsigned char waveformData[2][576];

	waveformData[1][0] = 0;
	waveformData[0][0] = 0;

	int y;
	for (y = 1; y < 576; y++)
	{
		waveformData[0][y] = waveformData[0][y-1] + (rand()%200 - 100) *.2;
		waveformData[1][y] = waveformData[1][y-1] + (rand()%200 - 100) *.2;
	}

	int pixels = width * height;
	if (fb.size() != pixels)
	{
		fb.resize(pixels);
		fb2.resize(pixels);
		memset(&fb[0], 0, pixels*sizeof(int));
		memset(&fb2[0], 0, pixels*sizeof(int));
	}


#ifndef WA3_COMPONENT
	int x,avs_beat=0,b;
	//if (g_ThreadQuit) return 1;
	//EnterCriticalSection(&g_cs);
	//if (g_ThreadQuit)
	//{
		//LeaveCriticalSection(&g_cs);
		//return 1;
	//}
	if (g_visdata_pstat)
		for (x = 0; x<  576*2; x ++)
			g_visdata[0][0][x]=g_logtab[(unsigned char)spectrumData[0][x]];
	else 
	{
		for (x = 0; x < 576*2; x ++)
		{ 
			int t=g_logtab[(unsigned char)spectrumData[0][x]];
			if (g_visdata[0][0][x] < t)
				g_visdata[0][0][x] = t;
		}
	}
	memcpy(&g_visdata[1][0][0],waveformData,576*2);
	{
    int lt[2]={0,0};
    int x;
    int ch;
    for (ch = 0; ch < 2; ch ++)
    {
      unsigned char *f=(unsigned char*)&waveformData[ch][0];
      for (x = 0; x < 576; x ++)
      {
        int r= *f++^128;
        r-=128;
        if (r<0)r=-r;
        lt[ch]+=r;
      }
    }
    lt[0]=max(lt[0],lt[1]);

    beat_peak1=(beat_peak1*125+beat_peak2*3)/128;

    beat_cnt++;

    if (lt[0] >= (beat_peak1*34)/32 && lt[0] > (576*16)) 
    {
      if (beat_cnt>0)
      {
        beat_cnt=0;
        avs_beat=1;
      }
      beat_peak1=(lt[0]+beat_peak1_peak)/2;
      beat_peak1_peak=lt[0];
    }
    else if (lt[0] > beat_peak2)
    {
      beat_peak2=lt[0];
    } 
    else beat_peak2=(beat_peak2*14)/16;

	}
	b=refineBeat(avs_beat);
	if (b) g_is_beat=1;
	g_visdata_pstat=0;
	//LeaveCriticalSection(&g_cs);
#endif

#ifdef LASER
    g_laser_linelist->ClearLineList();
#endif

	int beat=0;
	int s = 0;

	g_visdata_pstat=1;
	beat=g_is_beat;
	g_is_beat=0;

	char vis_data[2][2][576];
	memcpy(&vis_data[0][0][0],&g_visdata[0][0][0],576*2*2);

	int t=g_render_transition->render(vis_data,beat,s?&fb2[0]:&fb[0],s?&fb[0]:&fb2[0],width,height);
	if (t&1) s^=1;

	unsigned char *src = (unsigned char *) (s?&fb2[0]:&fb[0]);
	float *dst = (float *) colors;

	int i, size = pixels*4;
    for (i = 0; i < size; i += 4)
	{
		dst[i] = ((float) src[i])*0.0039215686274509803f;
		dst[i+1] = ((float) src[i+1])*0.0039215686274509803f;
		dst[i+2] = ((float) src[i+2])*0.0039215686274509803f;
		dst[i+3] = 1;
	}

#ifdef LASER
    s=0;
    memset(fb,0,pixels*sizeof(int));
    LineDrawList(g_laser_linelist,fb,w,h);
#endif
	return 0;
}

void avs_quit()
{
#define DS(x) 
  //MessageBox(this_mod->hwndParent,x,"AVS Debug",MB_OK)
	//if (g_hThread)
	{
    //DS("Waitin for thread to quit\n");
		//g_ThreadQuit=1;
		//if (WaitForSingleObject(g_hThread,10000) != WAIT_OBJECT_0)
		//{
      //DS("Terminated thread (BAD!)\n");
			//MessageBox(NULL,"error waiting for thread to quit","a",MB_TASKMODAL);
      //TerminateThread(g_hThread,0);
		//}

    //DS("Calling cfgwnd_destroy\n");
		//CfgWnd_Destroy();
    DS("Calling render_quit\n");
		Render_Quit(g_init_path.c_str());

    DS("Calling wnd_quit\n");
		Wnd_Quit(g_init_path.c_str());

    //DS("closing thread handle\n");
		//CloseHandle(g_hThread);
		//g_hThread=NULL;

    DS("calling eel quit\n");
    AVS_EEL_IF_quit();

    DS("cleaning up critsections\n");
#ifndef WA3_COMPONENT
		//DeleteCriticalSection(&g_cs);
#endif
		//DeleteCriticalSection(&g_render_cs);    

    DS("smp_cleanupthreads\n");
    C_RenderListClass::smp_cleanupthreads();
	}
#undef DS
#if 0//syntax highlighting
  if (hRich) FreeLibrary(hRich);
  hRich=0;
#endif
}
