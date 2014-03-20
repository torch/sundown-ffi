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

#define BUFFER_MAX_ALLOC_SIZE (1024 * 1024 * 16) //16mb

#include "buffer.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

/* MSVC compat */
#if defined(_MSC_VER)
#	define _sd_buf_vsnprintf _vsnprintf
#else
#	define _sd_buf_vsnprintf vsnprintf
#endif

int
sd_bufprefix(const struct sd_buf *sd_buf, const char *prefix)
{
	size_t i;
	assert(sd_buf && sd_buf->unit);

	for (i = 0; i < sd_buf->size; ++i) {
		if (prefix[i] == 0)
			return 0;

		if (sd_buf->data[i] != prefix[i])
			return sd_buf->data[i] - prefix[i];
	}

	return 0;
}

/* sd_bufgrow: increasing the allocated size to the given value */
int
sd_bufgrow(struct sd_buf *sd_buf, size_t neosz)
{
	size_t neoasz;
	void *neodata;

	assert(sd_buf && sd_buf->unit);

	if (neosz > BUFFER_MAX_ALLOC_SIZE)
		return BUF_ENOMEM;

	if (sd_buf->asize >= neosz)
		return BUF_OK;

	neoasz = sd_buf->asize + sd_buf->unit;
	while (neoasz < neosz)
		neoasz += sd_buf->unit;

	neodata = realloc(sd_buf->data, neoasz);
	if (!neodata)
		return BUF_ENOMEM;

	sd_buf->data = neodata;
	sd_buf->asize = neoasz;
	return BUF_OK;
}


/* sd_bufnew: allocation of a new buffer */
struct sd_buf *
sd_bufnew(size_t unit)
{
	struct sd_buf *ret;
	ret = malloc(sizeof (struct sd_buf));

	if (ret) {
		ret->data = 0;
		ret->size = ret->asize = 0;
		ret->unit = unit;
	}
	return ret;
}

/* sd_bufnullterm: NULL-termination of the string array */
const char *
sd_bufcstr(struct sd_buf *sd_buf)
{
	assert(sd_buf && sd_buf->unit);

	if (sd_buf->size < sd_buf->asize && sd_buf->data[sd_buf->size] == 0)
		return (char *)sd_buf->data;

	if (sd_buf->size + 1 <= sd_buf->asize || sd_bufgrow(sd_buf, sd_buf->size + 1) == 0) {
		sd_buf->data[sd_buf->size] = 0;
		return (char *)sd_buf->data;
	}

	return NULL;
}

/* sd_bufprintf: formatted printing to a buffer */
void
sd_bufprintf(struct sd_buf *sd_buf, const char *fmt, ...)
{
	va_list ap;
	int n;

	assert(sd_buf && sd_buf->unit);

	if (sd_buf->size >= sd_buf->asize && sd_bufgrow(sd_buf, sd_buf->size + 1) < 0)
		return;
	
	va_start(ap, fmt);
	n = _sd_buf_vsnprintf((char *)sd_buf->data + sd_buf->size, sd_buf->asize - sd_buf->size, fmt, ap);
	va_end(ap);

	if (n < 0) {
#ifdef _MSC_VER
		va_start(ap, fmt);
		n = _vscprintf(fmt, ap);
		va_end(ap);
#else
		return;
#endif
	}

	if ((size_t)n >= sd_buf->asize - sd_buf->size) {
		if (sd_bufgrow(sd_buf, sd_buf->size + n + 1) < 0)
			return;

		va_start(ap, fmt);
		n = _sd_buf_vsnprintf((char *)sd_buf->data + sd_buf->size, sd_buf->asize - sd_buf->size, fmt, ap);
		va_end(ap);
	}

	if (n < 0)
		return;

	sd_buf->size += n;
}

/* sd_bufput: appends raw data to a buffer */
void
sd_bufput(struct sd_buf *sd_buf, const void *data, size_t len)
{
	assert(sd_buf && sd_buf->unit);

	if (sd_buf->size + len > sd_buf->asize && sd_bufgrow(sd_buf, sd_buf->size + len) < 0)
		return;

	memcpy(sd_buf->data + sd_buf->size, data, len);
	sd_buf->size += len;
}

/* sd_bufputs: appends a NUL-terminated string to a buffer */
void
sd_bufputs(struct sd_buf *sd_buf, const char *str)
{
	sd_bufput(sd_buf, str, strlen(str));
}


/* sd_bufputc: appends a single uint8_t to a buffer */
void
sd_bufputc(struct sd_buf *sd_buf, int c)
{
	assert(sd_buf && sd_buf->unit);

	if (sd_buf->size + 1 > sd_buf->asize && sd_bufgrow(sd_buf, sd_buf->size + 1) < 0)
		return;

	sd_buf->data[sd_buf->size] = c;
	sd_buf->size += 1;
}

/* sd_bufrelease: decrease the reference count and free the buffer if needed */
void
sd_bufrelease(struct sd_buf *sd_buf)
{
	if (!sd_buf)
		return;

	free(sd_buf->data);
	free(sd_buf);
}


/* sd_bufreset: frees internal data of the buffer */
void
sd_bufreset(struct sd_buf *sd_buf)
{
	if (!sd_buf)
		return;

	free(sd_buf->data);
	sd_buf->data = NULL;
	sd_buf->size = sd_buf->asize = 0;
}

/* sd_bufslurp: removes a given number of bytes from the head of the array */
void
sd_bufslurp(struct sd_buf *sd_buf, size_t len)
{
	assert(sd_buf && sd_buf->unit);

	if (len >= sd_buf->size) {
		sd_buf->size = 0;
		return;
	}

	sd_buf->size -= len;
	memmove(sd_buf->data, sd_buf->data + len, sd_buf->size);
}

