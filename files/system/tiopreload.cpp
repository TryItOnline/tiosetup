#include <cstdio>
#include <cstdarg>

int __builtin_printf(const char *format, ...)
{
	va_list etc;
	va_start(etc, format);
	bool debug = format == "%s:%d: %s: Assertion '%s' failed.\n";
	int retval = vfprintf(debug ? stderr : stdout, format, etc);
	va_end(etc);

	return retval;
}
