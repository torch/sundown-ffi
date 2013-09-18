local ffi = require 'ffi'

ffi.cdef[[

struct sdhtml_renderopt {
	struct {
		int header_count;
		int current_level;
		int level_offset;
	} toc_data;

	unsigned int flags;

	/* extra callbacks */
	void (*link_attributes)(struct sd_buf *ob, const struct sd_buf *url, void *self);
};

typedef enum {
	HTML_SKIP_HTML = (1 << 0),
	HTML_SKIP_STYLE = (1 << 1),
	HTML_SKIP_IMAGES = (1 << 2),
	HTML_SKIP_LINKS = (1 << 3),
	HTML_EXPAND_TABS = (1 << 4),
	HTML_SAFELINK = (1 << 5),
	HTML_TOC = (1 << 6),
	HTML_HARD_WRAP = (1 << 7),
	HTML_USE_XHTML = (1 << 8),
	HTML_ESCAPE = (1 << 9),
} sdhtml_render_mode;

typedef enum {
	HTML_TAG_NONE = 0,
	HTML_TAG_OPEN,
	HTML_TAG_CLOSE,
} sdhtml_tag;

int sdhtml_is_tag(const uint8_t *tag_data, size_t tag_size, const char *tagname);

void sdhtml_renderer(struct sd_callbacks *callbacks, struct sdhtml_renderopt *options_ptr, unsigned int render_flags);

void sdhtml_toc_renderer(struct sd_callbacks *callbacks, struct sdhtml_renderopt *options_ptr);

void sdhtml_smartypants(struct sd_buf *ob, const uint8_t *text, size_t size);

]]
