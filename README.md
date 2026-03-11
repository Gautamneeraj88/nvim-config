# Neovim Config

A minimal, modern Neovim setup built on **LazyVim** for TypeScript/JavaScript, Python, and Go development.

## Quick Start

```bash
# First launch — install all plugins
nvim
# Inside nvim:
:Lazy sync       # install/update all plugins
:Mason           # verify LSP servers are installed
```

---

## File Structure

```
~/.config/nvim/
├── init.lua                      ← entry point (just loads config.lazy)
└── lua/
    ├── config/
    │   ├── lazy.lua              ← plugin manager + LazyVim extras
    │   ├── options.lua           ← editor settings
    │   ├── keymaps.lua           ← custom keybindings
    │   └── autocmds.lua          ← auto commands
    └── plugins/
        ├── autosave.lua          ← auto-save
        ├── colorscheme.lua       ← themes (catppuccin, tokyonight, rose-pine, kanagawa)
        ├── editor.lua            ← neo-tree, smooth scroll, peek definition
        ├── markdown.lua          ← markdown browser preview
        ├── python.lua            ← Python venv auto-detection
        ├── search.lua            ← fzf-lua (fuzzy search)
        ├── terminal.lua          ← terminal inside Neovim
        ├── testing.lua           ← neotest (Jest, Vitest, pytest, Go)
        └── ui.lua                ← statusline (IST time), indent guides
```

---

## General

### The Leader Key

The **leader key is `Space`**. Press it and wait — `which-key` will pop up showing all available commands grouped by category. This is your built-in cheatsheet.

### Modes

| Mode | How to enter | What it's for |
|---|---|---|
| Normal | `Esc` or `jk` | Navigate, run commands |
| Insert | `i`, `a`, `o` | Type text |
| Visual | `v`, `V` | Select text |
| Command | `:` | Run vim commands |

---

## File Explorer (Neo-tree)

```
<leader>e    → toggle explorer sidebar
<leader>o    → focus explorer (move cursor into it)
```

**Inside the explorer:**
```
Enter        → open file / expand folder
a            → create new file (end with / to make a folder)
d            → delete file
r            → rename file
y            → copy file
x            → cut file
p            → paste file
H            → toggle hidden files
q            → close explorer
```

---

## Fuzzy Search (fzf-lua)

Fast search across files, code, git, and more.

```
<leader>ff   → find files by name
<leader>fr   → recent files (files you opened before)
<leader>fb   → switch between open buffers
<leader>/    → live grep — search text across ALL project files
<leader>fw   → search the word your cursor is on
<leader>ft   → search all TODO / FIXME / NOTE comments
<leader>ss   → search symbols in current file (functions, classes, etc.)
<leader>sS   → search symbols across entire project
<leader>sk   → search all keymaps
<leader>:    → command history
<leader>uT   → switch theme with live preview
```

**Inside any fzf window:**
```
Type         → filter results in real time
Enter        → open selected item
Ctrl+j/k     → move up/down
Ctrl+d        → scroll preview down
Ctrl+u       → scroll preview up
Esc          → close
```

---

## LSP — Code Intelligence

These work when your cursor is on any symbol (function, variable, class, import).

```
gd           → go TO definition (navigates away)
gp           → peek definition (floating window, stay in your file)
gpi          → peek implementation (TS/Go only — finds where interface is implemented)
gpr          → peek references (see all usages)
gpt          → peek type definition
gpc          → close all peek windows
Esc          → close peek window

K            → hover documentation (type info, docstring)
gr           → find all references (opens fzf list)
<leader>ca   → code actions (fix imports, extract function, quick fixes)
<leader>cr   → rename symbol everywhere in project
<leader>cf   → format current file

]d / [d      → jump to next / previous error or warning
<leader>cd   → show diagnostic details for current line
```

**LSP info & management:**
```
:LspInfo     → show which LSP servers are attached to current file
:LspRestart  → restart LSP servers (useful when they get stuck)
:Mason       → manage LSP server installations
```

---

## Completion

Completion popup appears automatically as you type.

```
Tab / Shift+Tab   → move through suggestions
Enter             → accept selected suggestion
Ctrl+e            → close completion popup
Ctrl+b / Ctrl+f   → scroll docs in popup
```

---

## Git

### Lazygit (full git UI)
```
<leader>gg   → open lazygit
<leader>tg   → open lazygit in terminal panel
```

**Inside lazygit:** press `?` to see all keymaps.

### Git signs (inline in editor)
Changed lines show colored marks in the left gutter:
- `│` green = added line
- `│` orange = modified line
- `_` red = deleted line

```
]h / [h      → jump to next / previous changed hunk
<leader>ghp  → preview what changed in this hunk (floating diff)
<leader>ghs  → stage this hunk
<leader>ghr  → revert this hunk back to HEAD
<leader>ghb  → blame current line (who wrote this and when)
```

### FZF git commands
```
<leader>gc   → browse git commits
<leader>gb   → browse and switch git branches
```

---

## Terminal

```
<C-\>        → toggle floating terminal (press again to hide)
<leader>th   → open horizontal split terminal (bottom)
<leader>tv   → open vertical split terminal (right)
<leader>tg   → open lazygit

Esc Esc      → exit terminal INSERT mode → back to normal mode
Ctrl+h/j/k/l → navigate to other windows while in terminal
```

---

## Test Runner (Neotest)

Supports **Jest**, **Vitest** (TypeScript/JS), **pytest** (Python), **Go test** — auto-detected per project.

```
<leader>tt   → run the test nearest to cursor
<leader>tf   → run all tests in current file
<leader>tl   → re-run the last test
<leader>ts   → toggle test summary panel (see all tests, pass/fail)
<leader>to   → toggle test output panel (see full output)
<leader>tS   → stop running test

]t           → jump to next failed test
[t           → jump to previous failed test
```

Pass/fail icons appear inline in your code next to each test automatically.

---

## Auto-save

**Saves automatically** — you don't need to do anything.

- Saves 1.5 seconds after you stop typing
- Saves instantly when you switch to another buffer or app loses focus
- Does NOT save in file explorer, lazy, or mason windows

You can still manually save with `<C-s>` if you want.

---

## TODO Comments

Special comments are highlighted in different colors automatically:

```lua
-- TODO: something to do later       (blue)
-- FIXME: broken, needs fixing       (red)
-- NOTE: important information       (green)
-- HACK: workaround, not ideal       (yellow)
-- WARN: be careful here             (orange)
-- PERF: performance improvement     (purple)
-- TEST: test related note           (teal)
```

```
<leader>ft   → search all TODOs across project (fzf)
]t / [t      → jump to next / previous TODO in current file
```

---

## Markdown

In any `.md` file:

```
<leader>mp   → open live preview in browser (auto-reloads as you type)
<leader>cf   → format markdown with prettier
```

Headers, bold text, bullet points, and code blocks render visually inside Neovim automatically.

---

## Themes

4 themes installed. Switch anytime with:

```
<leader>uT   → open theme picker with live preview
```

| Theme | Command | Vibe |
|---|---|---|
| **Catppuccin Mocha** | `:colorscheme catppuccin` | Default — dark, purple/pink |
| **Tokyonight** | `:colorscheme tokyonight` | Dark blue |
| **Rose Pine** | `:colorscheme rose-pine` | Warm, earthy |
| **Kanagawa** | `:colorscheme kanagawa` | Dark Japanese aesthetic |

To make a theme permanent, edit `lua/plugins/colorscheme.lua` and change the `colorscheme` value.

---

## Buffers & Windows

### Buffers (open files)
```
Tab / Shift+Tab   → next / previous open buffer
<leader>bd        → close current buffer
<leader>fb        → see all open buffers (fzf)
H / L             → previous / next buffer (in normal mode)
```

### Windows (splits)
```
<leader>-    → split horizontally (top/bottom)
<leader>|    → split vertically (left/right)
<leader>w=   → make all windows equal size
Ctrl+h/j/k/l → move between windows
```

---

## Python — Virtual Environment

The config auto-detects your venv. Priority order:
1. `VIRTUAL_ENV` env var (if you activated venv before opening nvim)
2. Walks up from file location looking for `.venv/`, `venv/`, `env/`
3. Scans monorepo subdirectories for venvs (e.g. `backend/.venv`)

**Best practice for monorepos:**
```bash
cd your-project/backend
source .venv/bin/activate
nvim .
```

**Manual override if needed:**
```
:PyrightSetPythonPath /path/to/.venv/bin/python
```

**Verify which Python pyright is using:**
```
:LspInfo
```

---

## Statusline

The bottom statusline shows from left to right:
- **Mode** (NORMAL / INSERT / VISUAL)
- **Git branch** name
- **File path**
- **LSP diagnostics** (errors/warnings count)
- **File type**
- **Cursor position** (line:column)
- **Time in IST** (India Standard Time, 24-hour format)

---

## Useful Commands

```
:Lazy          → open plugin manager (update, clean, check plugins)
:Lazy sync     → install + update all plugins
:Mason         → manage LSP, linter, formatter installations
:LspInfo       → show active LSP servers for current file
:LspRestart    → restart LSP
:checkhealth   → diagnose Neovim and plugin issues
:noh           → clear search highlights (or just press Esc)
```

---

## Editing Tips

```
jk             → exit insert mode (faster than reaching Escape)
<C-s>          → save file
<leader>qq     → quit all

Alt+j / Alt+k  → move current line or selection up/down
< / > (visual) → indent left/right (stays in visual mode)
v then p       → paste over selection without losing clipboard

<leader>sa     → select entire file
```
