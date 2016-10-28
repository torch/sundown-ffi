/*
 * Copyright (c) 2008, Natacha Porté
 * Copyright (c) 2011, Vicent Martí
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#ifndef BUFFER_H__
#define BUFFER_H__

#include <stddef.h>
#include <stdarg.h>
#include <stdint.h>

#ifdef _WIN32
#define SD_EXPORT __declspec(dllexport)
#else
#define SD_EXPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif

#if defined(_MSC_VER)
#define __attribute__(x)
#define inline
#endif

typedef enum {
	BUF_OK = 0,
	BUF_ENOMEM = -1,
} sd_buferror_t;

/* struct sd_buf: character array buffer */
struct sd_buf {
	uint8_t *data;		/* actual character data */
	size_t size;	/* size of the string */
	size_t asize;	/* allocated size (0 = volatile buffer) */
	size_t unit;	/* reallocation unit size (0 = read-only buffer) */
};

/* CONST_BUF: global buffer from a string litteral */
#define BUF_STATIC(string) \
	{ (uint8_t *)string, sizeof string -1, sizeof string, 0, 0 }

/* VOLATILE_BUF: macro for creating a volatile buffer on the stack */
#define BUF_VOLATILE(strname) \
	{ (uint8_t *)strname, strlen(strname), 0, 0, 0 }

/* BUFPUTSL: optimized bufputs of a string litteral */
#define BUFPUTSL(output, literal) \
	sd_bufput(output, literal, sizeof literal - 1)

/* bufgrow: increasing the allocated size to the given value */
SD_EXPORT int sd_bufgrow(struct sd_buf *, size_t);

/* bufnew: allocation of a new buffer */
SD_EXPORT struct sd_buf *sd_bufnew(size_t) __attribute__ ((malloc));

/* bufnullterm: NUL-termination of the string array (making a C-string) */
SD_EXPORT const char *sd_bufcstr(struct sd_buf *);

/* bufprefix: compare the beginning of a buffer with a string */
SD_EXPORT int sd_bufprefix(const struct sd_buf *buf, const char *prefix);

/* bufput: appends raw data to a buffer */
SD_EXPORT void sd_bufput(struct sd_buf *, const void *, size_t);

/* bufputs: appends a NUL-terminated string to a buffer */
SD_EXPORT void sd_bufputs(struct sd_buf *, const char *);

/* bufputc: appends a single char to a buffer */
SD_EXPORT void sd_bufputc(struct sd_buf *, int);

/* bufrelease: decrease the reference count and free the buffer if needed */
SD_EXPORT void sd_bufrelease(struct sd_buf *);

/* bufreset: frees internal data of the buffer */
SD_EXPORT void sd_bufreset(struct sd_buf *);

/* bufslurp: removes a given number of bytes from the head of the array */
SD_EXPORT void sd_bufslurp(struct sd_buf *, size_t);

/* bufprintf: formatted printing to a buffer */
SD_EXPORT void sd_bufprintf(struct sd_buf *, const char *, ...) __attribute__ ((format (printf, 2, 3)));

#ifdef __cplusplus
}
#endif

#endif
