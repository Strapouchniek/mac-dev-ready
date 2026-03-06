# Mac Dev Ready

One-command setup that installs everything you need to use **Cursor** and create **Pull Requests** on GitHub — no technical knowledge required.

## How to use

Open **Terminal** on your Mac and paste this command:

```bash
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Strapouchniek/mac-dev-ready/main/install.sh)"
```

That's it. The script will guide you through every step.

> **Don't know how to open Terminal?** Press `Cmd + Space`, type `Terminal`, press Enter.

> **On a Sanofi Mac?** The script will detect if you need to elevate your privileges and guide you automatically.

## What gets installed

| # | Tool | What it does |
|---|------|--------------|
| 1 | Xcode Command Line Tools | Apple developer essentials |
| 2 | Homebrew | Lets you install developer tools easily |
| 3 | Git | Tracks changes in your code |
| 4 | Node.js | Runs JavaScript (needed by many tools) |
| 5 | Oh My Zsh | Makes your terminal nicer to use |

## Requirements

- A Mac running **macOS Sonoma (14) or later**
- An internet connection
- Admin rights (the script will tell you if you don't have them)

## FAQ

**Do I need a GitHub account?**
No. The command above works without any account.

**What if some tools are already installed?**
The script detects what you already have, skips what's up to date, and upgrades what's outdated.

**Will it break my existing settings?**
No. Git identity (`user.name`, `user.email`) is left untouched if already configured.

**Can I run it again?**
Yes, as many times as you want. It only installs or upgrades what's needed.

**My Terminal closed when I elevated my privileges!**
That's expected on managed Macs. The script prepared iTerm2 for you — open it (Spotlight: `Cmd + Space` → `iTerm`) and paste the command shown on screen.

---

## For contributors

### Run from a local clone

```bash
git clone https://github.com/Strapouchniek/mac-dev-ready.git
cd mac-dev-ready
zsh setup.sh
```

### Project structure

```
mac-dev-ready/
├── install.sh         ← bootstrap: downloads everything, runs setup.sh
├── setup.sh           ← main entry point
└── modules/
    ├── utils.sh       ← colors, logging, error handling
    ├── admin.sh       ← admin rights check, iTerm2 migration
    ├── xcode.sh       ← Xcode CLT installer
    ├── homebrew.sh    ← Homebrew installer
    ├── git.sh         ← Git install + config
    ├── node.sh        ← Node.js installer
    └── omz.sh         ← Oh My Zsh installer
```

### Installation order

The tools are installed in sequence — each depends on the previous:

1. **Xcode CLT** → required by Homebrew and Git
2. **Homebrew** → installs Git and Node.js
3. **Git** → installed via Homebrew
4. **Node.js** → installed via Homebrew
5. **Oh My Zsh** → modifies `.zshrc`, so goes last

### Limitations

Homebrew requires **macOS Sonoma (14) or later**. The script checks this at startup and exits with a clear message if the requirement is not met.
