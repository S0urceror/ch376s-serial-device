#ifndef __FILESYSTEM_MSX_H
#define __FILESYSTEM_MSX_H

extern const char file_load_error[];
extern const char file_load_success[];
extern const char file_save_error[];
extern const char file_save_success[];

typedef struct _FCB 
{
    uint8_t drive_number;
    uint8_t filename[11];
    uint16_t current_block;
    uint16_t record_size;
    uint32_t file_size;
    uint16_t date;
    uint16_t time;
    uint8_t deviceID;
    uint8_t directory_location;
    uint16_t top_cluster_number;
    uint16_t last_cluster_accessed;
    uint16_t relative_location_from_top_cluster;
    uint8_t current_record;
    uint32_t random_record;
} FCB_structure;

void clear_fcb ();
void reset_fcb ();
uint16_t filesize_fcb ();
void prepare_fcb (char* in_filename);
void memload (uint16_t address, char* in_filename);
void memsave (uint16_t address, uint16_t size, char* in_filename);

#endif // __FILESYSTEM_MSX_H