//
//  bgfx-bridging.c
//  bgfx Test
//
//  Created by Stuart Carnie on 4/19/16.
//  Copyright © 2016 SGC. All rights reserved.
//

#include <stdint.h>
#include <bgfx/bgfx+.h>

void bgfx_dbg_text_print(uint16_t _x, uint16_t _y, uint8_t _attr, const char* _text)
{
    bgfx_dbg_text_printf(_x, _y, _attr, _text);
}