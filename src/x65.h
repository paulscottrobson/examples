#include "./cgia.h"

#define CGIA_ADDR (0xFF00)
#define CGIA      (*(struct cgia_t *)CGIA_ADDR)

#define CGIA_HORIZONTAL_PIXELS  (384)
#define CGIA_VERTICAL_LINES     (240)
#define CGIA_HORIZONTAL_COLUMNS (CGIA_HORIZONTAL_PIXELS / CGIA_COLUMN_PX)
