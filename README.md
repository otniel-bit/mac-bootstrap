# Mac Bootstrap

This repository rebuilds the portable part of a Mac: applications and terminal tools. Your personal files remain in Google Drive and are available after signing in through Chrome, while each application synchronizes its own account data.

## What it installs

- Google Chrome, configured as the default browser
- Slack
- ChatGPT, Claude, and Wispr Flow
- Logitech Options+
- Homebrew, Git, GitHub CLI, Node.js, and Railway CLI

Company-specific software such as Self-Service is intentionally excluded because it is normally installed by the company's device-management system.

## Use it on a new Mac

You need an administrator account and an internet connection.

### Finder method

1. Sign in to GitHub in a browser.
2. Download this repository as a ZIP and open it.
3. Double-click `Install.command`.
4. Approve macOS and administrator prompts.
5. If macOS installs Command Line Tools, run `Install.command` again afterward.
6. Sign in to Chrome, open Google Drive on the web, and sign in to the other applications you use.

If macOS blocks the launcher, Control-click `Install.command`, choose **Open**, and confirm.

### Terminal method

For the fastest setup, copy and paste this command into Terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/otniel-bit/mac-bootstrap/main/install.sh | bash
```

Or clone the repository first if you want to inspect or customize it locally:

```bash
git clone https://github.com/otniel-bit/mac-bootstrap.git
cd mac-bootstrap
./bootstrap.sh
```

The setup is idempotent: it can be run again, and already-installed software is skipped. Existing applications are not automatically upgraded during setup.

The public repository must remain free of passwords, API keys, SSH private keys, browser profiles, cookies, and exported application databases.

## Add or remove applications

Search for the Homebrew name of an application:

```bash
brew search --casks "application name"
```

Then edit `Brewfile` and add a line such as:

```ruby
cask "visual-studio-code"
```

Command-line tools use `brew` instead:

```ruby
brew "jq"
```

Test the file without changing the Mac:

```bash
brew bundle check --file ./Brewfile
```

If it reports missing dependencies, that means those applications would be installed on the next run.

## Google Drive workflow

- Open [drive.google.com](https://drive.google.com/) after signing in to Chrome.
- Keep your working documents in Drive rather than scattered through local Downloads or Desktop folders.
- Download only what you need on temporary Macs, then remove the downloaded copies when finished.
- Google Drive is synchronization, not a complete historical backup. Keep version history or an additional backup for irreplaceable files.

## Updating an existing Mac

Pull changes and run setup again:

```bash
git pull
./bootstrap.sh
```

To deliberately upgrade everything listed in `Brewfile`:

```bash
brew bundle upgrade --file ./Brewfile
```

## What is intentionally not automated

- Passwords and authentication tokens
- Apple Account or Google sign-in
- Security and privacy permissions that macOS requires you to approve
- Company-managed applications
- Entire `~/Library` application-data folders

Those boundaries make the setup portable without putting account access or fragile machine-specific state in GitHub.
