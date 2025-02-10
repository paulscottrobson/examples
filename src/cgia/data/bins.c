// simple hack to write example_data to separate binary files
// usage (on your PC): gcc bins.c -o bins && ./bins

#include <assert.h>
#include <stdint.h>
#include <stdio.h>

#include "./example_data.h"
#include "./sotb-1.h"
#include "./sotb-2.h"
#include "./sotb-3.h"

#define NELEMS(x) (sizeof(x) / sizeof((x)[0]))

void fputw(uint16_t word, FILE *file)
{
    fputc(word & 0xFF, file);
    fputc(word >> 8, file);
}

void fput_header(uint16_t offset, uint16_t size, FILE *file)
{
    fputw(offset, file);            // from
    fputw(offset + size - 1, file); // to
}

int main(void)
{
    FILE *file;

    file = fopen("text_mode_dl.xex", "w");
    assert(file);
    fputw(0xffff, file);                                          // file header
    fput_header(text_mode_dl_offset, NELEMS(text_mode_dl), file); // block header
    for (size_t i = 0; i < NELEMS(text_mode_dl); ++i)
        fputc(text_mode_dl[i], file);
    fclose(file);

    file = fopen("affine_mode_dl.xex", "w");
    assert(file);
    fputw(0xffff, file);
    fput_header(affine_mode_dl_offset, NELEMS(affine_mode_dl), file);
    for (size_t i = 0; i < NELEMS(affine_mode_dl); ++i)
        fputc(affine_mode_dl[i], file);
    fclose(file);

    file = fopen("mixed_mode_dl.xex", "w");
    assert(file);
    fputw(0xffff, file);
    fput_header(mixed_mode_dl_offset, NELEMS(mixed_mode_dl), file);
    for (size_t i = 0; i < NELEMS(mixed_mode_dl); ++i)
        fputc(mixed_mode_dl[i], file);
    fclose(file);

    file = fopen("text_mode_cl.xex", "w");
    assert(file);
    fputw(0xffff, file);
    fput_header(0x0000, 40 * 25, file); // MS
    for (size_t i = 0; i < 40 * 25; ++i)
        if (i >= 10 * 40 && i < 15 * 40)
            switch (i / 40)
            {
            case 10:
            case 14:
                fputc(255, file);
                break;
            case 12:
                fputc(text_mode_hello[i % 40], file);
                break;
            default:
                fputc(0, file);
            }
        else
            fputc(i & 0xFF, file);
    fput_header(0x1000, 40 * 25, file); // CS
    for (size_t i = 0; i < 40 * 25; ++i)
        if (i >= 10 * 40 && i < 15 * 40)
            switch (i / 40)
            {
            case 10:
            case 14:
                fputc(0x98 + (i % 40), file);
                break;
            default:
                fputc(text_mode_fg_color, file);
            }
        else
            fputc(i & 0xFF, file);
    fput_header(0x2000, 40 * 25, file); // BS
    for (size_t i = 0; i < 40 * 25; ++i)
        if (i >= 10 * 40 && i < 15 * 40)
            fputc(text_mode_bg_color, file);
        else
            fputc(0xFF - (i & 0xFF), file);
    fclose(file);

    file = fopen("sotb_layers.xex", "w");
    assert(file);
    fputw(0xffff, file);
    fput_header(video_offset_1, NELEMS(bitmap_data_1), file);
    for (size_t i = 0; i < NELEMS(bitmap_data_1); ++i)
        fputc(bitmap_data_1[i], file);
    fput_header(color_offset_1, NELEMS(color_data_1), file);
    for (size_t i = 0; i < NELEMS(color_data_1); ++i)
        fputc(color_data_1[i], file);
    fput_header(bkgnd_offset_1, NELEMS(bkgnd_data_1), file);
    for (size_t i = 0; i < NELEMS(bkgnd_data_1); ++i)
        fputc(bkgnd_data_1[i], file);
    fput_header(dl_offset_1, NELEMS(display_list_1), file);
    for (size_t i = 0; i < NELEMS(display_list_1); ++i)
        fputc(display_list_1[i], file);
    fput_header(video_offset_2, NELEMS(bitmap_data_2), file);
    for (size_t i = 0; i < NELEMS(bitmap_data_2); ++i)
        fputc(bitmap_data_2[i], file);
    fput_header(color_offset_2, NELEMS(color_data_2), file);
    for (size_t i = 0; i < NELEMS(color_data_2); ++i)
        fputc(color_data_2[i], file);
    fput_header(bkgnd_offset_2, NELEMS(bkgnd_data_2), file);
    for (size_t i = 0; i < NELEMS(bkgnd_data_2); ++i)
        fputc(bkgnd_data_2[i], file);
    fput_header(dl_offset_2, NELEMS(display_list_2), file);
    for (size_t i = 0; i < NELEMS(display_list_2); ++i)
        fputc(display_list_2[i], file);
    fput_header(video_offset_3, NELEMS(bitmap_data_3), file);
    for (size_t i = 0; i < NELEMS(bitmap_data_3); ++i)
        fputc(bitmap_data_3[i], file);
    fput_header(color_offset_3, NELEMS(color_data_3), file);
    for (size_t i = 0; i < NELEMS(color_data_3); ++i)
        fputc(color_data_3[i], file);
    fput_header(bkgnd_offset_3, NELEMS(bkgnd_data_3), file);
    for (size_t i = 0; i < NELEMS(bkgnd_data_3); ++i)
        fputc(bkgnd_data_3[i], file);
    fput_header(dl_offset_3, NELEMS(display_list_3), file);
    for (size_t i = 0; i < NELEMS(display_list_3); ++i)
        fputc(display_list_3[i], file);
    fclose(file);

    return 0;
}
