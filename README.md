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

## deployment model

as a flake that you can pick parts from.

headless. not a full gui blabla experience

I personally run it on a headless vm.

SSH into it with x enabled -- meaning i can still run gui tools no problemo

## arsenal/binary structure

rather than using the weird, hard to remember paths used by systems such as kali linux we use a mneomic path:

```
/arsenal
/arsenal/networking/win/ligolo-agent64.exe
/arsenal/networking/lin/ligolo-agent64.exe
```

You'll find the binaries in `/arsenal/networking/win/ligolo-agent64.exe` blabla.

More packages will be added as the community suggests them, or I personally add 'em.

### pre-built binaries

since nix runs on a \*nix system (llinux!!) we can't easily build binaries for windows (logic eh?).
meaning that some packages such as mimikatz, rubeus and so forth depends on a swappable artifact repo.

these packages can be enabled/disabled with a `allowPreBuilt=true/false` flag.

### artifact repo

Set the variable to point to ur own artifact repo.
Otherwise we provide a default one.
Do note however that this come with OPSEC risks (do you trust a self proclaimed red teamers pre-built binaries?...)

## vpn management

also managed declaratively...

TODO:

## todo

- how do we build binaries and where do we host em?
- a file server/artifact repo??
- users should be able to somehow build the binaries from source themselves...
- the whole arsenal structure is a fkn mess rn
- find a way to somehow package a windows build server?...

## opsec

something im working on..
