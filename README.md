# Mac Dev Ready

One-command setup script that installs everything a non-technical team member needs to use **Cursor** and create **Pull Requests** on GitHub.

## What gets installed

| # | Tool | Purpose | Status |
|---|------|---------|--------|
| 1 | Xcode Command Line Tools | Apple developer essentials | ✅ Ready |
| 2 | Homebrew | Package manager | ✅ Ready |
| 3 | Git | Version control | ✅ Ready |
| 4 | Node.js | JavaScript runtime | ✅ Ready |
| 5 | Oh My Zsh | Better terminal experience | ✅ Ready |

## Installation order (matters a lot)

The tools above are installed in a specific sequence because each one depends on the previous:

1. **Xcode Command Line Tools** — required by Homebrew and Git
2. **Homebrew** — package manager that installs Git and Node
3. **Git** — installed via Homebrew
4. **Node.js** — installed via Homebrew (or nvm)
5. **Oh My Zsh** — installed last because it modifies `.zshrc`


## Quick start

### Option A — Run locally (recommended for testing)

```bash
cd mac-dev-ready
zsh setup.sh
```

### Option B — Run from GitHub (for sharing with your team)

Once pushed to a **public** GitHub repo, anyone can run this — **no GitHub account needed**:

```bash
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/YOUR_ORG/YOUR_REPO/main/mac-dev-ready/setup.sh)"
```

> Replace `YOUR_ORG/YOUR_REPO` with your actual GitHub repository path.

> **Note:** The remote one-liner currently only works for the local execution path since the modules are loaded from disk. A self-contained remote version will be added later.

## Project structure

```
mac-dev-ready/
├── README.md          ← you are here
├── setup.sh           ← main entry point
└── modules/
    ├── utils.sh       ← colors, logging, error handling
    ├── xcode.sh       ← Xcode CLT installer
    ├── homebrew.sh    ← Homebrew installer
    ├── git.sh         ← Git install + config
    ├── node.sh        ← Node.js installer
    └── omz.sh         ← Oh My Zsh installer
```

## Requirements

- macOS Sonoma (14) or later
- Internet connection
- Admin password (some installers will prompt for it)

## Limitations

**macOS version:** Homebrew — the package manager this script relies on — officially requires **macOS Sonoma (14) or later**. The script checks your macOS version at startup and exits with a clear error message if the requirement is not met. Users on older Macs will need to update via System Settings → General → Software Update before running this script.

## FAQ

**Do users need a GitHub account to run this?**
No. If the repo is public, the raw file URL is accessible to anyone.

**What if Xcode tools are already installed?**
The script detects this and skips the step automatically.

**What if I already have Git or Node.js?**
The script detects existing installations. If there's a system version, it installs the latest via Homebrew for best compatibility. If the Homebrew version is already present, it skips the step.

**Will Git configuration overwrite my existing settings?**
No. If `user.name` and `user.email` are already set in your global Git config, the script leaves them as-is.

**Can I run it multiple times?**
Yes. Every step is idempotent — it checks before installing.
