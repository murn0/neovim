local keymap = vim.keymap

-- keymap.set("n", "x", '"_x') -- xで削除した文字をレジスタに保存しない

-- emacs like keymaps
keymap.set({ "n", "v" }, "<C-a>", "<Home>")
keymap.set({ "n", "v", "i" }, "<C-e>", "<End>")
-- keymap.set({ "n", "v" }, "<C-p>", "<Up>")
-- keymap.set({ "n", "v" }, "<C-n>", "<Down>")

-- Scroll
keymap.set("n", "<C-j>", "<C-E>")
keymap.set("n", "<C-k>", "<C-Y>")

-- Diagnostic
-- keymap.set("n", "[d", vim.diagnostic.goto_prev)
-- keymap.set("n", "]d", vim.diagnostic.goto_next)

-- ヤンクした文字列をクリップボードに保存する
keymap.set("n", "+", "<Cmd>let @+ = @@<CR>")
