PREFIX ?= /usr
DESTDIR ?=
LIBDIR ?= $(PREFIX)/lib
SYSTEM_EXTENSION_DIR ?= $(LIBDIR)/password-store/extensions
BASHCOMPDIR ?= /etc/bash_completion.d

all:
	@echo "pass-csv"
	@echo ""
	@echo "To install execute \"make install\"."

install:
	@install -v -d "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/"
	@install -v -m0755 src/csv.bash "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/csv.bash"
	@install -v -d "$(DESTDIR)$(BASHCOMPDIR)/"
	@install -v -m 644 completion/pass-csv.bash.completion  "$(DESTDIR)$(BASHCOMPDIR)/pass-csv"
	@echo
	@echo "pass-csv was succesfully installed"
	@echo

uninstall:
	@rm -vrf \
		"$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/csv.bash" \
		"$(DESTDIR)$(BASHCOMPDIR)/pass-csv"

lint:
	shellcheck -s bash src/csv.bash

.PHONY: install uninstall lint