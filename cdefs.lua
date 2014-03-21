local ffi = require 'ffi'

ffi.cdef[[

typedef enum {
 HOEDOWN_BUF_OK = 0,
 HOEDOWN_BUF_ENOMEM = -1
} hoedown_buferror_t;


struct hoedown_buffer {
 uint8_t *data;
 size_t size;
 size_t asize;
 size_t unit;
};

typedef struct hoedown_buffer hoedown_buffer;
hoedown_buffer *hoedown_buffer_new(size_t unit) __attribute__ ((malloc));
void hoedown_buffer_free(hoedown_buffer *buf);
void hoedown_buffer_reset(hoedown_buffer *buf);
int hoedown_buffer_grow(hoedown_buffer *buf, size_t neosz);
void hoedown_buffer_put(hoedown_buffer *buf, const void *data, size_t len);
void hoedown_buffer_puts(hoedown_buffer *buf, const char *str);
void hoedown_buffer_putc(hoedown_buffer *buf, uint8_t c);
int hoedown_buffer_prefix(const hoedown_buffer *buf, const char *prefix);
void hoedown_buffer_slurp(hoedown_buffer *buf, size_t len);
const char *hoedown_buffer_cstr(hoedown_buffer *buf);
void hoedown_buffer_printf(hoedown_buffer *buf, const char *fmt, ...) __attribute__ ((format (printf, 2, 3)));

enum {
 HOEDOWN_AUTOLINK_SHORT_DOMAINS = (1 << 0)
};

int hoedown_autolink_is_safe(const uint8_t *link, size_t link_len);

size_t hoedown_autolink__www(size_t *rewind_p, hoedown_buffer *link,
 uint8_t *data, size_t offset, size_t size, unsigned int flags);

size_t hoedown_autolink__email(size_t *rewind_p, hoedown_buffer *link,
 uint8_t *data, size_t offset, size_t size, unsigned int flags);

size_t hoedown_autolink__url(size_t *rewind_p, hoedown_buffer *link,
 uint8_t *data, size_t offset, size_t size, unsigned int flags);

enum hoedown_extensions {

 HOEDOWN_EXT_SPACE_HEADERS = (1 << 0),
 HOEDOWN_EXT_TABLES = (1 << 1),
 HOEDOWN_EXT_FENCED_CODE = (1 << 2),
 HOEDOWN_EXT_FOOTNOTES = (1 << 3),


 HOEDOWN_EXT_AUTOLINK = (1 << 4),
 HOEDOWN_EXT_STRIKETHROUGH = (1 << 5),
 HOEDOWN_EXT_UNDERLINE = (1 << 6),
 HOEDOWN_EXT_HIGHLIGHT = (1 << 7),
 HOEDOWN_EXT_QUOTE = (1 << 8),
 HOEDOWN_EXT_SUPERSCRIPT = (1 << 9),


 HOEDOWN_EXT_LAX_SPACING = (1 << 10),
 HOEDOWN_EXT_NO_INTRA_EMPHASIS = (1 << 11),


 HOEDOWN_EXT_DISABLE_INDENTED_CODE = (1 << 12)
};

enum hoedown_listflags {
 HOEDOWN_LIST_ORDERED = (1 << 0),
 HOEDOWN_LI_BLOCK = (1 << 1),
};

enum hoedown_tableflags {
 HOEDOWN_TABLE_ALIGN_LEFT = 1,
 HOEDOWN_TABLE_ALIGN_RIGHT = 2,
 HOEDOWN_TABLE_ALIGN_CENTER = 3,
 HOEDOWN_TABLE_ALIGNMASK = 3,
 HOEDOWN_TABLE_HEADER = 4
};

enum hoedown_autolink {
 HOEDOWN_AUTOLINK_NONE,
 HOEDOWN_AUTOLINK_NORMAL,
 HOEDOWN_AUTOLINK_EMAIL
};

struct hoedown_renderer {

 void *opaque;

 void (*blockcode)(hoedown_buffer *ob, const hoedown_buffer *text, const hoedown_buffer *lang, void *opaque);
 void (*blockquote)(hoedown_buffer *ob, const hoedown_buffer *text, void *opaque);
 void (*blockhtml)(hoedown_buffer *ob,const hoedown_buffer *text, void *opaque);
 void (*header)(hoedown_buffer *ob, const hoedown_buffer *text, int level, void *opaque);
 void (*hrule)(hoedown_buffer *ob, void *opaque);
 void (*list)(hoedown_buffer *ob, const hoedown_buffer *text, unsigned int flags, void *opaque);
 void (*listitem)(hoedown_buffer *ob, const hoedown_buffer *text, unsigned int flags, void *opaque);
 void (*paragraph)(hoedown_buffer *ob, const hoedown_buffer *text, void *opaque);
 void (*table)(hoedown_buffer *ob, const hoedown_buffer *header, const hoedown_buffer *body, void *opaque);
 void (*table_row)(hoedown_buffer *ob, const hoedown_buffer *text, void *opaque);
 void (*table_cell)(hoedown_buffer *ob, const hoedown_buffer *text, unsigned int flags, void *opaque);
 void (*footnotes)(hoedown_buffer *ob, const hoedown_buffer *text, void *opaque);
 void (*footnote_def)(hoedown_buffer *ob, const hoedown_buffer *text, unsigned int num, void *opaque);

 int (*autolink)(hoedown_buffer *ob, const hoedown_buffer *link, enum hoedown_autolink type, void *opaque);
 int (*codespan)(hoedown_buffer *ob, const hoedown_buffer *text, void *opaque);
 int (*double_emphasis)(hoedown_buffer *ob, const hoedown_buffer *text, void *opaque);
 int (*emphasis)(hoedown_buffer *ob, const hoedown_buffer *text, void *opaque);
 int (*underline)(hoedown_buffer *ob, const hoedown_buffer *text, void *opaque);
 int (*highlight)(hoedown_buffer *ob, const hoedown_buffer *text, void *opaque);
 int (*quote)(hoedown_buffer *ob, const hoedown_buffer *text, void *opaque);
 int (*image)(hoedown_buffer *ob, const hoedown_buffer *link, const hoedown_buffer *title, const hoedown_buffer *alt, void *opaque);
 int (*linebreak)(hoedown_buffer *ob, void *opaque);
 int (*link)(hoedown_buffer *ob, const hoedown_buffer *link, const hoedown_buffer *title, const hoedown_buffer *content, void *opaque);
 int (*raw_html_tag)(hoedown_buffer *ob, const hoedown_buffer *tag, void *opaque);
 int (*triple_emphasis)(hoedown_buffer *ob, const hoedown_buffer *text, void *opaque);
 int (*strikethrough)(hoedown_buffer *ob, const hoedown_buffer *text, void *opaque);
 int (*superscript)(hoedown_buffer *ob, const hoedown_buffer *text, void *opaque);
 int (*footnote_ref)(hoedown_buffer *ob, unsigned int num, void *opaque);

 void (*entity)(hoedown_buffer *ob, const hoedown_buffer *entity, void *opaque);
 void (*normal_text)(hoedown_buffer *ob, const hoedown_buffer *text, void *opaque);

 void (*doc_header)(hoedown_buffer *ob, void *opaque);
 void (*doc_footer)(hoedown_buffer *ob, void *opaque);
};

typedef struct hoedown_renderer hoedown_renderer;
struct hoedown_document;
typedef struct hoedown_document hoedown_document;

extern hoedown_document *
hoedown_document_new(
 const hoedown_renderer *renderer,
 unsigned int extensions,
 size_t max_nesting);

extern void
hoedown_document_render(hoedown_document *doc, hoedown_buffer *ob, const uint8_t *document, size_t doc_size);

extern void
hoedown_document_free(hoedown_document *doc);

]]
