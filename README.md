## Dotfiles

Personal configuration files for my development environment and utilities.

Configuration files tailored to my workflow. Use them as inspiration or starting points for your own dotfiles setup.

### Tooling 🛠️

- **NeoVim**: Complete Neovim configuration with plugins, keymaps, and settings
- **Tmux**: Terminal multiplexer configuration for session management
- **Ghostty**: Modern GPU-accelerated terminal emulator settings
- **Git**: Global Git configuration, aliases, and workflow settings
- **Starship**: Cross-shell prompt configuration for a beautiful command line

### Notes 📝

- **Backup**: Always backup your existing dotfiles before using these configurations
- **OS Compatibility**: These configurations are primarily tested on macOS/Linux
- **Updates**: Configurations are updated regularly as my workflow evolves

### Git Configuration

Use the template file (globally, not just in the current repo).

```sh
git config --global commit.template ~/.gitmessage
```

Open commit messages in NeoVim

```sh
git config --global core.editor nvim
```

#### References

- [How to Write a Git Commit Message](https://chris.beams.io/posts/git-commit/)
- [Using Git Commit Message Templates to Write Better Commit Messages](https://gist.github.com/lisawolderiksen/a7b99d94c92c6671181611be1641c733)
- [Configuring Git and Vim](https://csswizardry.com/2017/03/configuring-git-and-vim/)
