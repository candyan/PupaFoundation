#import "NSData+CocoaDevUsersAdditions.h"
#include <zlib.h>

// Copy Right : http://cocoadev.com/
// Wiki : http://cocoadev.com/wiki/NSDataCategory

@implementation NSData (NSDataExtension)

// Returns range [start, null byte), or (NSNotFound, 0).
- (NSRange) rangeOfNullTerminatedBytesFrom:(int)start
{
	const Byte *pdata = [self bytes];
	int len = [self length];
	if (start < len)
	{
		const Byte *end = memchr (pdata + start, 0x00, len - start);
		if (end != NULL) return NSMakeRange (start, end - (pdata + start));
	}
	return NSMakeRange (NSNotFound, 0);
}

#define FinishBlock(X)  (*code_ptr = (X),   code_ptr = dst++,   code = 0x01)
- (NSData *) encodeCOBS
{
	if ([self length] == 0) return self;
  
	NSMutableData *encoded = [NSMutableData dataWithLength:([self length] + [self length] / 254 + 1)];
	unsigned char *dst = [encoded mutableBytes];
	const unsigned char *ptr = [self bytes];
	unsigned long length = [self length];
	const unsigned char *end = ptr + length;
	unsigned char *code_ptr = dst++;
	unsigned char code = 0x01;
	while (ptr < end)
	{
		if (*ptr == 0) FinishBlock(code);
		else
		{
			*dst++ = *ptr;
			code++;
			if (code == 0xFF) FinishBlock(code);
		}
		ptr++;
	}
	FinishBlock(code);
  
	[encoded setLength:((Byte *)dst - (Byte *)[encoded mutableBytes])];
	return [NSData dataWithData:encoded];
}


- (NSData *) decodeCOBS
{
	if ([self length] == 0) return self;

	const Byte *ptr = [self bytes];
	unsigned length = [self length];
	NSMutableData *decoded = [NSMutableData dataWithLength:length];
	Byte *dst = [decoded mutableBytes];
	Byte *basedst = dst;

	const unsigned char *end = ptr + length;
	while (ptr < end)
	{
		int i, code = *ptr++;
		for (i=1; i<code; i++) *dst++ = *ptr++;
		if (code < 0xFF) *dst++ = 0;
	}

	[decoded setLength:(dst - basedst)];
	return [NSData dataWithData:decoded];
}

- (NSData *)zlibInflate
{
	if ([self length] == 0) return self;

	unsigned full_length = [self length];
	unsigned half_length = [self length] / 2;

	NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
	BOOL done = NO;
	int status;

	z_stream strm;
	strm.next_in = (Bytef *)[self bytes];
	strm.avail_in = [self length];
	strm.total_out = 0;
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;

	if (inflateInit (&strm) != Z_OK) return nil;

	while (!done)
	{
		// Make sure we have enough room and reset the lengths.
		if (strm.total_out >= [decompressed length])
			[decompressed increaseLengthBy: half_length];
		strm.next_out = [decompressed mutableBytes] + strm.total_out;
		strm.avail_out = [decompressed length] - strm.total_out;

		// Inflate another chunk.
		status = inflate (&strm, Z_SYNC_FLUSH);
		if (status == Z_STREAM_END) done = YES;
		else if (status != Z_OK) break;
	}
	if (inflateEnd (&strm) != Z_OK) return nil;

	// Set real length.
	if (done)
	{
		[decompressed setLength: strm.total_out];
		return [NSData dataWithData: decompressed];
	}
	else return nil;
}

- (NSData *)zlibDeflate
{
	if ([self length] == 0) return self;
	
	z_stream strm;

	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.opaque = Z_NULL;
	strm.total_out = 0;
	strm.next_in=(Bytef *)[self bytes];
	strm.avail_in = [self length];

	// Compresssion Levels:
	//   Z_NO_COMPRESSION
	//   Z_BEST_SPEED
	//   Z_BEST_COMPRESSION
	//   Z_DEFAULT_COMPRESSION

	if (deflateInit(&strm, Z_DEFAULT_COMPRESSION) != Z_OK) return nil;

	NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chuncks for expansion

	do {

		if (strm.total_out >= [compressed length])
			[compressed increaseLengthBy: 16384];
		
		strm.next_out = [compressed mutableBytes] + strm.total_out;
		strm.avail_out = [compressed length] - strm.total_out;
		
		deflate(&strm, Z_FINISH);  
		
	} while (strm.avail_out == 0);
	
	deflateEnd(&strm);
	
	[compressed setLength: strm.total_out];
	return [NSData dataWithData: compressed];
}

- (NSData *)gzipInflate
{
	if ([self length] == 0) return self;
	
	unsigned full_length = [self length];
	unsigned half_length = [self length] / 2;
	
	NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
	BOOL done = NO;
	int status;
	
	z_stream strm;
	strm.next_in = (Bytef *)[self bytes];
	strm.avail_in = [self length];
	strm.total_out = 0;
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	
	if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
	while (!done)
	{
		// Make sure we have enough room and reset the lengths.
		if (strm.total_out >= [decompressed length])
			[decompressed increaseLengthBy: half_length];
		strm.next_out = [decompressed mutableBytes] + strm.total_out;
		strm.avail_out = [decompressed length] - strm.total_out;
		
		// Inflate another chunk.
		status = inflate (&strm, Z_SYNC_FLUSH);
		if (status == Z_STREAM_END) done = YES;
		else if (status != Z_OK) break;
	}
	if (inflateEnd (&strm) != Z_OK) return nil;
	
	// Set real length.
	if (done)
	{
		[decompressed setLength: strm.total_out];
		return [NSData dataWithData: decompressed];
	}
	else return nil;
}

- (NSData *)gzipDeflate
{
	if ([self length] == 0) return self;
	
	z_stream strm;
	
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.opaque = Z_NULL;
	strm.total_out = 0;
	strm.next_in=(Bytef *)[self bytes];
	strm.avail_in = [self length];
	
	// Compresssion Levels:
	//   Z_NO_COMPRESSION
	//   Z_BEST_SPEED
	//   Z_BEST_COMPRESSION
	//   Z_DEFAULT_COMPRESSION
	
	if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
	
	NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chunks for expansion
	
	do {
		
		if (strm.total_out >= [compressed length])
			[compressed increaseLengthBy: 16384];
		
		strm.next_out = [compressed mutableBytes] + strm.total_out;
		strm.avail_out = [compressed length] - strm.total_out;
		
		deflate(&strm, Z_FINISH);  
		
	} while (strm.avail_out == 0);
	
	deflateEnd(&strm);
	
	[compressed setLength: strm.total_out];
	return [NSData dataWithData:compressed];
}

@end