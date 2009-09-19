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
#include <stdio.h>
#include <windows.h>
#include <windowsx.h>
#include "vis.h"
#include "draw.h"
#include "wnd.h"
#include "cfgwnd.h"
#include "r_defs.h"
#include "resource.h"
#include "render.h"
#include "undo.h"
#include <multimon.h>
#include <string>
#include "vis_avs.h"

#include "avs_eelif.h"
#include "debug.h"

#ifdef WA3_COMPONENT
#include "wasabicfg.h"
#include "../studio/studio/api.h"
#include "../studio/common/metatags.h"
#include "../studio/bfc/rootwnd.h"

CRITICAL_SECTION g_title_cs;
char g_title[2048];

#else
#define WINAMP_NEXT_WINDOW 40063
#include "wa_ipc.h"
#include "ff_ipc.h"
#endif

#define WS_EX_LAYERED	0x80000
#define LWA_ALPHA		2

#define ID_VIS_NEXT                     40382
#define ID_VIS_PREV                     40383
#define ID_VIS_RANDOM                   40384

//extern volatile int g_ThreadQuit;
extern int /*g_preset_dirty,*/ config_prompt_save_preset, config_reuseonresize;
int g_saved_preset_dirty;
extern int cfg_cancelfs_on_deactivate;

extern char g_noeffectstr[];
#ifndef WA2_EMBED
#ifndef WA3_COMPONENT
static 
#endif
int cfg_x=100, cfg_y=100, cfg_w=400, cfg_h=300;
#endif

#ifndef WA2_EMBED
static HDC hFrameDC;
static HBITMAP hFrameBitmap, hFrameBitmap_old;
#else
embedWindowState myWindowState;
HWND g_hWA2ParentWindow;
#endif

int g_reset_vars_on_recompile=1; // fucko: add config for this


// Wharf integration
int inWharf=0;
int need_redock=0;
#ifdef WA3_COMPONENT
HWND last_parent;
#endif

extern int cfg_fs_use_overlay;
extern int g_config_seh;

//-

int g_in_destroy=0,g_minimized=0,g_fakeinit=0;

int g_rnd_cnt;
char g_skin_name[MAX_PATH];

int debug_reg[8];

void GetClientRect_adj(HWND hwnd, RECT *r)
{
  GetClientRect(hwnd,r);
}

HWND g_hwnd;

HWND hwnd_WinampParent;
extern HWND g_hwndDlg;
extern char last_preset[2048];
char *scanstr_back(char *str, char *toscan, char *defval)
{
	char *s=str+strlen(str)-1;
	if (strlen(str) < 1) return defval;
	if (strlen(toscan) < 1) return defval;
	while (1)
	{
		char *t=toscan;
		while (*t)
			if (*t++ == *s) return s;
		t=CharPrev(str,s);
		if (t==s) return defval;
		s=t;
	}
}

int LoadPreset(int preset)
{
  char temp[MAX_PATH];
  wsprintf(temp,"%s\\PRESET%02d.APH",g_path,preset);
  if (g_render_transition->LoadPreset(temp,1))
    return 0;
  if (preset < 12) wsprintf(last_preset,"\\F%d.aph",preset+1);
  else if (preset < 22) wsprintf(last_preset,"\\%d.aph",preset-12);
  else if (preset < 32) wsprintf(last_preset,"\\Shift-%d.aph",preset-22);
  return 1;
}

void WritePreset(int preset)
{
  char temp[MAX_PATH];
  wsprintf(temp,"%s\\PRESET%02d.APH",g_path,preset);
  g_render_effects->__SavePreset(temp);
}


char *extension(char *fn) 
{
  char *s = fn + strlen(fn);
  while (s >= fn && *s != '.' && *s != '\\') s--;
  if (s < fn) return fn;
  if (*s == '\\') return fn;
  return (s+1);
}

int g_config_smp_mt=2,g_config_smp=0;
static const char *INI_FILE;
static std::string INI_FILE_BUF;

int cfg_fs_dblclk=1;

int Wnd_Init(struct winampVisModule *this_mod)
{
	//g_mod = this_mod;
	g_hwnd = this_mod->hwndParent;
	DDraw_Init();

	avs_resize(this_mod);

	const char* path = (const char*) this_mod->userData;
	if (path) INI_FILE_BUF = path;
	INI_FILE_BUF += "winamp.ini";
	INI_FILE = INI_FILE_BUF.c_str();

#define AVS_SECTION "AVS"
#ifdef LASER
#undef AVS_SECTION
#define AVS_SECTION "AVS_L"
    extern int g_laser_nomessage,g_laser_zones;
    g_laser_nomessage=GetPrivateProfileInt(AVS_SECTION,"laser_nomessage",0,INI_FILE);
    g_laser_zones=GetPrivateProfileInt(AVS_SECTION,"laser_zones",1,INI_FILE);
#else
    g_config_smp=GetPrivateProfileInt(AVS_SECTION,"smp",0,INI_FILE);
    g_config_smp_mt=GetPrivateProfileInt(AVS_SECTION,"smp_mt",2,INI_FILE);
#endif
    need_redock=GetPrivateProfileInt(AVS_SECTION,"cfg_docked",0,INI_FILE);
		cfg_cfgwnd_x=GetPrivateProfileInt(AVS_SECTION,"cfg_cfgwnd_x",cfg_cfgwnd_x,INI_FILE);
		cfg_cfgwnd_y=GetPrivateProfileInt(AVS_SECTION,"cfg_cfgwnd_y",cfg_cfgwnd_y,INI_FILE);
		cfg_cfgwnd_open=GetPrivateProfileInt(AVS_SECTION,"cfg_cfgwnd_open",cfg_cfgwnd_open,INI_FILE);
		cfg_fs_w=GetPrivateProfileInt(AVS_SECTION,"cfg_fs_w",cfg_fs_w,INI_FILE);
		cfg_fs_h=GetPrivateProfileInt(AVS_SECTION,"cfg_fs_h",cfg_fs_h,INI_FILE);
		cfg_fs_bpp=GetPrivateProfileInt(AVS_SECTION,"cfg_fs_bpp",cfg_fs_bpp,INI_FILE);
		cfg_fs_d=GetPrivateProfileInt(AVS_SECTION,"cfg_fs_d",cfg_fs_d,INI_FILE);
    cfg_fs_fps=GetPrivateProfileInt(AVS_SECTION,"cfg_fs_fps",6,INI_FILE);
    cfg_fs_rnd=GetPrivateProfileInt(AVS_SECTION,"cfg_fs_rnd",cfg_fs_rnd,INI_FILE);
    cfg_fs_rnd_time=GetPrivateProfileInt(AVS_SECTION,"cfg_fs_rnd_time",cfg_fs_rnd_time,INI_FILE);
    cfg_fs_dblclk=GetPrivateProfileInt(AVS_SECTION,"cfg_fs_dblclk",cfg_fs_dblclk,INI_FILE);
    cfg_fs_flip=GetPrivateProfileInt(AVS_SECTION,"cfg_fs_flip",cfg_fs_flip,INI_FILE);
    cfg_fs_height=GetPrivateProfileInt(AVS_SECTION,"cfg_fs_height",cfg_fs_height,INI_FILE);
    cfg_fs_use_overlay=GetPrivateProfileInt(AVS_SECTION,"cfg_fs_use_overlay",cfg_fs_use_overlay,INI_FILE);
    cfg_cancelfs_on_deactivate=GetPrivateProfileInt(AVS_SECTION,"cfg_fs_cancelondeactivate",cfg_cancelfs_on_deactivate,INI_FILE);
    cfg_speed=GetPrivateProfileInt(AVS_SECTION,"cfg_speed",cfg_speed,INI_FILE);
    cfg_trans=GetPrivateProfileInt(AVS_SECTION,"cfg_trans",cfg_trans,INI_FILE);
    cfg_dont_min_avs=GetPrivateProfileInt(AVS_SECTION,"cfg_dont_min_avs",cfg_dont_min_avs,INI_FILE);
    cfg_smartbeat=GetPrivateProfileInt(AVS_SECTION,"cfg_smartbeat",cfg_smartbeat,INI_FILE);
    cfg_smartbeatsticky=GetPrivateProfileInt(AVS_SECTION,"cfg_smartbeatsticky",cfg_smartbeatsticky,INI_FILE);
    cfg_smartbeatresetnewsong=GetPrivateProfileInt(AVS_SECTION,"cfg_smartbeatresetnewsong",cfg_smartbeatresetnewsong,INI_FILE);
    cfg_smartbeatonlysticky=GetPrivateProfileInt(AVS_SECTION,"cfg_smartbeatonlysticky",cfg_smartbeatonlysticky,INI_FILE);
    GetPrivateProfileString( AVS_SECTION,"config_pres_subdir","",config_pres_subdir,sizeof(config_pres_subdir),INI_FILE);
    GetPrivateProfileString( AVS_SECTION,"last_preset_name","",last_preset,sizeof(last_preset),INI_FILE);
    cfg_transitions=GetPrivateProfileInt(AVS_SECTION,"cfg_transitions_en",cfg_transitions,INI_FILE);
    cfg_transitions2=GetPrivateProfileInt(AVS_SECTION,"cfg_transitions_preinit",cfg_transitions2,INI_FILE);
    cfg_transitions_speed=GetPrivateProfileInt(AVS_SECTION,"cfg_transitions_speed",cfg_transitions_speed,INI_FILE);
    cfg_transition_mode=GetPrivateProfileInt(AVS_SECTION,"cfg_transitions_mode",cfg_transition_mode,INI_FILE);
    cfg_bkgnd_render=GetPrivateProfileInt(AVS_SECTION,"cfg_bkgnd_render",cfg_bkgnd_render,INI_FILE);
    cfg_bkgnd_render_color=GetPrivateProfileInt(AVS_SECTION,"cfg_bkgnd_render_color",cfg_bkgnd_render_color,INI_FILE);
    cfg_render_prio=GetPrivateProfileInt(AVS_SECTION,"cfg_render_prio",cfg_render_prio,INI_FILE);
    g_saved_preset_dirty=GetPrivateProfileInt(AVS_SECTION,"g_preset_dirty",C_UndoStack::isdirty(),INI_FILE);
    config_prompt_save_preset=GetPrivateProfileInt(AVS_SECTION,"cfg_prompt_save_preset",config_prompt_save_preset,INI_FILE);
    config_reuseonresize=GetPrivateProfileInt(AVS_SECTION,"cfg_reuseonresize",config_reuseonresize,INI_FILE);
    g_log_errors=GetPrivateProfileInt(AVS_SECTION,"cfg_log_errors",g_log_errors,INI_FILE);
    g_reset_vars_on_recompile=GetPrivateProfileInt(AVS_SECTION,"cfg_reset_vars",g_reset_vars_on_recompile,INI_FILE);
    g_config_seh=GetPrivateProfileInt(AVS_SECTION,"cfg_seh",g_config_seh,INI_FILE);

    
#ifdef WA2_EMBED
    memset(&myWindowState,0,sizeof(myWindowState));
    myWindowState.r.left=GetPrivateProfileInt(AVS_SECTION,"wx",32,INI_FILE);
    myWindowState.r.top=GetPrivateProfileInt(AVS_SECTION,"wy",32,INI_FILE);
    myWindowState.r.right = GetPrivateProfileInt(AVS_SECTION,"ww",320,INI_FILE)+myWindowState.r.left;
    myWindowState.r.bottom = GetPrivateProfileInt(AVS_SECTION,"wh",240,INI_FILE)+myWindowState.r.top;
#else
		cfg_x=GetPrivateProfileInt(AVS_SECTION,"cfg_x",cfg_x,INI_FILE);
		cfg_y=GetPrivateProfileInt(AVS_SECTION,"cfg_y",cfg_y,INI_FILE);
		cfg_w=GetPrivateProfileInt(AVS_SECTION,"cfg_w",cfg_w,INI_FILE);
		cfg_h=GetPrivateProfileInt(AVS_SECTION,"cfg_h",cfg_h,INI_FILE);
#endif

    int x;
    for (x = 0; x < 8; x ++)
    {
      char debugreg[32];
      wsprintf(debugreg,"debugreg_%d",x);
		  debug_reg[x]=GetPrivateProfileInt(AVS_SECTION,debugreg,x,INI_FILE);
    }

#ifdef LASER
  cfg_transitions=0;
  cfg_transition_mode=0;
  cfg_transitions2=0;
#endif

	g_in_destroy=0;
	/*
#ifndef WA2_EMBED
  {
    RECT ir={cfg_x,cfg_y,cfg_w+cfg_x,cfg_y+cfg_h};
    RECT or;
    my_getViewport(&or,&ir);
    if (cfg_x < or.left) cfg_x=or.left;
    if (cfg_y < or.top) cfg_y=or.top;
    if (cfg_x > or.right-16) cfg_x=or.right-16;
    if (cfg_y > or.bottom-16) cfg_y=or.bottom-16;
    // determine bounding rectangle for window
  }
#endif
  */
#ifdef WA3_COMPONENT
  int styles=WS_VISIBLE|WS_CHILD|WS_CLIPCHILDREN|WS_CLIPSIBLINGS;
  HWND par = this_mod->hwndParent;
#else
#ifndef WA2_EMBED
  int styles=WS_VISIBLE;
  HWND par = g_minimized?NULL:this_mod->hwndParent;
#else
  int styles=WS_VISIBLE|WS_CHILDWINDOW|WS_OVERLAPPED|WS_CLIPCHILDREN|WS_CLIPSIBLINGS;
  HWND (*e)(embedWindowState *v);
  *(void**)&e = (void *)SendMessage(this_mod->hwndParent,WM_WA_IPC,(LPARAM)0,IPC_GET_EMBEDIF);
  HWND par=0;
  if (e) par=e(&myWindowState);
  
  if (par)
    SetWindowText(par,"AVS");

  g_hWA2ParentWindow=par;
#endif
#endif

  return 0;
}

static void WriteInt(const char *INI_FILE, char *name, int value)
{
  char str[128];
  wsprintf(str,"%d",value);
	WritePrivateProfileString(AVS_SECTION,name,str,INI_FILE);
}

void Wnd_Quit(void)	
{
  g_in_destroy=1;
#ifdef LASER
    extern int g_laser_zones,g_laser_nomessage;
    //wsprintf(str,"%d",g_laser_zones);
		WriteInt(INI_FILE, "laser_zones",g_laser_zones);
		WriteInt(INI_FILE, "laser_nomessage",g_laser_nomessage);
#else
    WriteInt(INI_FILE, "smp",g_config_smp);
    WriteInt(INI_FILE, "smp_mt",g_config_smp_mt);
#endif
#ifdef WA2_EMBED
		WriteInt(INI_FILE, "wx",myWindowState.r.left);
    WriteInt(INI_FILE, "wy",myWindowState.r.top);
		WriteInt(INI_FILE, "ww",myWindowState.r.right-myWindowState.r.left);
		WriteInt(INI_FILE, "wh",myWindowState.r.bottom-myWindowState.r.top);
#else
		WriteInt(INI_FILE, "cfg_x",cfg_x);
		WriteInt(INI_FILE, "cfg_y",cfg_y);
		WriteInt(INI_FILE, "cfg_w",cfg_w);
		WriteInt(INI_FILE, "cfg_h",cfg_h);
#endif
		WritePrivateProfileString(AVS_SECTION,"config_pres_subdir",config_pres_subdir,INI_FILE);

		//WriteInt(INI_FILE, "cfg_docked",inWharf?1:0);
		WriteInt(INI_FILE, "cfg_cfgwnd_open",cfg_cfgwnd_open);
		WriteInt(INI_FILE, "cfg_cfgwnd_x",cfg_cfgwnd_x);
		WriteInt(INI_FILE, "cfg_cfgwnd_y",cfg_cfgwnd_y);
		WriteInt(INI_FILE, "cfg_fs_w",cfg_fs_w);
		WriteInt(INI_FILE, "cfg_fs_h",cfg_fs_h);
		WriteInt(INI_FILE, "cfg_fs_d",cfg_fs_d);
		WriteInt(INI_FILE, "cfg_fs_bpp",cfg_fs_bpp);
		WriteInt(INI_FILE, "cfg_fs_fps",cfg_fs_fps);
		WriteInt(INI_FILE, "cfg_fs_rnd",cfg_fs_rnd);
		WriteInt(INI_FILE, "cfg_fs_rnd_time",cfg_fs_rnd_time);    
    WriteInt(INI_FILE, "cfg_fs_dblclk",cfg_fs_dblclk);
		WriteInt(INI_FILE, "cfg_fs_flip",cfg_fs_flip);
		WriteInt(INI_FILE, "cfg_fs_height",cfg_fs_height);
		WriteInt(INI_FILE, "cfg_fs_use_overlay",cfg_fs_use_overlay);
		WriteInt(INI_FILE, "cfg_fs_cancelondeactivate",cfg_cancelfs_on_deactivate);
		WriteInt(INI_FILE, "cfg_speed",cfg_speed);
		WriteInt(INI_FILE, "cfg_trans",cfg_trans);
		WriteInt(INI_FILE, "cfg_dont_min_avs",cfg_dont_min_avs);
		WriteInt(INI_FILE, "cfg_smartbeat",cfg_smartbeat);
		WriteInt(INI_FILE, "cfg_smartbeatsticky",cfg_smartbeatsticky);
		WriteInt(INI_FILE, "cfg_smartbeatresetnewsong",cfg_smartbeatresetnewsong);
		WriteInt(INI_FILE, "cfg_smartbeatonlysticky",cfg_smartbeatonlysticky);
		WriteInt(INI_FILE, "cfg_transitions_en",cfg_transitions);
		WriteInt(INI_FILE, "cfg_transitions_preinit",cfg_transitions2);
		WriteInt(INI_FILE, "cfg_transitions_speed",cfg_transitions_speed);
		WriteInt(INI_FILE, "cfg_transitions_mode",cfg_transition_mode);
		WriteInt(INI_FILE, "cfg_bkgnd_render",cfg_bkgnd_render);
		WriteInt(INI_FILE, "cfg_bkgnd_render_color",cfg_bkgnd_render_color);
		WriteInt(INI_FILE, "cfg_render_prio",cfg_render_prio);
    WriteInt(INI_FILE, "g_preset_dirty",C_UndoStack::isdirty());
    WriteInt(INI_FILE, "cfg_prompt_save_preset",config_prompt_save_preset);
		WritePrivateProfileString(AVS_SECTION,"last_preset_name",last_preset,INI_FILE);
    WriteInt(INI_FILE, "cfg_reuseonresize",config_reuseonresize);
    WriteInt(INI_FILE, "cfg_log_errors",g_log_errors);
    WriteInt(INI_FILE, "cfg_reset_vars",g_reset_vars_on_recompile);
    WriteInt(INI_FILE, "cfg_seh",g_config_seh);

    int x;
    for (x = 0; x < 8; x ++)
    {
      char debugreg[32];
      wsprintf(debugreg,"debugreg_%d",x);
      WriteInt(INI_FILE, debugreg,debug_reg[x]);
    }
}

static int find_preset(char *parent_path, int dir, char *lastpreset, char *newpreset, int *state)
{
	HANDLE h;
	WIN32_FIND_DATA d;
  char dirmask[4096];
  wsprintf(dirmask,"%s\\*.avs",parent_path);
	h = FindFirstFile(dirmask,&d);
	if (h != INVALID_HANDLE_VALUE)
	{
		do 
    {
      if (!(d.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY))
      {
        wsprintf(dirmask,"%s\\%s",parent_path,d.cFileName);
        
        if (lastpreset)
        {
          if (*state)
          {
            strcpy(newpreset,dirmask);
            FindClose(h);
            return 1;
          }
          if (dir > 0)
          {
            if (!newpreset[0]) // save the first one we find, in case we fail (wrap)
              strcpy(newpreset,dirmask);

            if (!stricmp(dirmask,lastpreset)) *state=1;
          }
          if (dir < 0)
          {
            if (!stricmp(dirmask,lastpreset))
            {
              if (newpreset[0]) { // if we find it first, skip it so we can go to the end :)
                FindClose(h);
                return 1;
              }
            }
            strcpy(newpreset,dirmask);
          }
          
        }
        else
        {
          int cnt=++(*state);
          if (cnt < 1) cnt=1;
          int r=((rand()&1023)<<10)|(rand()&1023);
          if (r < (1024*1024)/cnt)
          {
            strcpy(newpreset,dirmask);
          }
        }
      }
		} while (FindNextFile(h,&d));
		FindClose(h);
	}
  wsprintf(dirmask,"%s\\*.*",parent_path);
	h = FindFirstFile(dirmask,&d);
	if (h != INVALID_HANDLE_VALUE)
	{
		do 
    {
      if (d.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY && d.cFileName[0] != '.')
      {
        wsprintf(dirmask,"%s\\%s",parent_path,d.cFileName);
        if (find_preset(dirmask,dir,lastpreset,newpreset,state)) {
          FindClose(h);
          return 1;
        }
      }
		} while (FindNextFile(h,&d));
		FindClose(h);
  }
  return 0;
}


void avs_next_preset() {
  //g_rnd_cnt=0;

    char dirmask[2048];
    char i_path[1024];
    if (config_pres_subdir[0]) wsprintf(i_path,"%s\\%s",g_path,config_pres_subdir);
    else strcpy(i_path,g_path);

    dirmask[0]=0;

    int state=0;
    find_preset(i_path,1,last_preset,dirmask,&state);

    if (dirmask[0] && stricmp(last_preset,dirmask))
    {
      if (g_render_transition->LoadPreset(dirmask,2) != 2)
  	    lstrcpyn(last_preset,dirmask,sizeof(last_preset));
    }
}

void avs_random_preset() {
  //g_rnd_cnt=0;

    char dirmask[2048];
    char i_path[1024];
    if (config_pres_subdir[0]) wsprintf(i_path,"%s\\%s",g_path,config_pres_subdir);
    else strcpy(i_path,g_path);

    dirmask[0]=0;

    int state=0;
    find_preset(i_path,0,NULL,dirmask,&state);

    if (dirmask[0])
    {  			
      if (g_render_transition->LoadPreset(dirmask,4) != 2)
        lstrcpyn(last_preset,dirmask,sizeof(last_preset));
    }
}

void avs_previous_preset() {
  //g_rnd_cnt=0;

    char dirmask[2048];
    char i_path[1024];
    if (config_pres_subdir[0]) wsprintf(i_path,"%s\\%s",g_path,config_pres_subdir);
    else strcpy(i_path,g_path);

    dirmask[0]=0;

    int state=0;
    find_preset(i_path,-1,last_preset,dirmask,&state);

    if (dirmask[0] && stricmp(last_preset,dirmask))
    {
      if (g_render_transition->LoadPreset(dirmask,2) != 2)
        lstrcpyn(last_preset,dirmask,sizeof(last_preset));
    }
}
