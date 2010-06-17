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
OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */ #include "config.h"
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
#include "fft.h"
#include "Recorder.h"

#include <string>
#include <vector>
#include <stdio.h>

#include "debug.h"
#include "avs_eelif.h"

char g_vis_data[2][2][SAMPLES] = { 0 };
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

HANDLE g_hThread;
DWORD g_ThreadId;
HANDLE g_hReadyEvent;

static int g_is_beat;
char g_path[1024];

int beat_peak1,beat_peak2, beat_cnt,beat_peak1_peak;

std::string g_init_path;

std::vector<int> g_framebuffer;
std::vector<int> g_framebuffer2;
std::vector<float> g_frameresultf;
int g_width, g_height, g_size;
FFT g_FFT;
Recorder g_Recorder(8, 2, 44100, SAMPLES);
int g_randomizeIfNoLoopback;
int g_randomizeInput = 0;

int waitToReady()
{
	if (WaitForSingleObject(g_hReadyEvent, INFINITE) != WAIT_OBJECT_0)
		return 1; // error

	return 0;
}

int avs_init(const char* path, int width, int height, int randomizeIfNoLoopback)
{
	g_init_path = path;

	strncpy(g_path, path, MAX_PATH);

#ifdef LASER
	strcat(g_path,"avs_laser");
#else
	strcat(g_path,"avs");
#endif
	CreateDirectory(g_path,NULL);

	g_randomizeIfNoLoopback = randomizeIfNoLoopback;

	AVS_EEL_IF_init();

	Wnd_Init(path);

	for (int x = 0; x < 256; x ++)
	{
		double a=log(x*60.0/255.0 + 1.0)/log(60.0);
		int t=(int)(a*255.0);
		if (t<0)t=0;
		if (t>255)t=255;
		g_logtab[x]=(unsigned char )t;
	}

	initBpm();

	Render_Init(path);

	g_FFT.Init(SAMPLES, SAMPLES, 0);

	g_hReadyEvent = CreateEvent(NULL,FALSE,FALSE,NULL);

	g_hThread=(HANDLE)_beginthreadex(NULL,0,RenderThread,0,0,(unsigned int *) &g_ThreadId);

	avs_resize(width, height);
	return 0;
}

int avs_resize(int width, int height)
{
	if (waitToReady()) return 1;

	g_width = width;
	g_height = height;
	int pixels = width * height;

	g_framebuffer.resize(pixels);
	g_framebuffer2.resize(pixels);
	memset(&g_framebuffer[0], 0, pixels*sizeof(int));
	memset(&g_framebuffer2[0], 0, pixels*sizeof(int));

	g_size = pixels*4;
	g_frameresultf.resize(g_size);
    for (int i = 0; i < g_size; i += 4)
	{
		g_frameresultf[i] = 0;
		g_frameresultf[i+1] = 0;
		g_frameresultf[i+2] = 0;
		g_frameresultf[i+3] = 1;
	}

	PostThreadMessage(g_ThreadId, WM_PAINT, 0, 0);
	return 0;
}

int avs_render(void* colors)
{
	if (waitToReady()) return 1;

	memcpy(colors, &g_frameresultf[0], g_size*sizeof(float));

	PostThreadMessage(g_ThreadId, WM_PAINT, 0, 0);
	return 0;
}

void avs_save_present()
{
	if (g_render_effects)
	{
		std::string file = g_init_path;
#ifdef LASER
		file += "vis_avs_laser.dat";
#else
		file += "vis_avs.dat";
#endif
		g_render_effects->__SavePreset(file.c_str());
	}
}

void avs_quit()
{
#define DS(x) 
  //MessageBox(this_mod->hwndParent,x,"AVS Debug",MB_OK)
	if (g_hThread)
	{
		PostThreadMessage(g_ThreadId, WM_QUIT, 0, 0);
		DS("Waitin for thread to quit\n");

		if (WaitForSingleObject(g_hThread,10000) != WAIT_OBJECT_0)
		{
			DS("Terminated thread (BAD!)\n");
			TerminateThread(g_hThread,0);
		}

		g_FFT.CleanUp();
		g_Recorder.Close();

		//DS("Calling cfgwnd_destroy\n");
		//CfgWnd_Destroy();
		DS("Calling render_quit\n");
		Render_Quit();

		DS("Calling wnd_quit\n");
		Wnd_Quit(g_init_path.c_str());

		DS("closing thread handle\n");
		CloseHandle(g_hThread);
		g_hThread=NULL;

		DS("calling eel quit\n");
		AVS_EEL_IF_quit();

		DS("cleaning up critsections\n");
		//DeleteCriticalSection(&g_render_cs);    

		DS("smp_cleanupthreads\n");
		C_RenderListClass::smp_cleanupthreads();
	}
#undef DS
}

int avs_get_random_input()
{
	return g_randomizeInput;
}

void avs_set_random_input(int enable)
{
	g_randomizeInput = enable;
}

void renderOneFrame(float* colors)
{
	float spectrumData[2][SAMPLES];
	float waveformData[2][SAMPLES];
	int i;

	unsigned char* wave = (unsigned char*) &g_vis_data[1][0][0];
	for (i = 0; i < SAMPLES*2; i++)
		waveformData[0][i]=(float)((wave[i] ^ 128) - 128);

	g_FFT.time_to_frequency_domain(waveformData[0], spectrumData[0]);
	g_FFT.time_to_frequency_domain(waveformData[1], spectrumData[1]);

	//g_PCM.addPCM8_512(waveformData);


	int x,avs_beat=0,b;
	//if (g_ThreadQuit) return 1;
	//EnterCriticalSection(&g_cs);
	//if (g_ThreadQuit)
	//{
		//LeaveCriticalSection(&g_cs);
		//return 1;
	//}
	for (x = 0; x<  SAMPLES*2; x ++)
	{
		//g_vis_data[0][0][x]=(unsigned char) (spectrumData[0][x]);
		float y = spectrumData[0][x];
		if (y > 256) y = 256;
		else if (y < 0) y = 0;

		g_vis_data[0][0][x]=g_logtab[(unsigned char) y];
	}

	{
		int lt[2]={0,0};
		int x;
		int ch;
		for (ch = 0; ch < 2; ch ++)
		{
		  unsigned char *f=(unsigned char*)&g_vis_data[1][ch][0];
		  for (x = 0; x < SAMPLES; x ++)
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

		if (lt[0] >= (beat_peak1*34)/32 && lt[0] > (SAMPLES*16)) 
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
		else
		{
			beat_peak2=(beat_peak2*14)/16;
		}

	}
	b=refineBeat(avs_beat);
	if (b) g_is_beat=1;
	//LeaveCriticalSection(&g_cs);

#ifdef LASER
    g_laser_linelist->ClearLineList();
#endif

	int beat=0;
	int s = 0;

	beat=g_is_beat;
	g_is_beat=0;

	int t;
	if (s)
		t=g_render_transition->render(g_vis_data,beat,&g_framebuffer2[0],&g_framebuffer[0],g_width,g_height);
	else
		t=g_render_transition->render(g_vis_data,beat,&g_framebuffer[0],&g_framebuffer2[0],g_width,g_height);

	if (t&1) s^=1;

	unsigned char *src = (unsigned char *) (s?&g_framebuffer2[0]:&g_framebuffer[0]);
	float *dst = (float *) colors;

    for (i = 0; i < g_size; i += 4)
	{
		dst[i] = ((float) src[i])*0.0039215686274509803f;
		dst[i+1] = ((float) src[i+1])*0.0039215686274509803f;
		dst[i+2] = ((float) src[i+2])*0.0039215686274509803f;
		dst[i+3] = 1;
	}

#ifdef LASER
    s=0;
    memset(g_framebuffer,0,pixels*sizeof(int));
    LineDrawList(g_laser_linelist,g_framebuffer,w,h);
#endif
}

void initRandom()
{
	FILETIME ft;
	GetSystemTimeAsFileTime(&ft);
	srand(ft.dwLowDateTime|ft.dwHighDateTime^GetCurrentThreadId());
}

void randomizeWaveData()
{
	g_vis_data[1][0][0] = 0;
	g_vis_data[1][1][0] = 0;
	for (int i = 1; i < SAMPLES; i++)
	{
		g_vis_data[1][0][i] = g_vis_data[1][0][i-1] + (rand()%127 - 63);
		g_vis_data[1][1][i] = g_vis_data[1][1][i-1] + (rand()%127 - 63);
	}
}

UINT findAudioLoopback()
{
	static const char* names[] =
	{
		"stereo mix",
		"wave out mix",
		"what u hear",
		"soundcard out",
		NULL
	};

	WAVEINCAPS wic;
	UINT numDevs = waveInGetNumDevs();
	UINT x, y;

	for (x = 0; x < numDevs; x++)
	{
		if (waveInGetDevCaps(x,&wic,sizeof(WAVEINCAPS)) == MMSYSERR_NOERROR)
		{
			for (y = 0; wic.szPname[y] != '\0'; y++)
				wic.szPname[y] = (char)tolower(wic.szPname[y]);
			
			for (y = 0; names[y] != NULL; y++)
			{
				if (strstr(wic.szPname, names[y])) return x;
			}
		}
	}

	return WAVE_MAPPER;
}

void initAudioDevice()
{
	UINT deviceId = findAudioLoopback();
	if (deviceId != WAVE_MAPPER)
	{
		g_Recorder.Open((DWORD) GetCurrentThreadId(), CALLBACK_THREAD, deviceId);
		g_Recorder.Start();
	}
	else if (g_randomizeIfNoLoopback)
	{
		g_randomizeInput = 1;
	}
}

void processWaveData(WAVEHDR* hdr)
{
	memcpy(&g_vis_data[1][0][0], hdr->lpData, hdr->dwBytesRecorded);
	g_Recorder.ReuseHeader(hdr);
}

static unsigned int WINAPI RenderThread(LPVOID a)
{
	MSG msg;

	PeekMessage(&msg, NULL, WM_USER, WM_USER, PM_NOREMOVE); // create message queue

	initAudioDevice();
	initRandom();

	SetEvent(g_hReadyEvent);

	while (GetMessage(&msg, 0, 0, 0))
	{
		switch (msg.message) {

			case WM_PAINT:
				if (g_randomizeInput) randomizeWaveData();
				renderOneFrame(&g_frameresultf[0]);
				SetEvent(g_hReadyEvent);
				break;

			case WIM_DATA:
				processWaveData((WAVEHDR*)msg.lParam);
				break;

		}
	}

	g_Recorder.Stop();
	g_Recorder.Close();

	CloseHandle(g_hReadyEvent);
	_endthreadex(0);
	return 0;
}