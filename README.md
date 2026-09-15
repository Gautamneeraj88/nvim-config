# Neovim Config — Complete Reference

A blazing fast (~24ms startup), lightweight Neovim setup built on **LazyVim** for **TypeScript/JavaScript, Python, Go, and Web Development**. Pure TUI, zero bloat, and 100% active, conflict-free keybindings.

This document covers every feature in detail — read it when you're stuck or want to discover something new.

---

## Table of Contents

1. [Prerequisites & Installation](#prerequisites--installation)
2. [Understanding Neovim Basics](#understanding-neovim-basics)
3. [File Structure](#file-structure)
4. [The Leader Key & Which-Key](#the-leader-key--which-key)
5. [File Explorer — Neo-tree](#file-explorer--neo-tree)
6. [File Manager — Oil](#file-manager--oil)
7. [Fuzzy Search — fzf-lua](#fuzzy-search--fzf-lua)
8. [LSP — Code Intelligence](#lsp--code-intelligence)
9. [Diagnostics Panel — Trouble](#diagnostics-panel--trouble)
10. [LSP Navigation & Definition](#lsp-navigation--definition)
11. [Completion & Ghost Text](#completion--ghost-text)
12. [Git Integration](#git-integration)
13. [Git Diff Viewer — Diffview](#git-diff-viewer--diffview)
14. [Merge Conflicts — git-conflict](#merge-conflicts--git-conflict)
15. [Harpoon v2 — Instant File Jumping](#harpoon-v2--instant-file-jumping)
16. [Terminal](#terminal)
17. [Project Search & Replace — grug-far](#project-search--replace--grug-far)
18. [Python REPL — Iron](#python-repl--iron)
19. [Node.js REPL — Iron](#nodejs-repl--iron)
20. [Undo Tree](#undo-tree)
21. [Session Management](#session-management)
22. [Multi-cursor](#multi-cursor)
23. [Text Objects](#text-objects)
24. [Refactoring](#refactoring)
25. [Project Switcher](#project-switcher)
26. [Zen Mode & Focus](#zen-mode--focus)
27. [Code Outline — Aerial](#code-outline--aerial)
28. [Live Rename — inc-rename](#live-rename--inc-rename)
29. [Better Folds — UFO](#better-folds--ufo)
30. [Tabout](#tabout)
31. [Color Highlighter](#color-highlighter)
32. [Package Info](#package-info)
33. [TODO Comments](#todo-comments)
34. [Markdown](#markdown)
35. [Themes](#themes)
36. [Panel Layout — Edgy](#panel-layout--edgy)
37. [Inline Git Blame](#inline-git-blame)
38. [Code Action Lightbulb](#code-action-lightbulb)
39. [Yank History — Yanky](#yank-history--yanky)
40. [Better Quickfix — nvim-bqf](#better-quickfix--nvim-bqf)
41. [Smarter Word Motions — Spider](#smarter-word-motions--spider)
42. [Buffers & Windows](#buffers--windows)
43. [Editing Shortcuts](#editing-shortcuts)
44. [Statusline](#statusline)
45. [Python — Virtual Environment & LSP](#python--virtual-environment--lsp)
46. [Auto-tag — nvim-ts-autotag](#auto-tag--nvim-ts-autotag)
47. [Doc Comments — Neogen](#doc-comments--neogen)
48. [Marks](#marks)
49. [Virt-column — Line Length Guide](#virt-column--line-length-guide)
50. [Scroll-past-EOF — Dynamic Scrolloff](#scroll-past-eof--dynamic-scrolloff)
51. [Neoconf — Per-project LSP Settings](#neoconf--per-project-lsp-settings)
52. [Auto-save](#auto-save)
53. [Web & Devops Stacks](#web--devops-stacks)
54. [Surround — mini.surround](#surround--minisurround)
55. [Split / Join Blocks — treesj](#split--join-blocks--treesj)
56. [Markdown Image Paste & Tables](#markdown-image-paste--tables)
57. [Git Diff Presets — Diffview](#git-diff-presets-diffview)
58. [Incremental Selection](#incremental-selection-treesitter)
59. [How to Customize](#how-to-customize)
60. [Complete Keybinding Reference](#complete-keybinding-reference)

---

## Prerequisites & Installation

### Required tools

```bash
# macOS — install with Homebrew
brew install neovim git node ripgrep fd tree-sitter-cli fzf lazygit

# For Python REPL (ts-node optional, for TypeScript REPL)
npm install -g ts-node          # optional: TypeScript REPL support
pip install sqlite3             # for persistent yank history
```

### First launch

Neovim boots and synchronizes plugins automatically using `lazy.nvim`. Language servers, linters, and formatters are installed via Mason automatically on first launch.

---

## Understanding Neovim Basics

### Modes

Vim is modal — keystrokes do different things depending on which mode you are in.

| Mode | How to enter | What it does |
|---|---|---|
| **Normal** | `Esc` or `jk` | Moving around, running commands (default mode) |
| **Insert** | `i` (before cursor), `a` (after), `o` (new line below) | Typing text normally |
| **Visual** | `v` (character), `V` (line), `Ctrl+v` (block) | Selecting text |
| **Command** | `:` | Running commands (e.g. `:w` save, `:q` quit) |
| **Terminal** | `<C-\>` | Shell terminal |

### Essential Motions

```
h / j / k / l  → left / down / up / right
w / b          → next / previous word
e              → end of word
0 / $          → start / end of line
^              → first non-whitespace character on line
gg / G         → top / bottom of file
Ctrl+d / u     → half-page down / up
%              → jump to matching bracket: () [] {}
* / #          → next / previous occurrence of word under cursor (or gl / gL)
```

### Navigation in Insert Mode

```
jk             → exit to Normal mode (fast, no reaching for Esc)
Ctrl+s         → save file (works in Normal, Insert, and Visual)
Alt+j / Alt+k  → move current line down / up
Tab            → accept ghost text completion or tab out of quotes/brackets
```

### Operators + Motions

Combine an action with a motion:

```
d + w          → delete word
c + w          → change word (deletes word, enters Insert mode)
y + $          → yank (copy) to end of line
d + d          → delete whole line
y + y          → yank (copy) whole line
gsa + i + w + " → surround word with quotes ("word")
```

### Undo / Redo

```
u              → undo
Ctrl+r         → redo
<leader>uu     → open Undo Tree (visual timeline of all changes)
```

---

## File Structure

```
~/.config/nvim/
├── init.lua                  ← Entry point — defensive cwd patch + loads lazy.lua
│
└── lua/
    ├── config/
    │   ├── lazy.lua          ← Plugin manager + enabled LazyVim extras
    │   ├── options.lua       ← Editor settings (word wrap default, scrolloff, timeoutlen=300…)
    │   ├── keymaps.lua       ← Custom keybindings + which-key group labels
    │   └── autocmds.lua      ← Autocommands (inlay hints, virt-column, filetype settings)
    │
    └── plugins/
        ├── autosave.lua      ← Auto-save on InsertLeave/BufLeave/FocusLost
        ├── coding.lua        ← UFO folds, refactoring, autotag, neogen, tabout,
        │                        treesitter textobjects, various textobjs,
        │                        ts-error-translator, blink.cmp ghost text, mini.surround, treesj
        ├── colorscheme.lua   ← tokyonight (default) + catppuccin, rose-pine, kanagawa, cyberdream
        ├── editor.lua        ← Neoconf, todo-comments, diagnostics, gitsigns,
        │                        neo-tree explorer, oil file manager, snacks dashboard
        ├── extras.lua        ← Yanky, vim-visual-multi, nvim-bqf, persistence, marks
        ├── git-advanced.lua  ← Diffview, git-conflict, lazygit (snacks)
        ├── lsp.lua           ← vtsls, gopls, basedpyright, cssls, html, bashls, conform formatters
        ├── markdown.lua      ← Markdown preview, image paste, table mode
        ├── navigation.lua    ← Smart-splits (terminal+tmux aware), spider, harpoon v2, projects
        ├── python.lua        ← basedpyright venv detection, ruff formatter, iron.nvim REPL
        ├── search.lua        ← fzf-lua config + hlslens search lens
        ├── terminal.lua      ← Snacks terminal (<C-\>, float, split)
        ├── ui-extras.lua     ← Colorizer (inline hex/rgb), package-info (package.json only)
        ├── ui.lua            ← Edgy panels, fidget LSP progress, lualine, lightbulb, noice (bottom TUI)
        ├── undotree.lua      ← Visual undo timeline (<leader>uu)
        └── visuals.lua       ← Rainbow delimiters, virt-column, illuminate (cursor word)
```

### LazyVim extras active (`lua/config/lazy.lua`)

| Extra | What it provides |
|---|---|
| `lang.typescript` | vtsls, eslint, prettier, TS/JS inlay hints |
| `lang.python` | basedpyright, ruff |
| `lang.go` | gopls, gofumpt |
| `lang.json` | jsonls, schema validation |
| `lang.tailwind` | Tailwind CSS class completion + sorting |
| `lang.yaml` | yaml-language-server + schemas |
| `lang.markdown` | LSP, treesitter, render-markdown |
| `formatting.prettier` | Prettier for TS/JS/CSS/HTML |
| `editor.aerial` | Code outline panel (`<leader>cs`) |
| `editor.inc-rename` | Live rename preview (`<leader>cr`) |
| `editor.fzf` | fzf-lua as the primary LazyVim picker |
| `editor.dial` | Smarter increment/decrement (`<C-a>` / `<C-x>`) |
| `util.dot` | Dotfile management helpers |

---

## The Leader Key & Which-Key

**Leader key is `Space`**. Press it and wait 1000ms — a popup shows all available commands grouped by category.

```
Space f ...   → File operations
Space s ...   → Search operations
Space g ...   → Git operations
Space c ...   → Code (LSP) operations
Space t ...   → Test operations
Space d ...   → Debug operations
Space r ...   → REST client (only in .http/.rest files)
Space p ...   → Python REPL (only in Python files)
Space j ...   → Node REPL (only in JS/TS files)
Space u ...   → UI toggles
Space b ...   → Buffer operations
Space w ...   → Window operations
```

> **Tip:** You don't need to memorize keymaps. Press `Space`, read the popup, press the next key.

---

## File Explorer — Neo-tree

VSCode-style file tree. **Dotfiles are visible by default.**

### Usage

```
<leader>e    → toggle file explorer (project root)
<leader>E    → toggle file explorer (current working directory)
```

| Situation | Key |
|---|---|
| Browse project root | `<leader>e` |
| Browse current working directory | `<leader>E` |

### Navigation inside the tree

```
j / k        → move up / down
Enter        → open file or expand folder
l            → expand folder
h            → collapse folder
```

### File operations

```
a            → new file (end with / for folder, supports paths: components/Button.tsx)
d            → delete (asks confirmation)
r            → rename
y            → copy
x            → cut
p            → paste
H            → toggle hidden files
R            → refresh tree
q            → close explorer
```

### Resizing

`>` and `<` are registered as buffer-local keys inside the Neo-tree panel. They update edgy's internal width so the size persists.

```
>   → widen explorer by 5 columns  (cursor must be inside Neo-tree)
<   → narrow explorer by 5 columns
```

Default width: **40 columns**. Minimum: 20. Standard `<leader>w>` does not work here.

---

## File Manager — Oil

Edit the filesystem like a text buffer — rename files with `cw`, move with `dd`/`p`, delete with `dd`. **Nothing is applied until you save with `:w`.**

```
-            → open parent directory in a floating oil window
```

### Inside Oil

```
Enter / l    → open file or enter directory
-            → go to parent directory
_            → go to Neovim's cwd
g.           → toggle hidden files
gs           → change sort order
gx           → open file with system default app
<C-c>        → close oil
?            → show help

dd           → mark for delete (confirmed on :w)
cw           → rename (edit the name inline)
yy / p       → copy and paste files between directories
```

### Workflow — bulk rename

```
1. Press -          → oil opens showing current directory
2. Press cw         → rename the file under cursor
3. Rename multiple files by editing their names in the buffer
4. Press :w         → all renames applied at once
```

> **Oil vs Neo-tree:** Neo-tree is for navigation and file creation. Oil is for bulk operations — rename a dozen files at once, reorganize folders, etc.

---

## Fuzzy Search — fzf-lua

Find anything instantly. One of the most important tools.

### Finding files

```
<leader>ff   → find files by name (entire project)
<leader>fr   → recent files
<leader>fb   → switch between open buffers
```

### Searching inside files

```
<leader>/    → live grep — search text across ALL project files
<leader>fw   → search exact word under cursor
<leader>fs   → search visual selection (select text first)
```

### LSP search

```
<leader>ss   → all symbols in current file (functions, classes, variables)
<leader>sS   → all symbols across the entire project
gr           → all references to current symbol
```

### Git search

```
<leader>gc   → browse git commits (with diff preview)
<leader>gB   → browse branches (Enter to switch)
```

### Other

```
<leader>ft   → search all TODO/FIXME/NOTE comments
<leader>sk   → search all keymaps
<leader>:    → browse command history
<leader>uT   → switch theme with live preview
```

### Inside any fzf window

```
Type         → filter in real time
Enter        → open / select
Ctrl+j / k   → move down / up
Ctrl+d / u   → scroll preview pane
Esc          → close without selecting
```

---

## LSP — Code Intelligence

LSP gives you IDE features automatically when you open a supported file.

**Active language servers:**

| Language | Server | Notes |
|---|---|---|
| TypeScript/JS | `vtsls` | Full TS server, inlay hints, import management |
| Python | `basedpyright` | Stricter than pyright, faster, actively maintained |
| Go | `gopls` | Full Go toolchain, staticcheck, gofumpt |
| JSON | `jsonls` | Schema validation |
| CSS/SCSS | `cssls` / `scssls` | Tailwind class completion, validation |
| HTML | `html` | Tag/attribute autocompletion |
| Bash/Shell | `bashls` | Shell script diagnostics + shellcheck |
| YAML | `yaml-language-server` | Schemas, validation |
| TOML | `taplo` | pyproject.toml, Cargo.toml etc. |
| Tailwind | `tailwindcss` | Class completion, sorting |
| Prisma | `prisma-language-server` | Schema validation |
| Docker | `dockerls` | Dockerfile + compose |

### Navigation

```
gd           → go to definition (jumps there)
gr           → all references (fzf-lua list)
gI           → go to implementation
gy           → go to type definition
K            → hover documentation (type, docstring, signature)
```

**Reading long docs / signatures:** when a hover (`K`) or the signature popup is open,
scroll inside it with the keyboard — **`<C-f>`** (Ctrl+f) scrolls down, **`<C-b>`**
(Ctrl+b) scrolls up. These work even in insert mode while typing a call. Don't scroll
the popup with the mouse in a terminal — it can leak escape codes into the buffer.

The **signature popup** (parameter list + types) appears automatically as you type a
function call, e.g. `Field(` — handled by noice, so it's a single bordered window.

### Code actions

```
<leader>ca   → code actions: add import, fix lint, extract function, implement interface…
<leader>cr   → rename symbol everywhere in project (with live preview)
<leader>cf   → format file (uses conform: prettier/ruff/gofumpt/stylua)
<leader>cg   → generate doc comment (neogen — see Doc Comments section)
```

### Diagnostics in your code

**Sign column (left gutter):** `E` error · `W` warning · `I` info · `H` hint

**Virtual text:** only shown on the line your cursor is on. Keeps other lines clean.

```
]d           → next error/warning
[d           → previous error/warning
<leader>cd   → show full error message in a floating popup
<leader>xx   → open Trouble panel (all errors listed)
```

### TypeScript — human-readable errors

TypeScript errors like `"Type 'X' is not assignable to type 'Y' because..."` are automatically translated to plain English by `ts-error-translator`. No keypress needed — they appear translated in diagnostic floats.

### Inlay hints

Always-on in TypeScript, JavaScript, Go, and Python (basedpyright):
- Parameter names at call sites: `createUser(data:` → `createUser(data: CreateUserDto`
- Variable types: `const x =` → `const x: string =`
- Return types, enum values, composite literal field names

They render in the theme's comment colour (readable, not the near-invisible default).

```
<leader>uh   → toggle inlay hints on/off
```

### LSP management

```
:LspInfo       → which servers are running for current file
:Mason         → install/uninstall language servers and tools
<leader>cL     → restart all LSP servers (when completions/hints stop working)
```

---

## Diagnostics Panel — Trouble

See all errors and warnings across the project in a browsable list.

```
<leader>xx   → all diagnostics (entire project)
<leader>xX   → diagnostics for current file only
<leader>xL   → location list
<leader>xQ   → quickfix list
<leader>cs   → all symbols in current file
```

### Inside Trouble

```
j / k        → move up/down
Enter        → jump to that error in code
o            → preview without leaving Trouble
]d / [d      → next/prev item
q            → close
```

### Workflow

1. `<leader>xx` — see all errors
2. `j/k` to the error, `Enter` to jump to it
3. Fix it — it disappears from Trouble automatically
4. Repeat until empty

---

## LSP Navigation & Definition

Jump to definitions, implementations, and references across your project with instant fzf-lua preview.

```
gd           → jump to definition
gr           → list all references in fzf-lua
gI           → jump to implementation
gy           → jump to type definition
K            → hover documentation / signature
```

---

## Completion & Ghost Text

Completion popup appears automatically as you type.

```
Tab          → select next suggestion / accept ghost text
Shift+Tab    → select previous suggestion
Enter        → accept selected suggestion
Ctrl+e       → dismiss popup
Ctrl+b / f   → scroll documentation in popup
```

### Ghost text

The top completion candidate appears **greyed-out inline** as you type — like VS Code's inline suggestion. Press `Tab` to accept it. Press anything else to ignore it and keep typing.

```typescript
const user = getUserBy|    ← ghost text appears: Id(id: string): User
```

Sources shown in completion: LSP · snippets · buffer words · file paths

### Snippets

Snippets come from **friendly-snippets** — a large prebuilt library covering TypeScript, JavaScript, Python, Go, and more — surfaced through blink.cmp's native snippet engine (no LuaSnip required).

```
Start typing a trigger (e.g. `fn`, `func`, `forin`, `try`) → the snippet
appears in the completion popup with a [Snippet] tag → Tab to expand →
Tab again to jump between placeholders.
```

Doc-comment templates are generated separately by Neogen (`<leader>cg`) using Neovim's native snippet engine.

---

## Git Integration

### Lazygit — full git UI

Opens in a **centered floating window** (85% × 90% of screen).

```
<leader>gg   → open lazygit (rooted at project git root)
<leader>gG   → open lazygit (rooted at cwd — useful in monorepos)
```

**Inside lazygit** (`?` for all keys):

```
Space        → stage/unstage file
c            → commit
p            → push
P            → pull
b            → branch menu
d            → view diff
q            → quit
```

### Gitsigns — inline git indicators

Changed lines in the **sign column** (left gutter):
- Green `│` = line added
- Orange `│` = line modified
- Red `_` = line deleted below

```
]h           → next changed hunk
[h           → previous changed hunk
<leader>ghp  → preview this hunk's diff (floating)
<leader>ghs  → stage this hunk
<leader>ghr  → reset/discard this hunk
<leader>ghb  → blame for current line
```

### Inline blame (always visible)

Every line shows author + date + commit message at the end — appears automatically after 500ms on the cursor line. No keypress needed.

```
const port = process.env.PORT ?? 3000;    you, 2 Apr 2026 · add port config
```

### FZF git commands

```
<leader>gc   → browse commit history with diff preview
<leader>gB   → browse branches, Enter to checkout
```

---

## Git Diff Viewer — Diffview

Side-by-side diffs, full file history, 3-way merge view.

```
<leader>gd    → open diff view (all uncommitted changes)
<leader>gD    → diff current state vs last commit (HEAD~1)
<leader>gfh   → history of current file (every commit that touched it)
<leader>gFH   → history of entire project
<leader>gdc   → close diff view
```

### Inside Diffview

```
Tab / S-Tab   → jump between changed files
]c / [c       → next / previous change hunk in diff
<leader>b     → toggle file panel
q             → close
```

### Reading a diff

```
Left pane     → OLD version
Right pane    → NEW version (your current changes)
Green lines   → added
Red lines     → removed
```

---

## Merge Conflicts — git-conflict

When you pull/merge and get conflicts, this plugin highlights them and lets you resolve with single keypresses.

### What a conflict looks like

```
<<<<<<< HEAD  (your current branch)
def calculate(x):
    return x * 2
=======
def calculate(x, y):
    return x + y
>>>>>>> feature/new-calc  (incoming branch)
```

### Resolving

Place cursor anywhere in the conflict block:

```
co   → choose OURS   (keep HEAD / current branch)
ct   → choose THEIRS (keep incoming branch)
cb   → choose BOTH   (keep both stacked)
c0   → choose NONE   (delete the conflict block entirely)
```

### Navigation

```
]x              → next conflict in file
[x              → previous conflict
<leader>gx      → list ALL conflicts in quickfix (see every file that has conflicts)
```

### Statusline indicator

When a file has unresolved conflicts, the statusline shows `⚡N` (e.g. `⚡3` = 3 unresolved blocks). Updates automatically as you resolve them.

### Full workflow

1. Pull/merge → git says "conflict in file.py"
2. Open file — conflicts are highlighted automatically
3. `]x` → jump to first conflict
4. Read both sides → press `co`/`ct`/`cb`/`c0`
5. `]x` → next conflict, repeat
6. Save, stage, commit

---

## Harpoon v2 — Instant File Jumping

Keep your 4 most important files pinned and jump between them instantly without searching or browsing a file tree.

```
<leader>H    → add current file to Harpoon
<leader>h    → open Harpoon quick menu (reorder, edit, delete files)
<leader>1    → jump to file 1
<leader>2    → jump to file 2
<leader>3    → jump to file 3
<leader>4    → jump to file 4
]h           → cycle to next Harpoon file
[h           → cycle to previous Harpoon file
```

### Why Harpoon?

Instead of cycling through 20 open buffers or typing in fuzzy search for the same files over and over, pin the 2–4 files you are actively working on and switch between them with a single keystroke.

---

## Terminal

Floating and split terminals powered by `snacks.nvim`.

```
<C-\>        → toggle floating terminal (press again to hide)
<leader>Tf   → floating terminal
<leader>Th   → horizontal split terminal (bottom)
<leader>Tv   → vertical split terminal (right)
```

### Navigation & Exiting

- **Seamless split navigation:** `Ctrl+h/j/k/l` moves out of the terminal directly to adjacent splits without needing to leave insert mode.
- **Scroll output:** Press `<C-\><C-n>` to switch to Normal mode inside the terminal, then use `j` / `k` / `Ctrl+u` / `Ctrl+d` to scroll. Press `i` or `a` to return to shell input.
- **Hide:** `<C-\>` hides the terminal immediately.

> **Key point:** Hiding with `<C-\>` does NOT kill the process. The shell keeps running in the background.

---

## Tmux Integration

Smart-splits.nvim detects when Neovim runs inside tmux and wires `<C-h/j/k/l>` to navigate across Neovim splits **and** tmux panes seamlessly.

### Setup (one-time)

**1. Install the tmux plugin** (via [tpm](https://github.com/tmux-plugins/tpm)):

Add to `~/.tmux.conf`:

```bash
set -g @plugin 'mrjones2014/smart-splits.nvim'
```

Then press `prefix + I` to install.

**2. Add keybindings to `~/.tmux.conf`:**

```bash
# Smart-splits tmux navigation
bind -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
bind -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
bind -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
bind -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"

# Smart-splits tmux resize
bind -n M-Left  if-shell "$is_vim" "send-keys M-Left"  "resize-pane -L 5"
bind -n M-Right if-shell "$is_vim" "send-keys M-Right" "resize-pane -R 5"
bind -n M-Down  if-shell "$is_vim" "send-keys M-Down"  "resize-pane -D 5"
bind -n M-Up    if-shell "$is_vim" "send-keys M-Up"    "resize-pane -U 5"
```

**3. Add the `is_vim` variable** near the top of `~/.tmux.conf`:

```bash
is_vim="basename #{pane_current_command}) = vim"
```

**4. Reload tmux config:**

```bash
tmux source-file ~/.tmux.conf
```

After this, `Ctrl+h/j/k/l` moves between Neovim windows and tmux panes interchangeably. No visual boundary between the two.

---

## Project Search & Replace — grug-far

Search for text across the **entire project** and replace it — with a preview of every change before applying. Much more powerful than `:%s/old/new/g` which only works in one file.

```
<leader>sr   → open grug-far (project-wide search & replace)
<leader>sR   → search for word under cursor across project
```

### Inside grug-far

Type your search and replacement in the input fields at the top. Results appear below with file + line context.

```
<leader>r    → replace ALL results
<CR> on result → jump to that location
q            → close
```

> **Supports regex.** For example: `function (\w+)\(` to find all function declarations.

---

## Python REPL — Iron

Send Python code to an interactive Python session without leaving Neovim. The REPL picks up your active virtual environment automatically.

> **Note:** All `<leader>p*` keys only appear in Python files.

### Opening the REPL

```
<leader>po   → open REPL panel (horizontal split, 35% of screen)
<leader>ph   → hide REPL panel
<leader>pr   → restart REPL (picks up new venv if you switched)
```

### Sending code

```
<leader>pl   → send current line to REPL
<leader>pv   → send visual selection (select first with v/V)
<leader>pf   → send entire file
<leader>pc   → clear REPL screen
```

### Workflow

```
1. <leader>po  → open REPL (uses your .venv automatically)
2. Write some code in your .py file
3. <leader>pv  → select a block visually and send it
4. Watch the result appear in the REPL pane below
5. <leader>pc  → clear when it gets cluttered
6. <leader>pr  → restart if you need a fresh state
```

> **Venv detection:** Iron uses the same `VIRTUAL_ENV` / `CONDA_PREFIX` environment variables as basedpyright. If you activated your venv before opening Neovim, the REPL uses it automatically.

---

## Node.js REPL — Iron

Send JavaScript code to a Node.js REPL session. TypeScript automatically uses `ts-node` or `tsx` if installed.

> **Note:** All `<leader>j*` keys only appear in JS/TS files.

### Opening the REPL

```
<leader>jo   → open Node REPL panel
<leader>jh   → hide REPL panel
<leader>jr   → restart REPL
```

### Sending code

```
<leader>jl   → send current line
<leader>jv   → send visual selection
<leader>jf   → send entire file
<leader>jc   → clear REPL screen
```

### TypeScript support

Iron auto-detects the best runtime:
1. `ts-node` — if installed globally (`npm i -g ts-node`)
2. `tsx` — if installed globally (`npm i -g tsx`)
3. `node` — fallback (paste transpiled JS manually in this case)

To install ts-node: `npm install -g ts-node typescript`

---

## Undo Tree

Neovim tracks **every change** to a file, even across sessions. Normally `u` is linear — if you undo then make a new edit, undone changes are lost. Undotree shows the full **branch history**.

```
<leader>uu   → toggle Undo Tree panel
```

### Inside Undo Tree

```
j / k        → move through history states
Enter        → jump to that state (file changes to match)
d            → toggle diff panel
q            → close
```

### Reading the tree

```
●            → a save point
│            → linear sequence of changes
├─           → branch (you undid then made a new change here)
```

> **When to use:** You've been editing, did some undos, made more changes, and now want to get back to a specific earlier state that's no longer accessible with plain `u`.

---

## Session Management

Saves your entire workspace state — open files, splits, cursor positions.

```
<leader>qs   → restore session for current directory
<leader>ql   → restore last session (wherever you were last)
<leader>qd   → stop auto-saving session for this session
```

### How it works

- Session is **automatically saved** when you quit
- When you open Neovim **with no file arguments** (`nvim` or `nvim .`), the last session for that directory is **automatically restored** — no keypress needed
- Terminal buffers are excluded from sessions (dead terminal processes cause errors on restore)

---

## Multi-cursor

Works exactly like VS Code's `Ctrl+D` (multi-cursor editing). Uses the **vim-visual-multi** plugin.

### Key notation

Neovim keybindings use shorthand. Read them like this:

```
<C-n>        → Ctrl + n         (hold the Ctrl key, press n)
<M-p>        → Alt + p          (hold the Alt/Option key, press p)
<C-Up>       → Ctrl + Up arrow
<leader>     → Space bar        (Neovim's leader key)
\            → backslash key    (vim-visual-multi's leader key — no modifier)
```

### Select occurrences

Place the cursor on the word, then:

```
<C-n>        → select the word under the cursor
             → press again to add the NEXT occurrence
             → keep pressing to add more
\A           → select ALL occurrences of the word at once
<C-x>        → skip the current occurrence, jump to the next
<C-q>        → remove the last added cursor
```

> `\A` is **backslash then capital A** — `\` is the vim-visual-multi leader, `A` = "all".

### Add cursors vertically

```
<C-Down>     → add a cursor on the line below
<C-Up>       → add a cursor on the line above
```

### Once cursors are active

Just **start typing** — the new text replaces every selected occurrence at the same time.
All normal Neovim editing applies to all cursors simultaneously:

```
<type>       → replace all selected occurrences (VS Code-style)
i / a        → insert / append at all cursors
c            → change at all cursors
d            → delete at all cursors
I / A        → insert at start/end of all selected lines
Esc          → exit multi-cursor mode
```

### Example — rename a variable

```
1. Put the cursor on `userData`
2. \A                    → select ALL occurrences at once
3. Type `userInfo`       → every occurrence is replaced live
4. Esc                   → done
```

Or step by step: `<C-n>` on the word → keep pressing `<C-n>` to add each next occurrence → type the replacement → `<Esc>`.

> **Note:** `<C-n>` is reserved for multi-cursor. Yanky uses `<M-p>`/`<M-n>` (Alt) to avoid conflict.

---

## Text Objects

### Treesitter text objects

Used with operators (`d`, `y`, `c`, `v`):

```
af / if      → around/inside function
ac / ic      → around/inside class
aa / ia      → around/inside argument
al / il      → around/inside loop
```

**Motion — jump to functions/classes:**

```
]m / [m      → next/prev function start
]M / [M      → next/prev function end
]k / [k      → next/prev class start
]K / [K      → next/prev class end
```

**Swap arguments:**

```
<leader>as   → swap current argument with the one to the right
<leader>aS   → swap current argument with the one to the left
```

### Various text objects (operator/visual mode)

```
au / iu      → around/inside URL
an / in      → around/inside number
ai / ii      → around/inside indentation block (great for Python)
aV / iV      → around/inside assignment value  (x = |value|)
am / im      → around/inside markdown link
aP / iP      → around/inside Python triple-quoted string / docstring
```

### Example

```python
def greet(name, greeting):
    return f"{greeting}, {name}!"
```

- Cursor on `name`: `daa` → deletes the argument including comma
- Cursor on function: `vaf` → visual selects the whole function
- `<leader>as` with cursor on `name` → swaps `name` and `greeting`

---

## Refactoring

Select code in visual mode and extract it to a new function or variable. Works for TypeScript, JavaScript, Python, Go, Lua.

```
<leader>Re   → (visual) extract selected code to a new function
<leader>RE   → (visual) extract selected code to a function in a new file
<leader>Rv   → (visual) extract selected expression to a new variable
<leader>Ri   → (normal/visual) inline a variable back into its usages
<leader>RI   → (normal) inline a function back into its call sites
<leader>Rr   → (normal/visual) pick any valid refactor from a menu
```

### Example — extract to function

```typescript
// Select these lines in visual mode:
const sanitized = input.trim().toLowerCase().replace(/\s+/g, '_')
const result = sanitized + '_suffix'

// Press <leader>Re → type function name → becomes:
function processInput(input: string) {
  const sanitized = input.trim().toLowerCase().replace(/\s+/g, '_')
  return sanitized + '_suffix'
}
const result = processInput(input)
```

---

## Project Switcher

Jump between projects instantly.

```
<leader>fp   → open project picker (fuzzy search all your projects)
```

Auto-detects projects by looking for `.git`, `package.json`, `go.mod`, `pyproject.toml`.

---

## Zen Mode & Focus

Distraction-free focus and window maximization powered by `snacks.nvim`.

### Zen Mode

Hides UI distractions and centers the editor for deep focus.

```
<leader>uz   → toggle zen mode
```

When active: sidebar panels hide, statusline simplifies, and code is centered. Press `<leader>uz` again to restore your layout.

### Zoom / Maximize Window

Temporarily maximize the current split to take over the full window without closing other splits.

```
<leader>uZ   → toggle maximize split
<leader>wm   → toggle maximize split (mnemonic: window maximize)
```

### Dim Inactive Code

Dims background context and keeps your cursor's current scope in focus.

```
<leader>uD   → toggle dimming
```

---

## Code Outline — Aerial

Panel showing all functions, classes, and methods in the current file. Jump to any symbol instantly.

```
<leader>cs   → toggle aerial outline panel
{            → jump to previous symbol
}            → jump to next symbol
```

### Inside aerial

```
Enter        → jump to that symbol
p            → preview symbol without leaving aerial
q            → close
```

---

## Live Rename — inc-rename

When you rename a symbol, it shows a **live preview** of every place that will change as you type — before you press Enter.

```
<leader>cr   → start renaming (live preview as you type)
Enter        → confirm
Esc          → cancel
```

---

## Better Folds — UFO

Smarter folding using LSP and treesitter. Shows how many lines are folded.

```
za           → toggle fold under cursor
zo / zc      → open / close fold under cursor
zR           → open ALL folds
zM           → close ALL folds
zr / zm      → open/close one level at a time
zp           → peek inside a fold without opening it
```

When folded:

```python
class UserService:  ···  47 lines
```

> **Tip:** `zM` folds everything for a high-level overview. Then `za` on the function you want to work on.

---

## Tabout

When cursor is **inside** brackets/quotes, `Tab` jumps **out** to after the closing symbol.

```
"hello|"   → Tab → cursor after the "
[item|]    → Tab → cursor after the ]
(arg|)     → Tab → cursor after the )
```

Works with: `"` `'` `` ` `` `(` `)` `[` `]` `{` `}` `<` `>`

> When the completion popup is open, `Tab` selects suggestions. When ghost text is showing, `Tab` accepts it. Tabout only activates when neither popup nor ghost text is active.

---

## Color Highlighter

Hex, RGB, HSL, CSS colors, and Tailwind classes shown with a **colored background** inline.

```css
color: #ff6b6b;             /* pink/red background shown */
background: rgb(100,200,50); /* green background shown */
```

```html
<div class="bg-blue-500 text-red-300"><!-- both shown inline --></div>
```

Active only in: CSS, SCSS, LESS, HTML, JS, TS, JSX, TSX, Svelte, Vue, JSON. Not loaded in other files.

---

## Package Info

When you open `package.json`, shows **current installed versions** inline and highlights outdated packages.

Activates only for files named `package.json`. Package manager auto-detected from lockfile (`pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, else npm).

```
<leader>Pp   → toggle showing package versions
<leader>Pu   → update package under cursor to latest
<leader>Pd   → delete package under cursor
<leader>Pi   → install a new package
<leader>Pc   → change version of package under cursor
```

---

## TODO Comments

Special keywords are **highlighted in distinct colors** in any language.

```python
# TODO:  something to do later         → Blue   (crystalBlue)
# FIXME: this is broken                → Red    (samuraiRed)
# NOTE:  important context             → Green  (springGreen) — also: INFORMATION
# HACK:  workaround, not ideal         → Yellow (carpYellow)
# WARN:  be careful, edge case here    → Orange (roninYellow)
# PERF:  performance opportunity       → Violet (oniViolet)
# TEST:  note about testing this       → Teal   (waveAqua2)
# INFO:  informational note            → Teal   (waveAqua1)
```

Works in all languages (Python `#`, JS `//`, Go `//`, Lua `--`, C/C++ `//`).

### Navigating TODOs

```
<leader>ft   → search all TODOs in project (fzf)
]t           → jump to next TODO in current file
[t           → jump to previous TODO in current file
```

---

## Markdown

### In-editor rendering

When you open `.md`, Neovim renders it visually — headers, bold/italic, code blocks, checkboxes, bullet points.

### Browser preview

```
<leader>mp   → live preview in browser (auto-reloads on save)
```

First time: `:Lazy sync` then `:MarkdownPreviewInstall`

### Formatting

```
<leader>cf   → format with prettier
```

---

## Themes

7 themes installed. Switch anytime — no restart needed.

```
<leader>uT   → open live theme picker (preview updates as you move)
```

| Theme | Command | Style |
|---|---|---|
| **Tokyonight Night** | `:colorscheme tokyonight` | **Default** — clean, dark blue/purple |
| **Catppuccin Mocha** | `:colorscheme catppuccin` | Dark, pastel, full integrations (LSP, treesitter, fzf, gitsigns, noice…) |
| **Kanagawa Wave** | `:colorscheme kanagawa` | Dark Japanese ink, compiled bytecode for fast startup |
| **Oxocarbon** | `:colorscheme oxocarbon` | IBM Carbon, near-black + electric blue |
| **Cyberdream** | `:colorscheme cyberdream` | Cyberpunk neon |
| **Rose Pine** | `:colorscheme rose-pine` | Warm, earthy |

### Make permanent

Edit `lua/plugins/colorscheme.lua`:

```lua
{ "LazyVim/LazyVim", opts = { colorscheme = "tokyonight" } }
```

### Recompile Kanagawa after changing options

```
:KanagawaCompile
```

Run this once after changing any kanagawa opts, or if colors look wrong after a plugin update.

---

## Panel Layout — Edgy

Locks tool windows into consistent positions. You never get a random split in the wrong place.

| Panel | Position | Opens with |
|---|---|---|
| Neo-tree (Explorer) | Left | `<leader>e` |
| Aerial (Outline) | Right | `<leader>cs` |
| Quickfix | Bottom | `:copen` or `<leader>xQ` |
| Trouble (Diagnostics) | Bottom | `<leader>xx` |
| Help | Bottom | `:help <topic>` |

---

## Inline Git Blame

Subtle blame annotation at the end of every cursor line — author, date, commit summary. Appears after 500ms.

```
const port = process.env.PORT ?? 3000;    you, 2 Apr 2026 · add port config
```

For the full blame: `<leader>ghb`

---

## Code Action Lightbulb

When the LSP has code actions available, `󰌶` appears in the sign column.

```
󰌶  const x = require('lodash')   ← "I can fix/improve this"
```

Press `<leader>ca` to open the action menu.

---

## Yank History — Yanky

Every yank (copy) is saved to a persistent ring (survives restarts via SQLite). After pasting, cycle through previous yanks.

```
y            → yank — same key, now tracked
p / P        → paste after / before cursor
<M-p>        → replace last paste with previous yank  (Alt+p)
<M-n>        → replace last paste with next yank      (Alt+n)
<leader>fy   → browse full yank history in a picker
```

> **Cycle keys use Alt (not Ctrl)** to avoid conflict with `<C-n>` multi-cursor.

---

## Better Quickfix — nvim-bqf

The quickfix window now has an **fzf preview pane** — filter the list and see context before jumping.

```
<leader>xQ   → open quickfix (enhanced)
[q / ]q      → previous / next quickfix item
```

### Inside quickfix

```
Tab          → toggle selection
zf           → filter list with fzf
<C-s>        → open in horizontal split
o            → open, stay in quickfix
q            → close
```

---

## Smarter Word Motions — Spider

`w`, `b`, `e` now stop at **camelCase humps** and **snake_case underscores**.

```
camelCaseWord    → w stops at: camel → Case → Word  (not the whole thing at once)
my_variable_name → w stops at: my → variable → name
```

All operators work: `dw`, `cw`, `vw`, `yw` all respect the boundaries.

```typescript
// Rename part of a camelCase name:
getUserById    → cursor on "User" → ciw → type "Member" → getMemberById
```

---

## Buffers & Windows

### Buffers (open files)

```
Tab          → next open buffer
Shift+Tab    → previous open buffer
H / L        → previous / next buffer
<leader>bd   → close current buffer
<leader>bo   → close all OTHER buffers (keep only current)
<leader>fb   → switch buffers with fzf
```

### Creating splits

```
<leader>-    → split horizontally (top/bottom)
<leader>|    → split vertically (left/right)
```

### Navigating windows

```
Ctrl+h/j/k/l → move cursor to left/bottom/top/right window
```

### Resizing windows

```
<A-Left/Right/Up/Down>    → resize split (smart-splits — also works across tmux)

<leader>w+   → increase height
<leader>w-   → decrease height
<leader>w>   → increase width
<leader>w<   → decrease width
<leader>w=   → equalize all window sizes
```

---

## Editing Shortcuts

```
jk           → exit insert mode (faster than reaching Escape)
<C-s>        → save file (normal, insert, visual)

Alt+j / Alt+k       → move current line down / up
                       (in visual: moves the whole selection)

> / < (visual)      → indent right / left (stays in visual mode)

<leader>A    → select entire file
```

### Search & Replace

```
/pattern     → search forward
?pattern     → search backward
n / N        → next / previous result
Esc          → clear search highlight

:%s/old/new/g        → replace all in file
:%s/old/new/gc       → replace with confirmation
```

While searching, `n`/`N`/`*`/`#` show an inline counter: `[2/14]` next to the match (hlslens).

---

## Statusline

```
[MODE]  branch  filename  errors  warnings   ⚡conflicts  filetype  venv  line:col  HH:MM
```

| Segment | Description |
|---|---|
| **MODE** | NORMAL / INSERT / VISUAL / COMMAND |
| **branch** | Current git branch |
| **filename** | Relative path, `[+]` if unsaved |
| **errors/warnings** | LSP diagnostic counts (red/yellow) |
| **⚡N** | Unresolved merge conflict count — only shown when file has conflicts |
| **filetype** | Detected language |
| **venv** | Active Python venv name (Python files only) |
| **line:col** | Cursor position |
| **HH:MM** | Current time |

---

## Python — Virtual Environment & LSP

**basedpyright** is the Python LSP (stricter and faster than pyright). **ruff** handles formatting and import sorting.

### Venv auto-detection order

1. `VIRTUAL_ENV` or `CONDA_PREFIX` env var — if you activate venv before opening Neovim
2. Walk up the directory tree looking for `.venv`, `venv`, `env` folders
3. Scan one level of subdirectories (e.g. `monorepo/backend/.venv`)

### Best practice

```bash
cd ~/projects/my-app
source .venv/bin/activate
nvim .
```

The REPL and LSP both pick up the venv automatically.

### If auto-detection fails

```
:LspInfo     → shows which Python path basedpyright is using
<leader>lR   → restart LSP after activating a venv
```

### Formatting

```
<leader>cf   → format with ruff (equivalent to black + isort, 10-100x faster)
```

---

## Auto-tag — nvim-ts-autotag

Type an HTML/JSX opening tag → the closing tag appears automatically.

```
<div|       → becomes <div></div> with cursor inside
```

Rename the opening tag → closing tag renames automatically. Works in: HTML, JSX, TSX, Vue, Svelte, XML, Markdown, PHP.

---

## Doc Comments — Neogen

Generate documentation comment templates from function signatures automatically.

```
<leader>cg   → generate doc comment for function/class/type under cursor
```

| Language | Style | What it generates |
|---|---|---|
| Python | Google docstrings | `Args:`, `Returns:`, `Raises:` sections |
| TypeScript | TSDoc | `@param`, `@returns`, `@throws` |
| JavaScript | JSDoc | `@param`, `@returns` |
| Go | godoc | `// FuncName ...` style |
| C / C++ | Doxygen | `/// @brief`, `/// @param`, `/// @return` |

### Example (Python)

```python
def calculate_total(items: list[Item], tax_rate: float) -> float:
```

Press `<leader>cg` → becomes:

```python
def calculate_total(items: list[Item], tax_rate: float) -> float:
    """Calculate total.

    Args:
        items: ...
        tax_rate: ...

    Returns:
        ...
    """
```

---

## Marks

Visual indicators in the sign column for every mark you set. Makes marks visible and navigable.

### Setting marks

```
m{a-z}       → set mark at cursor (standard vim)
m,           → place the next available mark automatically
```

### Deleting marks

```
dm{a-z}      → delete specific mark
dm-          → delete all marks on current line
dm<space>    → delete all marks in buffer
```

### Navigating marks

```
m] / m[      → next / previous mark in buffer
m:           → preview all marks in a popup list
```

---

## Virt-column — Line Length Guide

A faint `│` character marks the line length guide. Per-filetype columns:

| Filetype | Columns | Standard |
|---|---|---|
| Python | 79, 88 | PEP 8 / Black |
| Go | 100, 120 | Go community |
| C / C++ | 80, 100 | K&R / embedded |
| Markdown / text | 72, 80 | Prose conventions |
| Everything else | 80, 120 | General default |

---

## Scroll-past-EOF — Dynamic Scrolloff

When your cursor is near the bottom of a file, `scrolloff` automatically increases so the last line stays centered with empty space below — matching VSCode's `scrollBeyondLastLine`.

Disabled in panel buffers (neo-tree, oil, trouble, etc.) to avoid unnecessary computation.

---

## Neoconf — Per-project LSP Settings

Drop a `.neoconf.json` file at your project root to override LSP settings for that specific project without touching the global config.

```json
{
  "basedpyright": {
    "analysis": {
      "typeCheckingMode": "strict"
    }
  },
  "vtsls": {
    "typescript": {
      "preferences": {
        "quoteStyle": "double"
      }
    }
  }
}
```

Neoconf loads before LSP servers start, so settings apply immediately when you open a file. Commit `.neoconf.json` to share settings with your team.

---

## Auto-save

Files save **automatically** — no need to press `<C-s>` constantly.

| Event | Delay |
|---|---|
| You stop typing | After 1.5 seconds |
| Switch to another buffer | Instantly |
| Neovim loses focus | Instantly |
| Leave insert mode (`jk`/`Esc`) | After 1.5 seconds |

Not saved: Neo-tree/Lazy/Mason windows, read-only files, new unnamed buffers.

Manual save still works: `<C-s>`

---

## Web & Devops Stacks

LSP, treesitter, and formatting are wired for these stacks (via LazyVim extras) in addition to TS/JS/Python/Go:

| Stack | What you get |
|-------|--------------|
| **Tailwind CSS** | Class completion + sorting + color swatches. The Tailwind LSP attaches only when the project has a `tailwind.config.{js,ts,cjs}` (or v4 `@import "tailwindcss"`). |
| **Prisma** | `schema.prisma` LSP — completion, format, validation. |
| **Docker** | `Dockerfile` LSP + `docker-compose.yml` schema + hadolint linting. |
| **YAML** | yaml-language-server with schema validation (GitHub Actions, compose, k8s, etc.). |

Tailwind class highlighting (colored backgrounds) is also on in TS/JS/CSS/HTML via the colorizer.

---

## Surround — mini.surround

Add, change, or delete the pairs around text. Uses a `gs` prefix so it never clobbers vim's `s`.

```
gsaiw"   → surround inner word with "        (gsa = add)
gsd"     → delete surrounding "              (gsd = delete)
gsr"'    → replace surrounding " with '      (gsr = replace)
gsf / gsF → jump to next / previous surround
```

Works in visual mode too: select text, then `gsa)` to wrap in parens.

---

## Split / Join Blocks — treesj

Toggle a code block between one line and multiple lines using treesitter (objects, arrays, argument lists, function bodies).

```
<leader>cj   → toggle split ⇄ join on the block under the cursor
```

Great for collapsing a multi-line TS object to one line, or exploding a long Go struct literal.

---

## Markdown Image Paste & Tables

Beyond preview (`<leader>mp`):

```
<leader>mi   → paste an image from the clipboard into the .md file
               (saved under ./assets/, a ![](path) link is inserted)
<leader>mt   → toggle table mode (type | separators → columns auto-align)
```

---

## Git Diff Presets (Diffview)

In addition to the existing `<leader>gd` / `<leader>gD`:

```
<leader>gdm  → diff the whole branch vs origin/main   (review before PR)
<leader>gdM  → diff the whole branch vs local main
```

Hunk-level git (stage/reset/preview/blame, `]h`/`[h`) is provided by gitsigns under `<leader>gh*`.

---

## Incremental Selection (treesitter)

Grow/shrink the selection by syntax node — no plugin needed, built into the treesitter config:

```
<C-space>   → expand selection to the next larger node
<BS>        → shrink selection back down
```

---

## How to Customize

### Disable a plugin

In the relevant plugin file, add `enabled = false`:

```lua
{ "some/plugin.nvim", enabled = false }
```

### Add a new plugin

Create a new file in `lua/plugins/` or add to an existing one:

```lua
return {
  {
    "author/plugin.nvim",
    event = "BufReadPost",
    opts = { option = "value" },
  },
}
```

### Change a keymap

In `lua/config/keymaps.lua`:

```lua
map("n", "<leader>xx", "<cmd>SomeCommand<cr>", { desc = "Description" })
```

### Add a new LazyVim extra

In `lua/config/lazy.lua`, add to the spec:

```lua
{ import = "lazyvim.plugins.extras.lang.rust" },
```

Run `:Lazy sync` after.

### Per-project LSP settings

Create `.neoconf.json` at the project root (see [Neoconf section](#neoconf--per-project-lsp-settings)).

---

## Complete Keybinding Reference

### File & Search

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fr` | Recent files |
| `<leader>fb` | Switch buffers |
| `<leader>/` | Live grep (search in files) |
| `<leader>fw` | Search word under cursor |
| `<leader>fs` | Search visual selection |
| `<leader>ft` | Search TODOs |
| `<leader>ss` | Symbols in file |
| `<leader>sS` | Symbols in project |
| `<leader>sk` | Search keymaps |
| `<leader>fp` | Project switcher |
| `<leader>fy` | Yank history |
| `<leader>uT` | Switch theme |

### Navigation

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | All references (fzf-lua) |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `<C-f> / <C-b>` | Scroll hover/signature docs down/up |
| `<leader>cd` | Show diagnostic float |
| `]d / [d` | Next/prev diagnostic |
| `[g / ]g` | Prev/next git hunk |
| `]h / [h` | Next/prev Harpoon file |
| `]m / [m` | Next/prev function |
| `]k / [k` | Next/prev class |
| `]t / [t` | Next/prev TODO |
| `]x / [x` | Next/prev git conflict |
| `{ / }` | Prev/next aerial symbol |
| `<leader>uu` | Toggle undo tree |
| `-` | Oil (parent directory) |

### Code

| Key | Action |
|-----|--------|
| `<leader>ca` | Code actions |
| `<leader>cr` | Rename symbol (live preview) |
| `<leader>cf` | Format file |
| `<leader>cg` | Generate doc comment |
| `<leader>cs` | Code outline (aerial) |
| `<leader>Re` | Extract to function (visual) |
| `<leader>Rv` | Extract to variable (visual) |
| `<leader>Ri` | Inline variable |
| `<leader>RE` | Extract function to a new file |
| `<leader>RI` | Inline function |
| `<leader>Rr` | Pick refactor from menu |
| `<leader>as` | Swap argument right |
| `<leader>aS` | Swap argument left |
### Harpoon (Fast file switching)

| Key | Action |
|-----|--------|
| `<leader>H` | Add current file to Harpoon |
| `<leader>h` | Open Harpoon quick menu |
| `<leader>1` | Jump to Harpoon file 1 |
| `<leader>2` | Jump to Harpoon file 2 |
| `<leader>3` | Jump to Harpoon file 3 |
| `<leader>4` | Jump to Harpoon file 4 |
| `[h` | Previous Harpoon file |
| `]h` | Next Harpoon file |

### Git

| Key | Action |
|-----|--------|
| `<leader>gg` | Open Lazygit (root dir) |
| `<leader>gG` | Open Lazygit (cwd) |
| `<leader>gb` | Git Blame Line |
| `<leader>gc` | Git commits |
| `<leader>gB` | Git branches |
| `<leader>gs` | Git status |
| `<leader>gS` | Git stash |
| `<leader>ge` | Git explorer |
| `<leader>gd` / `<leader>gdo` | Diffview Open (all changes) |
| `<leader>gdc` | Close Diffview |
| `<leader>gdd` | Diffview vs last commit (HEAD~1) |
| `<leader>gdm` | Diff branch vs origin/main (or master) |
| `<leader>gdM` | Diff branch vs local main (or master) |
| `<leader>gdh` | File history (current file) |
| `<leader>gdH` | File history (project) |
| `<leader>gx` | List merge conflicts in quickfix |
| `[g / ]g` | Prev/next git hunk |
| `co / ct` | Conflict: choose ours/theirs |
| `cb / c0` | Conflict: choose both/none |

### Terminal & REPLs

| Key | Action |
|-----|--------|
| `<C-\>` | Toggle floating terminal |
| `<leader>Tf` | Terminal float |
| `<leader>Th` | Terminal horizontal |
| `<leader>Tv` | Terminal vertical |
| `<leader>po` | Python: open REPL |
| `<leader>pr` | Python: restart REPL |
| `<leader>ph` | Python: hide REPL |
| `<leader>pl` | Python: send line |
| `<leader>pv` | Python: send selection |
| `<leader>pf` | Python: send file |
| `<leader>pc` | Python: clear REPL |
| `<leader>jo` | Node: open REPL |
| `<leader>jr` | Node: restart REPL |
| `<leader>jh` | Node: hide REPL |
| `<leader>jl` | Node: send line |
| `<leader>jv` | Node: send selection |
| `<leader>jf` | Node: send file |
| `<leader>jc` | Node: clear REPL |

### Buffers & Windows

| Key | Action |
|-----|--------|
| `<Tab> / <S-Tab>` | Next/prev buffer |
| `H / L` | Prev/next buffer |
| `<leader>bd` | Close current buffer |
| `<leader>bo` | Close other buffers |
| `<leader>e` | Toggle file explorer (root dir) |
| `<leader>E` | Toggle file explorer (cwd) |
| `<leader>-` | Split horizontal |
| `<leader>\|` | Split vertical |
| `<C-h/j/k/l>` | Move between windows (normal & terminal mode) |
| `<A-arrows>` | Resize splits |
| `<leader>w+/-` | Resize height |
| `<leader>w>/<` | Resize width |
| `<leader>w=` | Equalize windows |
| `> / <` (Neo-tree) | Widen/narrow explorer |

### Editing

| Key | Action |
|-----|--------|
| `jk` | Exit insert mode |
| `<C-s>` | Save file |
| `<Alt+j/k>` | Move line down/up |
| `> / <` (visual) | Indent right/left |
| `<leader>A` | Select all |
| `p` (visual) | Paste over selection (no clipboard loss) |
| `<M-p> / <M-n>` | Cycle yank history |
| `<leader>fy` | Browse yank history |
| `<C-n>` | Multi-cursor: select next |
| `<C-Down/Up>` | Multi-cursor: cursor below/above |

### UI Toggles

| Key | Action |
|-----|--------|
| `<leader>uz` | Toggle Zen Mode |
| `<leader>uZ` / `<leader>wm` | Toggle Zoom (maximize split) |
| `<leader>uD` | Toggle Dimming |
| `<leader>uR` | Toggle Illuminate (word highlights) |
| `<leader>uh` | Toggle inlay hints |
| `<leader>uw` | Toggle word wrap |
| `<leader>uu` | Toggle Undo Tree |
| `<leader>uC` | Switch colorscheme (with live preview) |
| `zp` | Peek fold |
| `zR / zM` | Open/close all folds |

### Session & Project

| Key | Action |
|-----|--------|
| `<leader>qs` | Restore session |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Stop saving session |
| `<leader>fp` | Projects picker |
| `<leader>sr` | Project search & replace (grug-far) |
| `<leader>cL` | Restart LSP |
| `<leader>Pp` | Toggle package versions (`package.json`) |
| `<leader>Pu` | Update package (`package.json`) |
| `<leader>Pd` | Delete package (`package.json`) |
| `<leader>Pi` | Install package (`package.json`) |
| `<leader>Pc` | Change package version (`package.json`) |

### Marks

| Key | Action |
|-----|--------|
| `m{a-z}` | Set mark |
| `m,` | Set next available mark |
| `dm{a-z}` | Delete mark |
| `dm-` | Delete marks on line |
| `dm<space>` | Delete all marks in buffer |
| `m] / m[` | Next/prev mark |
| `m:` | Preview all marks |

### Markdown

| Key | Action |
|-----|--------|
| `<leader>mp` | Browser preview (live reload) |
| `<leader>mi` | Paste image from clipboard |
| `<leader>mt` | Toggle table mode |

### Commands

| Command | Action |
|---------|--------|
| `:Format` | Format current buffer via Conform |
| `:ReloadConfig` | Reload all config + plugin modules (run `:Lazy sync` after) |
