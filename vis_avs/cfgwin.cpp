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
#include <stdio.h>
#include <commctrl.h>
#include "r_defs.h"
#include "vis.h"
#include "cfgwnd.h"
#include "resource.h"
#include "render.h"
#include "rlib.h"
#include "wnd.h"
#include "bpm.h"
#include "avs_eelif.h"
#include "undo.h"

#ifdef LASER
extern "C" {
#include "laser/ld32.h"
}
#endif
static void _do_add(HWND hwnd, HTREEITEM h, C_RenderListClass *list);
static int treeview_hack;
static HTREEITEM g_hroot;

extern int g_config_smp_mt,g_config_smp;
int cfg_cancelfs_on_deactivate=1;

HWND g_debugwnd;

char g_noeffectstr[]= "No effect/setting selected";
//extern char *verstr;
static HWND cur_hwnd;
int is_aux_wnd=0;
int config_prompt_save_preset=1,config_reuseonresize=1;
//int g_preset_dirty;

extern char *extension(char *fn) ;

int g_dlg_fps,g_dlg_w,g_dlg_h;

int cfg_cfgwnd_x=50,cfg_cfgwnd_y=50,cfg_cfgwnd_open=0;

int cfg_fs_w=0,cfg_fs_h=0,cfg_fs_d=2,cfg_fs_bpp=0,cfg_fs_fps=0,cfg_fs_rnd=1,
#ifdef LASER
cfg_fs_flip=6,
#else
cfg_fs_flip=0,
#endif
cfg_fs_height=80,cfg_speed=5,cfg_fs_rnd_time=10,cfg_fs_use_overlay=0;
int cfg_trans=0,cfg_trans_amount=128;
int cfg_dont_min_avs=0;
int cfg_transitions=4;
int cfg_transitions2=4|32;
int cfg_transitions_speed=8;
int cfg_transition_mode=0x8001;
int cfg_bkgnd_render=0,cfg_bkgnd_render_color=0x1F000F;
int cfg_render_prio=0;

char config_pres_subdir[MAX_PATH];
char last_preset[2048];

#ifdef WA2_EMBED
#include "wa_ipc.h"
extern embedWindowState myWindowState;
#endif

#ifndef WA2_EMBED
int cfg_x=100, cfg_y=100, cfg_w=400, cfg_h=300;
#endif
