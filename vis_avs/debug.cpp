
#include "debug.h"
#include <windows.h>
#include <stdarg.h>
#include <stdio.h>

void debug(const char* format, ...) {
	va_list args;
	
	va_start(args, format);
	const int size = 512;
	char buffer[size + 1];
	buffer[size] = '\0';
	_vsnprintf(buffer, size, format, args);
	OutputDebugString(buffer);
	va_end(args);
}
