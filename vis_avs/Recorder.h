// Recorder.h: interface for the CRecorder class.
//
//////////////////////////////////////////////////////////////////////

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <windows.h>
#include <mmsystem.h>
#pragma comment(lib,"winmm.lib")

typedef struct _PCMFORMAT
{
	WORD    wBitsPerSample;//no.of bits per sample for Recording 
	WORD	wChannels;//no.of channels for Recording
	DWORD	dwSampleRate;//Sampling rate for Recording
}PCMFORMAT, *LPPCMFORMAT;
struct WAVECLASS
{
	HWAVE hWave;
	void* lpData;
};

#define MAXNUMOFBUFFER 16

typedef BOOL (*ProcessBuffer)(void* lpData, LPWAVEHDR pwh);

class Recorder
{
public:
	Recorder(int nBufferLength=2048);
	Recorder(PCMFORMAT pcm,int nBufferLength=2048);
	Recorder(WORD wBitsPerSample,WORD wChannels,DWORD dwSampleRate,int nBufferLength=2048);
	virtual ~Recorder();
	void Open(DWORD dwCallBack=NULL,DWORD dwCallbackType=CALLBACK_FUNCTION,MCIDEVICEID wMCIDeviceID=WAVE_MAPPER);
	void Close();
	void Start();
	void Stop();
	void ReuseHeader(LPWAVEHDR pwh);
	void SetFormat(LPPCMFORMAT lpPcmFormat);
	void SetFormat(WORD wBitsPerSample,WORD wChannels,DWORD dwSampleRate);
	BOOL IsRecording();
	BOOL IsDeviceOpen();
	DWORD GetPosition();
	BOOL Pause();
	BOOL Continue();
	BOOL IsFormatSupported(WAVEFORMATEX wfEx, UINT nDev=WAVE_MAPPER);
	LPWAVEHDR m_lpWaveHdr;
protected:
	WAVECLASS m_waveClass;
	GLOBALHANDLE m_hWaveInHdr[MAXNUMOFBUFFER];
	LPWAVEHDR m_lpWaveInHdr[MAXNUMOFBUFFER];
	GLOBALHANDLE m_hInBuffer[MAXNUMOFBUFFER];
	LPBYTE m_lpInBuffer [MAXNUMOFBUFFER];
	PCMFORMAT m_PcmFormat;
	WAVEFORMATEX m_WaveFormat;
	HWAVEIN m_hWaveIn;
	BOOL m_bRecording;
	BOOL m_bDeviceOpen;
	DWORD m_dwBufferSize;
};

