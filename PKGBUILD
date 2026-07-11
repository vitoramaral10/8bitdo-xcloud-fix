# Maintainer: Vitor Amaral <vitor.amaral10@gmail.com>
pkgname=8bitdo-xcloud-fix
pkgver=1.0.0
pkgrel=1
pkgdesc="Emula um Xbox 360 (xboxdrv) para o 8BitDo Ultimate 2 — corrige mapeamento e vibração no Xbox Cloud Gaming, Steam/Proton e emuladores"
arch=('any')
url="https://github.com/vitoramaral10/8bitdo-xcloud-fix"
license=('MIT')
depends=('xboxdrv' 'systemd')
backup=('etc/8bitdo-xcloud.conf')
install="${pkgname}.install"

# Pacote construído a partir da árvore local (rode makepkg dentro do repositório).
package() {
	make -C "${startdir}" DESTDIR="${pkgdir}" PREFIX=/usr install
}
