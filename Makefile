# Instalação com suporte a DESTDIR/PREFIX (usado pelo PKGBUILD e pelo install.sh).
DESTDIR ?=
PREFIX  ?= /usr
SYSTEMD_DIR ?= $(PREFIX)/lib/systemd/system
UDEV_DIR    ?= $(PREFIX)/lib/udev/rules.d

.PHONY: install uninstall

install:
	install -Dm755 bin/8bitdo-xcloud-daemon        $(DESTDIR)$(PREFIX)/bin/8bitdo-xcloud-daemon
	install -Dm644 systemd/8bitdo-xcloud.service   $(DESTDIR)$(SYSTEMD_DIR)/8bitdo-xcloud.service
	install -Dm644 udev/99-8bitdo-xcloud.rules     $(DESTDIR)$(UDEV_DIR)/99-8bitdo-xcloud.rules
	install -Dm644 config/8bitdo-xcloud.conf       $(DESTDIR)/etc/8bitdo-xcloud.conf
	install -Dm644 README.md                       $(DESTDIR)$(PREFIX)/share/doc/8bitdo-xcloud-fix/README.md

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/8bitdo-xcloud-daemon
	rm -f $(DESTDIR)$(SYSTEMD_DIR)/8bitdo-xcloud.service
	rm -f $(DESTDIR)$(UDEV_DIR)/99-8bitdo-xcloud.rules
	rm -f $(DESTDIR)$(PREFIX)/share/doc/8bitdo-xcloud-fix/README.md
	@echo "Config /etc/8bitdo-xcloud.conf preservada (remova manualmente se quiser)."
