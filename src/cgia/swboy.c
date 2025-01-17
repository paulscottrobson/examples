#include "../x65.h"
#include "data/swboy_tiles.h"

void init()
{
    uint i;

    // disable all planes, so CGIA does not go haywire during reconfiguration
    CGIA.planes = 0b00000000;

    // configure plane0
    CGIA.plane[0].regs.bckgnd.flags = PLANE_MASK_DOUBLE_WIDTH; // multicolor double-width
    CGIA.plane[0].regs.bckgnd.row_height = 7;                  // 8 rows per character
    CGIA.plane[0].regs.bckgnd.border_columns = border_columns;
    CGIA.plane[0].regs.bckgnd.stride = 0;
    CGIA.plane[0].regs.bckgnd.scroll_x = 0;
    CGIA.plane[0].regs.bckgnd.offset_x = 0;
    CGIA.plane[0].regs.bckgnd.scroll_y = 0;
    CGIA.plane[0].regs.bckgnd.offset_y = 0;
    CGIA.plane[0].regs.bckgnd.shared_color[0] = 0;
    CGIA.plane[0].regs.bckgnd.shared_color[1] = 0;

    for (i = 0; i < sizeof(tile_map); ++i)
    {
        const BYTE tile_no = tile_map[i];
        video_offset[i] = tile_no;
        color_offset[i] = color_data[tile_no];
        bkgnd_offset[i] = bkgnd_data[tile_no];
    }

    // insert character generator data
    *((WORD *)(display_list + 7)) = (WORD)bitmap_data;
    // fix DL looping
    *((WORD *)(display_list + sizeof(display_list) - 2)) = (WORD)display_list;
    // point plane0 to DL
    CGIA.plane[0].offset = (WORD)display_list;

    // activate plane0
    CGIA.planes = 0b00000001;
}
