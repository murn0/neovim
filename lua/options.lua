local opt = vim.opt

vim.g.mapleader = " " -- リーダーキーを<Space>に設定

vim.scriptencoding = "utf-8"
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.helplang = "ja"
opt.shell = "fish"
opt.swapfile = false
opt.termguicolors = true -- 24bit color

-- 検索ワードに大文字が含まれていない場合は区別しない
-- e.g. 検索ワード:word ヒットする単語: word,Word,WORD
-- 検索ワードに大文字が含まれている場合は区別する
-- e.g. 検索ワード:Word ヒットする単語: Word
opt.ignorecase = true
opt.smartcase = true

opt.inccommand = "split" -- 置換時にプレビューを表示する

-- opt.clipboard = "unnamedplus" -- クリップボードと"+レジスタを共有する

opt.number = true -- 行番号を表示する
opt.relativenumber = true -- 相対行番号を表示する
opt.cursorline = true -- カーソル行をハイライトする
opt.signcolumn = "yes" -- 行番号の横に記号列(signcolumn)を表示する

opt.tabstop = 2 -- 画面上でタブ文字が占める空白文字幅
opt.shiftwidth = 0 -- cindent や autoindent の場合に挿入されるインデントの幅（0の場合tabstopに従う）
opt.softtabstop = -1 -- 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅(ネガティブな値の場合shiftwidthに従う)
opt.expandtab = true -- タブ入力を複数の空白入力に置き換える

-- 不可視文字を表示する
opt.list = true
opt.listchars = {
  tab = "» ",
  trail = "⋅",
  nbsp = "␣",
  extends = "❯",
  precedes = "❮",
  space = "⋅",
}

-- mouse操作を無効化
opt.mouse = ""

-- AutoFormatを実行しない
vim.g.disable_autoformat = true
