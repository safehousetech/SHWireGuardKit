//
//  ringlogger.h
//  SHWireGuardKit
//
//  Created by Abhishek Choudhary on 29/12/23.
//

#ifndef ringlogger_h
#define ringlogger_h

#include <stdio.h>

struct log;
void write_msg_to_log(struct log *log, const char *tag, const char *msg);
int write_log_to_file(const char *file_name, const struct log *input_log);
uint32_t view_lines_from_cursor(const struct log *input_log, uint32_t cursor, void *ctx, void(*)(const char *, uint64_t, void *));
struct log *open_log(const char *file_name);
void close_log(struct log *log);

#endif /* ringlogger_h */
