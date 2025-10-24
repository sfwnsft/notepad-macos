/*
 * Simple console Notepad in C
 * Features:
 * - Create new text buffer
 * - Open existing file (:e filename)
 * - Append/modify by typing lines
 * - Commands (enter on a line starting with ':'):
 *     :w [filename]   - save (use current filename if omitted)
 *     :wq [filename]  - save and quit editor
 *     :q              - quit editor (asks if unsaved)
 *     :p              - print buffer
 *     :e filename     - open another file (replaces buffer)
 *     :help or :h     - show help
 * - Main menu supports New, Open, Quit
 *
 * Build:
 *   gcc -std=c11 -Wall -Wextra -o notepad test.c
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

typedef struct {
	char *filename;    /* current filename or NULL */
	char *buf;         /* content buffer, NUL-terminated */
	size_t len;        /* current length (not including NUL) */
	int modified;      /* non-zero if buffer modified since last save */
} Notepad;

static void init_notepad(Notepad *n) {
	n->filename = NULL;
	n->buf = malloc(1);
	if (!n->buf) { perror("malloc"); exit(1); }
	n->buf[0] = '\0';
	n->len = 0;
	n->modified = 0;
}

static void free_notepad(Notepad *n) {
	free(n->filename);
	free(n->buf);
}

static int save_file(Notepad *n, const char *filename) {
	const char *fname = filename ? filename : n->filename;
	if (!fname) {
		fprintf(stderr, "No filename specified. Use :w filename\n");
		return -1;
	}
	FILE *f = fopen(fname, "wb");
	if (!f) { perror("fopen"); return -1; }
	size_t written = fwrite(n->buf, 1, n->len, f);
	if (written != n->len) {
		perror("fwrite"); fclose(f); return -1;
	}
	fclose(f);
	free(n->filename);
	n->filename = strdup(fname);
	n->modified = 0;
	printf("Saved %zu bytes to '%s'\n", written, n->filename);
	return 0;
}

static int load_file(Notepad *n, const char *filename) {
	FILE *f = fopen(filename, "rb");
	if (!f) { perror("fopen"); return -1; }
	if (fseek(f, 0, SEEK_END) != 0) { perror("fseek"); fclose(f); return -1; }
	long sz = ftell(f);
	if (sz < 0) sz = 0;
	rewind(f);
	char *buf = malloc((size_t)sz + 1);
	if (!buf) { perror("malloc"); fclose(f); return -1; }
	size_t r = fread(buf, 1, (size_t)sz, f);
	if (r != (size_t)sz) {
		if (ferror(f)) { perror("fread"); free(buf); fclose(f); return -1; }
	}
	buf[r] = '\0';
	fclose(f);
	free(n->buf);
	n->buf = buf;
	n->len = r;
	free(n->filename);
	n->filename = strdup(filename);
	n->modified = 0;
	printf("Opened '%s' (%zu bytes)\n", n->filename, n->len);
	return 0;
}

static int append_text(Notepad *n, const char *text) {
	size_t add = strlen(text);
	size_t newlen = n->len + add;
	char *nb = realloc(n->buf, newlen + 1);
	if (!nb) { perror("realloc"); return -1; }
	n->buf = nb;
	memcpy(n->buf + n->len, text, add);
	n->len = newlen;
	n->buf[n->len] = '\0';
	n->modified = 1;
	return 0;
}

static void print_help_editor(void) {
	puts("Editor commands (type on a line by itself):");
	puts(":w [filename]   - save (use current filename if omitted)");
	puts(":wq [filename]  - save and quit editor");
	puts(":q              - quit editor (asks if unsaved)");
	puts(":p              - print buffer to screen");
	puts(":e filename     - open another file (replaces buffer)");
	puts(":h or :help     - show this help");
}

static void editor_loop(Notepad *n) {
	char *line = NULL;
	size_t linecap = 0;
	ssize_t linelen;

	printf("Entering editor mode. Type lines; commands start with ':' on their own line. Use :help for commands.\n");
	while (1) {
		printf("> ");
		fflush(stdout);
		linelen = getline(&line, &linecap, stdin);
		if (linelen < 0) {
			/* EOF (Ctrl+D) */
			putchar('\n');
			if (n->modified) {
				printf("Buffer modified. Use :w filename to save, or :q to quit without saving.\n");
				continue;
			}
			break;
		}
		/* Remove '\r' if present (for safety) */
		if (linelen > 0 && line[linelen-1] == '\n') {
			/* keep newline as part of text */
		}

		if (line[0] == ':' ) {
			/* command */
			char *cmd = strtok(line + 1, " \t\n");
			if (!cmd) continue;
			if (strcmp(cmd, "w") == 0) {
				char *arg = strtok(NULL, "\n");
				if (arg) {
					/* trim leading spaces */
					while (*arg && isspace((unsigned char)*arg)) arg++;
					if (*arg) save_file(n, arg);
					else save_file(n, NULL);
				} else save_file(n, NULL);
			} else if (strcmp(cmd, "wq") == 0) {
				char *arg = strtok(NULL, "\n");
				if (arg) {
					while (*arg && isspace((unsigned char)*arg)) arg++;
					if (*arg) save_file(n, arg);
					else save_file(n, NULL);
				} else save_file(n, NULL);
				break;
			} else if (strcmp(cmd, "q") == 0) {
				if (n->modified) {
					printf("Buffer modified. Quit without saving? (y/N): ");
					fflush(stdout);
					int c = getchar();
					while (c != EOF && c != '\n') {
						if (c == 'y' || c == 'Y') { free(line); return; }
						break;
					}
					/* consume rest of line */
					int ch;
					while ((ch = getchar()) != EOF && ch != '\n') {}
					continue;
				}
				break;
			} else if (strcmp(cmd, "p") == 0) {
				if (n->len == 0) puts("(empty)");
				else fwrite(n->buf, 1, n->len, stdout);
				putchar('\n');
			} else if (strcmp(cmd, "e") == 0) {
				char *arg = strtok(NULL, "\n");
				if (!arg) { puts("Usage: :e filename"); }
				else {
					while (*arg && isspace((unsigned char)*arg)) arg++;
					if (*arg) {
						if (n->modified) {
							printf("Buffer modified. Opening another file will discard unsaved changes. Continue? (y/N): ");
							fflush(stdout);
							int c = getchar();
							while (c != EOF && c != '\n') {
								if (c == 'y' || c == 'Y') break;
								break;
							}
							int ch;
							while ((ch = getchar()) != EOF && ch != '\n') {}
						}
						load_file(n, arg);
					}
				}
			} else if (strcmp(cmd, "h") == 0 || strcmp(cmd, "help") == 0) {
				print_help_editor();
			} else {
				printf("Unknown command: %s\n", cmd);
			}
		} else {
			/* regular text line -> append as-is */
			if (append_text(n, line) != 0) {
				fprintf(stderr, "Failed to append text\n");
				break;
			}
		}
	}

	free(line);
}

static void show_main_menu(void) {
	puts("\nSimple Notepad");
	puts("1) New file");
	puts("2) Open file");
	puts("3) Quit");
}

int main(void) {
	Notepad n;
	init_notepad(&n);

	char *line = NULL;
	size_t cap = 0;
	ssize_t len;

	while (1) {
		show_main_menu();
		printf("Choose option: "); fflush(stdout);
		len = getline(&line, &cap, stdin);
		if (len <= 0) break;
		int choice = atoi(line);
		if (choice == 1) {
			/* New file: clear buffer */
			free(n.buf);
			n.buf = malloc(1);
			if (!n.buf) { perror("malloc"); break; }
			n.buf[0] = '\0'; n.len = 0; free(n.filename); n.filename = NULL; n.modified = 0;
			editor_loop(&n);
		} else if (choice == 2) {
			printf("Enter filename to open: "); fflush(stdout);
			if (getline(&line, &cap, stdin) <= 0) break;
			/* trim newline */
			char *nl = strchr(line, '\n'); if (nl) *nl = '\0';
			if (line[0] == '\0') { puts("No filename provided."); continue; }
			if (load_file(&n, line) == 0) {
				editor_loop(&n);
			}
		} else if (choice == 3) {
			if (n.modified) {
				printf("Buffer modified. Quit anyway? (y/N): "); fflush(stdout);
				int c = getchar();
				while (c != EOF && c != '\n') {
					if (c == 'y' || c == 'Y') { free(line); free_notepad(&n); return 0; }
					break;
				}
				int ch;
				while ((ch = getchar()) != EOF && ch != '\n') {}
				continue;
			}
			break;
		} else {
			puts("Invalid choice.");
		}
	}

	free(line);
	free_notepad(&n);
	puts("Goodbye.");
	return 0;
}
