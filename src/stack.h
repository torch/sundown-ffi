#ifndef STACK_H__
#define STACK_H__

#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

struct sd_stack {
	void **item;
	size_t size;
	size_t asize;
};

void sd_stack_free(struct sd_stack *);
int sd_stack_grow(struct sd_stack *, size_t);
int sd_stack_init(struct sd_stack *, size_t);

int sd_stack_push(struct sd_stack *, void *);

void *sd_stack_pop(struct sd_stack *);
void *sd_stack_top(struct sd_stack *);

#ifdef __cplusplus
}
#endif

#endif
