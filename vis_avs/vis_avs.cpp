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
#include "draw.h"
#include "r_defs.h"
#include "render.h"
#include "vis.h"
#include "wnd.h"
#include "cfgwnd.h"
#include "resource.h"
#include "bpm.h"
#include "vis_avs.h"

#include <stdio.h>

#ifdef WA3_COMPONENT
#include "wasabicfg.h"
#include "../studio/studio/api.h"
#endif

#include "debug.h"
#include "avs_eelif.h"

extern void GetClientRect_adj(HWND hwnd, RECT *r);

static unsigned char g_logtab[256];
HINSTANCE g_hInstance;

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

int avs_init(struct winampVisModule *this_mod)
{
	DWORD id;
  FILETIME ft;
#if 0//syntax highlighting
  if (!hRich) hRich=LoadLibrary("RICHED32.dll");
#endif
  GetSystemTimeAsFileTime(&ft);
  srand(ft.dwLowDateTime|ft.dwHighDateTime^GetCurrentThreadId());
	g_hInstance=this_mod->hDllInstance;
#ifdef WA3_COMPONENT
	GetModuleFileName(GetModuleHandle(NULL),g_path,MAX_PATH);
#else
	GetModuleFileName(g_hInstance,g_path,MAX_PATH);
#endif
	char *p=g_path+strlen(g_path);
	while (p > g_path && *p != '\\') p--;
	*p = 0;


#ifdef WA3_COMPONENT
  strcat(g_path,"\\wacs\\data");
#endif

#ifdef LASER
  strcat(g_path,"\\avs_laser");
#else
  strcat(g_path,"\\avs");
#endif
  CreateDirectory(g_path,NULL);

#ifndef WA3_COMPONENT
	//InitializeCriticalSection(&g_cs);
#endif
	//InitializeCriticalSection(&g_render_cs);
	//g_ThreadQuit=0;
	g_visdata_pstat=1;

	AVS_EEL_IF_init();

	if (Wnd_Init(this_mod))
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

	Render_Init(g_hInstance, (const char*) this_mod->userData);

	//CfgWnd_Create(this_mod);

	//g_hThread=(HANDLE)_beginthreadex(NULL,0,RenderThread,0,0,(unsigned int *)&id);
  //main_setRenderThreadPriority();

  return 0;
}

int avs_resize(struct winampVisModule *this_mod)
{
	RECT r;
	GetClientRect(g_hwnd,&r);
	DDraw_Resize(r.right-r.left,r.bottom-r.top,cfg_fs_d&2);
	return 0;
}

int avs_render(struct winampVisModule *this_mod)
{
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
			g_visdata[0][0][x]=g_logtab[(unsigned char)this_mod->spectrumData[0][x]];
	else 
	{
		for (x = 0; x < 576*2; x ++)
		{ 
			int t=g_logtab[(unsigned char)this_mod->spectrumData[0][x]];
			if (g_visdata[0][0][x] < t)
				g_visdata[0][0][x] = t;
		}
	}
	memcpy(&g_visdata[1][0][0],this_mod->waveformData,576*2);
	{
    int lt[2]={0,0};
    int x;
    int ch;
    for (ch = 0; ch < 2; ch ++)
    {
      unsigned char *f=(unsigned char*)&this_mod->waveformData[ch][0];
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

	int w,h,*fb=NULL, *fb2=NULL,beat=0;
	int s = 0;

	g_visdata_pstat=1;
	beat=g_is_beat;
	g_is_beat=0;

	char vis_data[2][2][576];
	memcpy(&vis_data[0][0][0],&g_visdata[0][0][0],576*2*2);

	DDraw_Enter(&w,&h,&fb,&fb2);

	int t=g_render_transition->render(vis_data,beat,s?fb2:fb,s?fb:fb2,w,h);
	if (t&1) s^=1;
	DDraw_Exit(s);

#ifdef LASER
    s=0;
    memset(fb,0,w*h*sizeof(int));
    LineDrawList(g_laser_linelist,fb,w,h);
#endif
	return 0;
}

void avs_quit(struct winampVisModule *this_mod)
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
    DS("Calling ddraw_quit\n");
		DDraw_Quit();

    //DS("Calling cfgwnd_destroy\n");
		//CfgWnd_Destroy();
    DS("Calling render_quit\n");
		Render_Quit(this_mod->hDllInstance, (const char*) this_mod->userData);

    DS("Calling wnd_quit\n");
		Wnd_Quit();

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

#ifdef WA3_COMPONENT
static winampVisModule dummyMod;

void init3(void)
{
  extern HWND g_wndparent;
  dummyMod.hwndParent=g_wndparent;
  dummyMod.hDllInstance=g_hInstance;
  init(&dummyMod);
}

void quit3(void)
{
  extern HWND last_parent;
  if (last_parent) 
  {
    ShowWindow(GetParent(last_parent),SW_SHOWNA);
  }
  quit(&dummyMod);
}
#endif
