PREFIX ?= /usr
DESTDIR ?=
LIBDIR ?= $(PREFIX)/lib
SYSTEM_EXTENSION_DIR ?= $(LIBDIR)/password-store/extensions

all:
	@echo "pass-csv"
	@echo ""
	@echo "To install execute \"make install\"."

install:
	@install -v -d "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/"
	@install -v -m0755 src/csv.bash "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/csv.bash"
	@echo
	@echo "pass-csv was succesfully installed"
	@echo

uninstall:
	@rm -vrf \
		"$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/csv.bash"

lint:
	shellcheck -s bash src/csv.bash

.PHONY: install uninstall lint