#!/bin/sh
# Instalador universal (qualquer distro com systemd) do 8bitdo-xcloud-fix.
# Em CachyOS/Arch prefira o pacote:  makepkg -si   (ver README).
# Uso:  sudo ./install.sh
set -eu

if [ "$(id -u)" -ne 0 ]; then
	echo "Rode como root:  sudo ./install.sh" >&2
	exit 1
fi

cd "$(dirname "$0")"

echo ">> Instalando arquivos..."
install -Dm755 bin/8bitdo-xcloud-daemon      /usr/bin/8bitdo-xcloud-daemon
install -Dm644 systemd/8bitdo-xcloud.service /usr/lib/systemd/system/8bitdo-xcloud.service
install -Dm644 udev/99-8bitdo-xcloud.rules   /usr/lib/udev/rules.d/99-8bitdo-xcloud.rules
install -Dm644 modules-load/8bitdo-xcloud.conf /usr/lib/modules-load.d/8bitdo-xcloud.conf

# Preserva a config existente (não sobrescreve personalizações).
if [ -e /etc/8bitdo-xcloud.conf ]; then
	echo ">> /etc/8bitdo-xcloud.conf já existe — mantida."
else
	install -Dm644 config/8bitdo-xcloud.conf /etc/8bitdo-xcloud.conf
fi

echo ">> Carregando módulo uinput (necessário para o controle virtual)..."
modprobe uinput 2>/dev/null || echo ">> AVISO: não consegui carregar o uinput agora; será carregado no próximo boot."

echo ">> Recarregando systemd e udev..."
systemctl daemon-reload
udevadm control --reload-rules 2>/dev/null || true
udevadm trigger 2>/dev/null || true

if ! command -v xboxdrv >/dev/null 2>&1; then
	echo ">> AVISO: xboxdrv não está instalado."
	echo "   CachyOS/Arch:  paru -S xboxdrv     |    Debian/Ubuntu:  sudo apt install xboxdrv"
fi

echo ">> Habilitando e iniciando o serviço..."
systemctl enable --now 8bitdo-xcloud || {
	echo ">> Não foi possível iniciar agora (controle desconectado?). Conecte-o via USB-C/dongle."
}

cat <<'MSG'

Pronto! Verifique com:  systemctl status 8bitdo-xcloud
Teste o mapeamento em:  https://hardwaretester.com/gamepad
(deve aparecer como "Microsoft X-Box 360 pad"; pressione um botão para o xCloud "acordar".)
MSG
