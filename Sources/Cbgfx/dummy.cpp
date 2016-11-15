#include "bgfx/bgfx.h"

extern
void dummy() {
	bgfx_init(BGFX_RENDERER_TYPE_COUNT, 0, 0, NULL, NULL);
}
