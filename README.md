# 8bitdo-xcloud-fix

Faz o **8BitDo Ultimate 2** ser reconhecido como um **controle de Xbox 360**
no Linux, com **mapeamento correto e vibração (force feedback)** — resolvendo
os problemas de botões/vibração no **Xbox Cloud Gaming (xCloud)**, Steam/Proton
e emuladores.

Empacota, como um serviço `systemd` limpo e instalável, a configuração do
`xboxdrv` descrita [neste tutorial](https://medium.com/@vitor.amaral10).

## O problema

O 8BitDo Ultimate 2 é ótimo, mas no Linux o mapeamento padrão nem sempre agrada
jogos que esperam um Xbox 360, e a vibração costuma não funcionar. A sacada é
rodar o `xboxdrv` com **`--force-feedback`** (vibração) + **`--mimic-xpad`**
(compatibilidade com o driver `xpad` nativo), emulando um Xbox 360 perfeito.

## Requisitos

- Linux com `systemd`
- `xboxdrv`
  - **CachyOS/Arch:** `paru -S xboxdrv` (está no AUR)
  - **Debian/Ubuntu:** `sudo apt install xboxdrv`
- Controle em **modo XInput** (`2dc8:310b`), conectado via **USB-C ou dongle 2.4G**
  (confira com `lsusb | grep -i 2dc8`)

## Instalação

### CachyOS / Arch (recomendado — pacote pacman)

```sh
paru -S xboxdrv                # dependência (AUR)
git clone <este-repo> && cd 8bitdo-xcloud-fix
makepkg -si                    # constrói e instala o pacote
sudo systemctl enable --now 8bitdo-xcloud
```

### Qualquer distro com systemd (instalador universal)

```sh
sudo ./install.sh              # instala arquivos, recarrega systemd/udev e ativa o serviço
```

O instalador já habilita e inicia o serviço. Em Debian/Ubuntu, instale antes o
`xboxdrv` com `sudo apt install xboxdrv`.

## Configuração

Tudo fica em **`/etc/8bitdo-xcloud.conf`** (VID:PID do controle e os mapeamentos).
Depois de editar:

```sh
sudo systemctl restart 8bitdo-xcloud
```

Se o seu controle aparece em outro modo (ex.: DInput `2dc8:6012`), ajuste
`DEVICE_ID` no arquivo.

## Verificando

```sh
systemctl status 8bitdo-xcloud        # deve estar "active (running)"
```

Abra <https://hardwaretester.com/gamepad> e aperte um botão — o dispositivo deve
aparecer como **“Microsoft X-Box 360 pad (045e:028e)”**, com os gatilhos LT/RT
como eixos analógicos e a vibração funcionando.

### Dica: Xbox Cloud Gaming (xCloud)

Mesmo com o serviço rodando, o site do xCloud pode mostrar “Controle
Desconectado”. **Basta apertar qualquer botão (A/B/Start)**: o navegador
“acorda”, reconhece o Xbox 360 emulado e libera o jogo.

## Como funciona

Um serviço `systemd` (`8bitdo-xcloud.service`) roda `/usr/bin/8bitdo-xcloud-daemon`,
que chama o `xboxdrv` com:

- `--detach-kernel-driver` — solta o `xpad` para o xboxdrv assumir o controle
- `--force-feedback` — habilita a vibração
- `--mimic-xpad` — se comporta como o `xpad` nativo (melhora a compatibilidade)
- `--evdev-absmap` / `--evdev-keymap` — mapeiam eixos e botões para o Xbox 360

Uma regra `udev` reinicia o serviço automaticamente quando você conecta o controle.

## Desinstalação

```sh
# via pacote (Arch):
sudo pacman -R 8bitdo-xcloud-fix
# via instalador universal:
sudo ./uninstall.sh
```

## Arquivos instalados

| Arquivo | Destino |
|---|---|
| `bin/8bitdo-xcloud-daemon` | `/usr/bin/8bitdo-xcloud-daemon` |
| `systemd/8bitdo-xcloud.service` | `/usr/lib/systemd/system/8bitdo-xcloud.service` |
| `udev/99-8bitdo-xcloud.rules` | `/usr/lib/udev/rules.d/99-8bitdo-xcloud.rules` |
| `config/8bitdo-xcloud.conf` | `/etc/8bitdo-xcloud.conf` |

## Licença

MIT — veja [LICENSE](LICENSE). Projeto não afiliado à 8BitDo nem à Microsoft.
