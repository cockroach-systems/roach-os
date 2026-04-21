██▀███ ▒█████ ▄▄▄ ▄████▄ ██░ ██
▓██ ▒ ██▒▒██▒ ██▒▒████▄ ▒██▀ ▀█ ▓██░ ██▒
▓██ ░▄█ ▒▒██░ ██▒▒██ ▀█▄ ▒▓█ ▄ ▒██▀▀██░
▒██▀▀█▄ ▒██ ██░░██▄▄▄▄██ ▒▓▓▄ ▄██▒░▓█ ░██
░██▓ ▒██▒░ ████▓▒░ ▓█ ▓██▒▒ ▓███▀ ░░▓█▒░██▓
░ ▒▓ ░▒▓░░ ▒░▒░▒░ ▒▒ ▓▒█░░ ░▒ ▒ ░ ▒ ░░▒░▒
═══════════════════════════════════

Because life is too short for apt-get....

## design philosophy

- Bloat = attack surface — nothing is installed without intent
- All tooling is opt-in and source-visible
- Most tools are built from source to enable auditing

> That said — current priority is OSCP completion, so OPSEC is not locked down yet

## quickstart

Add the flake to your NixOS config:

```nix
# flake.nix
inputs.roachos.url = "github:cockroach-systems/roach-os";

# in your nixosSystem modules list
roachos.nixosModules.default
```

Then configure what you need:

```nix
roachos.user = "youruser";

# enable everything
roachos.tools.all.enable = true;

# or pick categories
roachos.tools.active-directory.enable = true;
roachos.tools.networking.enable = true;
roachos.tools.exploitation.enable = true;

# services
roachos.services.sliver.enable = true;
roachos.services.bloodhound.enable = true;
```

## tool categories

| Option | What you get |
|---|---|
| `tools.all` | everything below |
| `tools.cracking` | hydra, john, hashcat |
| `tools.networking` | netcat, socat, wireshark |
| `tools.web-application` | burpsuite, ffuf |
| `tools.database-clients` | database client tools |
| `tools.remote-enumeration` | nmap, netexec |
| `tools.communication` | email and messaging tools |
| `tools.remote-access` | rdp, vnc, winrm |
| `tools.exploitation` | metasploit, exploitdb |
| `tools.active-directory` | kerbrute, impacket, responder, bloodhound-py |
| `tools.programming` | languages for exploit dev |
| `tools.office-tools` | libreoffice |
| `tools.custom-packages` | arsenal, seclists, mimikatz, ligolo-ng, sliver, godpotato, pspy, vulnx |
| `tools.nix-shells` | python and python2 nix-shell environments |
| `tools.other` | miscellaneous tools |

## services

| Option | What you get |
|---|---|
| `services.sliver` | Sliver C2 server (systemd) |
| `services.bloodhound` | BloodHound Community Edition (docker-compose) |

## deployment model

A flake that you can pick parts from. Headless — not a full GUI experience.

I personally run it on a headless VM and SSH into it with X forwarding, meaning I can still run GUI tools no problem.

## arsenal/binary structure

Rather than using the weird, hard to remember paths used by systems such as Kali, we use a mnemonic path:

```
/arsenal
/arsenal/networking/win/ligolo-agent64.exe
/arsenal/networking/lin/ligolo-agent64
```

### pre-built binaries

Since Nix runs on Linux we can't easily cross-compile binaries for Windows. Packages such as mimikatz, rubeus etc. depend on a swappable artifact repo.

These packages can be enabled/disabled with:

```nix
roachos.allowPrebuilt = true;  # default
```

### artifact repo

```nix
roachos.binaryServer = "http://your-server:8080";
```

Set this to point to your own artifact repo. We provide a default, but do note the OPSEC risks — do you trust a self-proclaimed red teamer's pre-built binaries?

## opsec

something i'm working on..
