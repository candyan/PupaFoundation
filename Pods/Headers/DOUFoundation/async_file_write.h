/*
 * async_file_write.h
 * AsyncWriteTest
 *
 * Created by Chongyu Zhu on 27/06/2013.
 * Copyright 2013 Douban Inc. All rights reserved.
 */

#ifndef __async_file_write_h__
#define __async_file_write_h__

#include <sys/types.h>
#include <sys/errno.h>
#include <dispatch/dispatch.h>

typedef void (^async_file_write_block_t)(int succeeded, int err);

__BEGIN_DECLS

void async_file_write_setup(int fd);

void async_file_write(int fd,
                      const void *bytes,
                      size_t length,
                      dispatch_queue_t callback_queue,
                      async_file_write_block_t callback_block);

__END_DECLS

#endif /* __async_file_write_h__ */
