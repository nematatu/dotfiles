# Repository Guidelines

## プロジェクト構成とモジュール
このリポジトリはNeovim設定を管理します。エントリーポイントは`init.lua`でlazy.nvimを自動取得し、共通設定とプラグイン読み込みを束ねます。基本設定は`lua/base.lua`と`lua/options.lua`、自動コマンドは`lua/autocmds.lua`、キーマップは`lua/keymaps.lua`、プラグイン個別設定は`lua/plugins/<name>.lua`に配置してください。

## 依存関係とプラグイン管理
lazy.nvimのインポート定義は`lua/config/lazy.lua`に集約しています。`lazy-lock.json`でバージョンを固定するため、更新差分を確認して必要な変更のみコミットし、`:Lazy`での手動操作はPRに記録してください。

## ビルド・テスト・開発コマンド
- `nvim --headless "+Lazy sync" +qa`: プラグインを同期して初期化します。
- `nvim --headless "+Lazy check" +qa`: 依存関係の欠損を検出します。
- `nvim --clean -u init.lua`: 最小構成で起動し競合を切り分けます。
作業前後に実行し、主要ログをPRへ添付してください。

## コーディングスタイルと命名
Luaは`shiftwidth=4`/`tabstop=2`/`expandtab`を既定としスペースインデントを使用します。キーマップや自動コマンドは`vim.api.nvim_set_keymap`と`desc`付きの既存方針に揃え、責務ごとにファイルを分けてください。フォーマットはnull-ls経由の`clang_format`と`biome`、Lua向けには`stylua --check lua/`で確認してください。

## テストガイドライン
自動テストは未導入のため、Neovimヘッドレスコマンドで挙動を検証します。プラグイン更新後は`nvim --headless "+Lazy sync" +qa`を再実行し、`:checkhealth`で警告がないか確かめます。LSPの変更では`:Mason`でインストール状況を点検し、LuaとTypeScriptファイルで補完と診断を手動確認してください。

## コミットとプルリク
コミットメッセージは`feat: 説明`や`fix: 説明`などConventional Commitsに従い、必要に応じて日本語で補足してください。PRには変更概要、再現手順、実行したコマンド、関連Issueや資料を記載します。UIやキーマップに影響する場合はスクリーンショットや割当一覧を添え、互換性上の注意点をREADMEまたはPR本文で共有してください。

## セキュリティと環境設定
APIキーやトークンは設定ファイルに直接書かず、環境変数またはローカル専用ファイルで管理してください。共有環境で検証する際は`nvim --clean -u init.lua`を利用し、個人向けプラグインが混ざらないよう確認しましょう。
