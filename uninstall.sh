#!/bin/sh
# Desinstalador do 8bitdo-xcloud-fix (instalação via install.sh).
# Uso:  sudo ./uninstall.sh
set -eu

if [ "$(id -u)" -ne 0 ]; then
	echo "Rode como root:  sudo ./uninstall.sh" >&2
	exit 1
fi

echo ">> Parando e desabilitando o serviço..."
systemctl disable --now 8bitdo-xcloud 2>/dev/null || true

echo ">> Removendo arquivos..."
rm -f /usr/bin/8bitdo-xcloud-daemon
rm -f /usr/lib/systemd/system/8bitdo-xcloud.service
rm -f /usr/lib/udev/rules.d/99-8bitdo-xcloud.rules
rm -f /usr/lib/modules-load.d/8bitdo-xcloud.conf

systemctl daemon-reload
udevadm control --reload-rules 2>/dev/null || true

echo ">> Config /etc/8bitdo-xcloud.conf preservada (remova manualmente se quiser)."
echo ">> Feito."
