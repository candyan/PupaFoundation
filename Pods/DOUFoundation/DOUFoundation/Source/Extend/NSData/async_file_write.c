/*
 * async_file_write.c
 * AsyncWriteTest
 *
 * Created by Chongyu Zhu on 27/06/2013.
 * Copyright 2013 Douban Inc. All rights reserved.
 */

#include "async_file_write.h"
#include <assert.h>
#include <stdint.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <Block.h>

void async_file_write_setup(int fd)
{
  int flags;

  assert(fd >= 0);

  flags = fcntl(fd, F_GETFL);
  if (flags == -1) {
    return;
  }

  flags |= O_NONBLOCK;
  fcntl(fd, F_SETFL, flags);
}

void async_file_write(int fd,
                      const void *bytes,
                      size_t length,
                      dispatch_queue_t callback_queue,
                      async_file_write_block_t callback_block)
{
  dispatch_source_t source;
  __block size_t offset = 0;

  assert(fd >= 0);
  assert(bytes != NULL);
  assert(length > 0);
  assert(callback_queue != NULL);
  assert(callback_block != NULL);

  __block async_file_write_block_t _callback_block = Block_copy(callback_block);

  source = dispatch_source_create(DISPATCH_SOURCE_TYPE_WRITE,
                                  (uintptr_t)fd,
                                  0,
                                  dispatch_get_main_queue());

  dispatch_source_set_event_handler(source, ^{
    ssize_t bytes_written;

    if (offset >= length) {
      dispatch_async(callback_queue, ^{
        _callback_block(1, 0);
      });

      dispatch_source_cancel(source);
      return;
    }

    do {
      bytes_written = write(fd,
                            (const uint8_t *)bytes + offset,
                            length - offset);
    } while (bytes_written == -1 &&
             (errno == EAGAIN ||
              errno == EINTR));

    if (bytes_written == -1) {
      int err = errno;
      dispatch_async(callback_queue, ^{
        _callback_block(0, err);
      });

      dispatch_source_cancel(source);
      return;
    }

    offset += bytes_written;
  });

  dispatch_source_set_cancel_handler(source, ^{
    dispatch_release(source);
    Block_release(_callback_block);
  });

  dispatch_resume(source);
}
