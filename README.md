# dotfiles

## macOS

```bash
./install.sh
```

## WSL Ubuntu

大学 PC の WSL Ubuntu では、まずこのリポジトリを `~/dotfiles` に置いてから実行します。

```bash
git clone <this-repository-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

このセットアップでは、基本 CLI ツールの導入、GNU Stow による共通 dotfiles のリンク、`mise install`、`zsh` のデフォルトシェル化を行います。

完了後に確認します。

```bash
exec zsh -l
nvidia-smi
gh auth login
```

CUDA Toolkit が必要な場合は、WSL 内に Linux NVIDIA driver を入れず、WSL-Ubuntu 用の CUDA Toolkit だけを入れます。
