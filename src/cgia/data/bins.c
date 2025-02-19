// simple hack to write example_data to separate binary files
// usage (on your PC): gcc bins.c -o bins && ./bins

#include <assert.h>
#include <stdint.h>
#include <stdio.h>

#include "./audio_data.h"
#include "./beast-1.h"
#include "./beast-2.h"
#include "./example_data.h"
#include "./hi-octane_hud.h"
#include "./mascot_bg.h"
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

    file = fopen("mascot_bg.xex", "w");
    assert(file);
    fputw(0xffff, file);
    fput_header(affine_mode_video_offset, NELEMS(pixel_data), file);
    for (size_t i = 0; i < NELEMS(pixel_data); ++i)
        fputc(pixel_data[i], file);
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

    file = fopen("sotb_sprite.xex", "w");
    assert(file);
    fputw(0xffff, file);
    fput_header(0xfffe, 1, file); // change load bank
    fputc(0x01, file);
    fput_header(spr1_offset, NELEMS(spr_bitmap1_data), file);
    for (size_t i = 0; i < NELEMS(spr_bitmap1_data); ++i)
        fputc(spr_bitmap1_data[i], file);
    fput_header(spr2_offset, NELEMS(spr_bitmap2_data), file);
    for (size_t i = 0; i < NELEMS(spr_bitmap2_data); ++i)
        fputc(spr_bitmap2_data[i], file);
    fclose(file);

    file = fopen("hud_layer.xex", "w");
    assert(file);
    fputw(0xffff, file);
    fput_header(video_offset, NELEMS(bitmap_data), file);
    for (size_t i = 0; i < NELEMS(bitmap_data); ++i)
        fputc(bitmap_data[i], file);
    fput_header(color_offset, NELEMS(color_data), file);
    for (size_t i = 0; i < NELEMS(color_data); ++i)
        fputc(color_data[i], file);
    fput_header(bkgnd_offset, NELEMS(bkgnd_data), file);
    for (size_t i = 0; i < NELEMS(bkgnd_data); ++i)
        fputc(bkgnd_data[i], file);
    fput_header(dl_offset, NELEMS(display_list), file);
    for (size_t i = 0; i < NELEMS(display_list); ++i)
        fputc(display_list[i], file);
    fclose(file);

    file = fopen("pwm_samples.xex", "w");
    assert(file);
    fputw(0xffff, file);
    fput_header(0x1000, NELEMS(audio_data), file);
    for (size_t i = 0; i < NELEMS(audio_data); ++i)
        fputc((uint8_t)(128 + (int8_t)audio_data[i]), file);
    fclose(file);

    return 0;
}
