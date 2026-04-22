# Neovim Config — Complete Reference

A modern Neovim setup built on **LazyVim** for TypeScript/JavaScript, Python, Go, and **C/C++ IoT/Embedded** development.
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
10. [Peek Definition — goto-preview](#peek-definition--goto-preview)
11. [Completion & Ghost Text](#completion--ghost-text)
12. [Git Integration](#git-integration)
13. [Git Diff Viewer — Diffview](#git-diff-viewer--diffview)
14. [Merge Conflicts — git-conflict](#merge-conflicts--git-conflict)
15. [GitHub — Octo](#github--octo)
16. [Terminal](#terminal)
17. [Test Runner — Neotest](#test-runner--neotest)
18. [Test Coverage](#test-coverage)
19. [Project Search & Replace — grug-far](#project-search--replace--grug-far)
20. [REST Client — Kulala](#rest-client--kulala)
21. [Python REPL — Iron](#python-repl--iron)
22. [Node.js REPL — Iron](#nodejs-repl--iron)
23. [Undo Tree](#undo-tree)
24. [Session Management](#session-management)
25. [Multi-cursor](#multi-cursor)
26. [Text Objects](#text-objects)
27. [Refactoring](#refactoring)
28. [Project Switcher](#project-switcher)
29. [Zen Mode & Twilight](#zen-mode--twilight)
30. [Code Outline — Aerial](#code-outline--aerial)
31. [Live Rename — inc-rename](#live-rename--inc-rename)
32. [Better Folds — UFO](#better-folds--ufo)
33. [Tabout](#tabout)
34. [Color Highlighter](#color-highlighter)
35. [Package Info](#package-info)
36. [Wakatime — Coding Time Tracker](#wakatime--coding-time-tracker)
37. [Debugger — DAP](#debugger--dap)
38. [IoT / Embedded Development — PlatformIO](#iot--embedded-development--platformio)
39. [TODO Comments](#todo-comments)
40. [Markdown](#markdown)
41. [Themes](#themes)
42. [Panel Layout — Edgy](#panel-layout--edgy)
43. [Breadcrumbs — Dropbar](#breadcrumbs--dropbar)
44. [Sticky Context Header](#sticky-context-header)
45. [Inline Git Blame](#inline-git-blame)
46. [Code Action Lightbulb](#code-action-lightbulb)
47. [Yank History — Yanky](#yank-history--yanky)
48. [Better Quickfix — nvim-bqf](#better-quickfix--nvim-bqf)
49. [Smarter Word Motions — Spider](#smarter-word-motions--spider)
50. [Hardtime — Break Bad Habits](#hardtime--break-bad-habits)
51. [Buffers & Windows](#buffers--windows)
52. [Editing Shortcuts](#editing-shortcuts)
53. [Statusline](#statusline)
54. [Python — Virtual Environment & LSP](#python--virtual-environment--lsp)
55. [Auto-tag — nvim-ts-autotag](#auto-tag--nvim-ts-autotag)
56. [Doc Comments — Neogen](#doc-comments--neogen)
57. [Marks](#marks)
58. [Function Arg Highlight — Hlargs](#function-arg-highlight--hlargs)
59. [Floating Split Labels — Incline](#floating-split-labels--incline)
60. [Mode Colors](#mode-colors)
61. [Noice — Centered Cmdline](#noice--centered-cmdline)
62. [Biscuits — Closing Brace Labels](#biscuits--closing-brace-labels)
63. [Virt-column — Line Length Guide](#virt-column--line-length-guide)
64. [Cinnamon — Smooth Scroll](#cinnamon--smooth-scroll)
65. [Scroll-past-EOF — Dynamic Scrolloff](#scroll-past-eof--dynamic-scrolloff)
66. [Neoconf — Per-project LSP Settings](#neoconf--per-project-lsp-settings)
67. [Auto-save](#auto-save)
68. [How to Customize](#how-to-customize)
69. [Complete Keybinding Reference](#complete-keybinding-reference)

---

## Prerequisites & Installation

### Required tools

```bash
# macOS — install with Homebrew
brew install neovim git node ripgrep fzf lazygit

# For Python REPL (ts-node optional, for TypeScript REPL)
npm install -g ts-node          # optional: TypeScript REPL support
pip install sqlite3             # for persistent yank history

# For IoT/embedded
brew install open-ocd           # ESP32 debugging via OpenOCD
# probe-rs: https://probe.rs/docs/getting-started/installation/

# Verify versions
nvim --version     # needs 0.10+
node --version     # needs 18+
rg --version       # ripgrep for grep search
lazygit --version  # git TUI
```

### First launch

```bash
# 1. Open Neovim — plugins install automatically
nvim

# 2. Wait for lazy.nvim to finish (~1 min first time)
# 3. Compile Kanagawa theme (do this once)
:KanagawaCompile

# 4. Install LSP servers, formatters, debuggers
:Mason
# Press i next to: basedpyright, gopls, vtsls, clangd, gofumpt, stylua, ruff
# Debuggers: debugpy, delve, js-debug-adapter

# 5. Verify everything works
:checkhealth
```

---

## Understanding Neovim Basics

Neovim is **modal** — different modes for different tasks. This is the most important concept.

### Modes

| Mode            | How to Enter  | What it Does                              |
| --------------- | ------------- | ----------------------------------------- |
| **Normal**      | `Esc` or `jk` | Navigate, run commands. **Default mode.** |
| **Insert**      | `i` `a` `o`   | Type text. Navigate with arrow keys `←↑↓→` |
| **Visual**      | `v`           | Select characters                         |
| **Visual Line** | `V`           | Select whole lines                        |
| **Command**     | `:`           | Run vim commands like `:w`, `:q`          |

> **Rule:** Always return to Normal mode when not actively typing. Everything powerful happens in Normal mode.

### Essential Motions

```
h j k l      → left / down / up / right  (Normal mode cursor movement)
←↑↓→         → same as hjkl  (also work in Insert mode)
w            → next word start
b            → previous word start
e            → end of current word
0            → start of line
$            → end of line
gg           → top of file
G            → bottom of file
5j           → 5 lines down (any number + motion)
Ctrl+d       → scroll half page down
Ctrl+u       → scroll half page up
zh / zl      → scroll viewport left / right  (does NOT move cursor)
```

### Navigation in Insert Mode

In Insert mode, `h`/`j`/`k`/`l` type those characters — they are not navigation keys.
To move while staying in Insert mode, use the **arrow keys** (`←↑↓→`).

The recommended vim workflow is:
```
1. jk          → exit Insert mode (go to Normal)
2. hjkl / w/b  → navigate to where you want
3. i / a / o   → re-enter Insert mode
```

This is faster than reaching for arrows once you're used to it, but arrow keys are fully available when you need them.

### Operators + Motions

```
d            → delete
y            → yank (copy)
c            → change (delete + enter insert)

dw           → delete word        yy → yank line
d$           → delete to end      dd → delete line
ciw          → change inner word  di" → delete inside quotes
```

### Undo / Redo

```
u            → undo
Ctrl+r       → redo
```

---

## File Structure

```
~/.config/nvim/
├── init.lua                  ← Entry point — loads lua/config/lazy.lua
│
└── lua/
    ├── config/
    │   ├── lazy.lua          ← Plugin manager + enabled LazyVim extras
    │   ├── options.lua       ← Editor settings (scrolloff, cmdheight, winborder…)
    │   ├── keymaps.lua       ← Custom keybindings + which-key group labels
    │   └── autocmds.lua      ← Autocommands (session restore, scrolloff, virt-column)
    │
    └── plugins/
        ├── coding.lua        ← UFO folds, refactoring, autotag, neogen, tabout,
        │                        treesitter textobjects, various textobjs,
        │                        ts-error-translator, blink.cmp ghost text
        ├── colorscheme.lua   ← Kanagawa wave (default) + catppuccin, tokyonight,
        │                        rose-pine, oxocarbon, cyberdream
        ├── dap.lua           ← Debugger: Python, Go, TS/JS, IoT (probe-rs + OpenOCD)
        ├── editor.lua        ← Neoconf, hardtime, todo-comments, diagnostics,
        │                        gitsigns blame, neo-tree, oil, smooth scroll,
        │                        peek definition (goto-preview)
        ├── extras.lua        ← Yanky, vim-visual-multi, nvim-bqf,
        │                        persistence, marks, twilight, zen mode
        ├── git-advanced.lua  ← Diffview, git-conflict, Octo (GitHub PRs/issues)
        ├── iot.lua           ← PlatformIO (ESP32/STM32/RP2040) + clangd_extensions
        ├── lsp.lua           ← vtsls, gopls, basedpyright, gofumpt, stylua settings
        ├── python.lua        ← basedpyright venv detection, ruff formatter, iron.nvim REPL
        ├── rest.lua          ← Kulala HTTP/REST client
        ├── search.lua        ← fzf-lua config + hlslens search lens
        ├── terminal.lua      ← Snacks terminal + snacks.input
        ├── testing.lua       ← Neotest (Jest/Vitest/pytest/Go) + nvim-coverage
        ├── ui.lua            ← Edgy, treesitter-context, fidget, lualine,
        │                        lightbulb, noice, mini.indentscope
        ├── ui-extras.lua     ← Dropbar breadcrumbs, colorizer, package-info, wakatime
        ├── undotree.lua      ← Undo history tree
        └── visuals.lua       ← Smear cursor, rainbow delimiters, scrollbar,
                                 incline, modes, biscuits, virt-column, hlargs,
                                 illuminate, mini.animate
```

### LazyVim extras active (`lua/config/lazy.lua`)

| Extra | What it provides |
|---|---|
| `lang.typescript` | vtsls, eslint, prettier, TS/JS inlay hints |
| `lang.python` | basedpyright, ruff |
| `lang.go` | gopls, gofmt/gofumpt |
| `lang.json` | jsonls, schema validation |
| `formatting.prettier` | Prettier for TS/JS/CSS/HTML |
| `lang.markdown` | LSP, treesitter, render |
| `test.core` | Neotest framework |
| `editor.aerial` | Code outline panel |
| `editor.inc-rename` | Live rename preview |
| `editor.fzf` | fzf-lua as the LazyVim picker |

---

## The Leader Key & Which-Key

**Leader key is `Space`**. Press it and wait 300ms — a popup shows all available commands grouped by category.

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

### Two modes

```
<leader>e    → toggle explorer (always shows full project root / cwd)
<leader>o    → focus mode — roots tree at nearest package/module root
               Press again → returns to full project root
```

**When to use which:**

| Situation | Key |
|---|---|
| Browse the whole project | `<leader>e` |
| Deep in a monorepo, want just the current package | `<leader>o` |
| Done with focus, back to full view | `<leader>o` again |

Focus mode walks up from your file looking for `package.json`, `tsconfig.json`, `Cargo.toml`, `go.mod`, `pyproject.toml` or `.git`.

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
-            → open parent directory of current file in oil
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
| C/C++ | `clangd` | IoT/embedded, clangd_extensions for extras |

### Navigation

```
gd           → go to definition (jumps there)
gp           → peek definition (floating window, you stay put)
gpt          → peek type definition
gpr          → peek all references
gpi          → peek implementation (TS/Go only)
gpc          → close all peek windows
K            → hover documentation (type, docstring, signature)
gr           → all references (fzf list)
```

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

Always-on in TypeScript, JavaScript, Go, and C/C++:
- Parameter names at call sites: `createUser(data:` → `createUser(data: CreateUserDto`
- Variable types: `const x =` → `const x: string =`
- Return types, enum values, composite literal field names

### LSP management

```
:LspInfo       → which servers are running for current file
:Mason         → install/uninstall language servers and tools
<leader>lR     → restart all LSP servers (when completions/hints stop working)
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

## Peek Definition — goto-preview

Shows definitions and references in a **floating window** without leaving your current position.

```
gp           → peek definition
gpt          → peek type definition
gpr          → peek all references
gpi          → peek implementation (TS/Go only — checks if server supports it)
gpc          → close all peek windows
Esc          → close peek window when inside it
```

### gd vs gp

| Key  | Behavior |
|------|----------|
| `gd` | Jumps to definition — you leave your current file |
| `gp` | Peeks at definition — stays floating, your file unchanged |

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

---

## Git Integration

### Lazygit — full git UI

```
<leader>gg   → open lazygit (full screen)
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

## GitHub — Octo

Browse and manage GitHub PRs and issues without leaving Neovim.

### Setup (one-time)

```bash
brew install gh
gh auth login
```

### Opening Octo

```
<leader>gop   → list all open PRs
<leader>goi   → list all open issues
<leader>gor   → start PR review (add comments, approve, request changes)
<leader>gom   → merge current PR
```

Or use `:Octo` directly:

```
:Octo pr list
:Octo issue list
:Octo pr checkout 42
:Octo review start
:Octo pr merge
```

### Inside a PR view

```
<leader>ca   → add comment
Tab          → next file in PR diff
]c / [c      → next/previous comment thread
q            → close
```

---

## Terminal

```
<C-\>        → toggle floating terminal (press again to hide)
<leader>th   → horizontal split terminal (bottom)
<leader>tv   → vertical split terminal (right)
```

### Exiting terminal mode

When the terminal opens you are in terminal INSERT mode — keystrokes go to the shell.

```
<C-\><C-n>   → exit to Normal mode (RELIABLE — always works)
Esc Esc      → same thing (may not work if noice intercepts)
```

### After entering Normal mode inside terminal

```
Ctrl+h/j/k/l → move to another window (terminal stays open)
<C-\>        → hide the terminal
j / k        → scroll through terminal output
```

> **Key point:** Hiding with `<C-\>` does NOT kill the process. The shell keeps running in the background.

---

## Test Runner — Neotest

Run tests without leaving Neovim. Auto-detects Jest/Vitest/pytest/Go test.

### Running tests

```
<leader>tt   → run nearest test (cursor inside the test function)
<leader>tf   → run all tests in current file
<leader>tl   → re-run last test
<leader>ta   → run entire test suite (all files)
<leader>tW   → watch nearest test (re-runs on file save)
<leader>tS   → stop running test
```

### Viewing results

```
<leader>ts   → toggle test summary panel (tree of all tests, pass/fail/skip)
<leader>to   → toggle test output panel (stdout, error messages)
]f           → jump to next FAILED test
[f           → jump to previous FAILED test
```

### Result icons in your code

```
 (green)   → passed
 (red)     → failed
 (yellow)  → running
 (grey)    → skipped
```

### Language-specific

**TypeScript/JavaScript:**
- Auto-detects Jest (`jest.config.*`) or Vitest (`vitest.config.*`)
- Monorepo-aware: finds the nearest `jest.config.*` up from the file
- Runs via `npx jest` or `npx vitest`

**Python:**
- Uses pytest
- Works with virtual environments (auto-detected)
- Debug test method: `<leader>dtm` · Debug test class: `<leader>dtc`

**Go:**
- Runs with `-count=1 -timeout=60s`
- Debug test: `<leader>dgt` · Debug last test: `<leader>dgl`

---

## Test Coverage

Run tests with coverage instrumentation and display results inline in your code.

### Run with coverage

```
<leader>tT   → run current file tests with coverage instrumentation
               Python: uses --cov --cov-report=json:/tmp/coverage.json
               Go:     uses -coverprofile=/tmp/go-coverage.out
```

### Display coverage

```
<leader>tc   → toggle coverage signs in gutter (▎ green=covered, red=uncovered, yellow=partial)
<leader>tC   → coverage summary (shows % per file, highlights files below 80%)
```

### Workflow

```
1. <leader>tT  → run with coverage
2. <leader>tc  → toggle gutter signs — see which lines are untested (red ▎)
3. Write tests for the red lines
4. <leader>tT again → signs update
5. <leader>tC  → check if all files are above 80%
```

**Python setup:** `pip install pytest-cov`
**Go:** built-in, no setup needed

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

## REST Client — Kulala

Write and run HTTP requests in `.http` or `.rest` files. Response opens in a vertical split. JSON auto-formatted with `jq`.

> **Note:** All `<leader>r*` keys only appear in `.http` / `.rest` files. In other files, `<leader>r` is not mapped.

### Create a request file

```http
@baseUrl = http://localhost:3000
@token   = my-jwt-token

### Health check
GET {{baseUrl}}/health

### Get all workflows
GET {{baseUrl}}/workflows
Authorization: Bearer {{token}}

### Create workflow
POST {{baseUrl}}/workflows
Content-Type: application/json

{
  "name": "charge-card",
  "steps": []
}

### Delete workflow
DELETE {{baseUrl}}/workflows/{{workflowId}}
```

Variables defined with `@` show their values inline automatically.

### Running requests

Place cursor inside any request block:

```
<leader>rr   → run request under cursor
<leader>ra   → run ALL requests sequentially
<leader>rp   → replay last request (re-run without moving cursor)
<leader>ri   → inspect request (see full URL, headers, body before sending)
<leader>rc   → copy as cURL command
]r           → jump to next request
[r           → jump to previous request
```

### Viewing the response

```
<leader>rv   → cycle through: Body → Headers → Stats
<leader>rS   → show timing stats (time to first byte, total)
```

### Environments

Create `kulala.env.json` in the project root:

```json
{
  "dev": {
    "baseUrl": "http://localhost:3000",
    "token": "dev-token"
  },
  "staging": {
    "baseUrl": "https://staging.example.com",
    "token": "staging-token"
  }
}
```

```
<leader>re   → open environment picker → select dev / staging / prod
<leader>rs   → open scratchpad (temporary .http buffer, not saved)
<leader>rf   → import from cURL (paste a curl command, convert to .http format)
```

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

Works exactly like VS Code's `Ctrl+D`.

### Select occurrences

```
<C-n>        → select word under cursor
             → press again to add the NEXT occurrence
             → keep pressing to add more
<C-x>        → skip current occurrence, jump to next  (like VS Code Ctrl+K Ctrl+D)
<C-q>        → remove last added cursor
\\A          → select ALL occurrences at once  (\\ is the VM leader)
```

### Add cursors vertically

```
<C-Down>     → add cursor on line below
<C-Up>       → add cursor on line above
```

### Once cursors are active

All normal Neovim editing applies to all cursors simultaneously:

```
i / a        → insert / append at all cursors
c            → change at all cursors
d            → delete at all cursors
I / A        → insert at start/end of all lines
Esc          → exit multi-cursor mode
```

### Example — rename a variable

```
1. Cursor on `userData`
2. <C-n>                → selects first match
3. <C-n> again          → adds next match
4. Keep pressing or \\A → all matches selected
5. c                    → delete all and enter insert
6. Type `userInfo`      → all cursors type simultaneously
7. Esc                  → done
```

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
<leader>Rv   → (visual) extract selected expression to a new variable
<leader>Ri   → (normal/visual) inline a variable back into its usages
<leader>Rb   → (normal) extract current block to a new function
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

## Zen Mode & Twilight

### Zen Mode — distraction-free writing

Hides everything except your code. Centers text. Good for deep focus.

```
<leader>z    → toggle zen mode
```

When active: file explorer hides · statusline hides · tabs hide · code is centered. All keymaps still work.

### Twilight — dim inactive code

Dims everything outside your current function/block to 25% opacity. Keeps focus on the active code without full zen mode.

```
<leader>tw   → toggle Twilight
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
<leader>np   → toggle showing package versions
<leader>nu   → update package under cursor to latest
<leader>nd   → delete package under cursor
<leader>ni   → install a new package
<leader>nc   → change version of package under cursor
```

---

## Wakatime — Coding Time Tracker

Runs silently in the background. Tracks time by project, language, file. View stats at wakatime.com.

### First-time setup

1. Sign up at wakatime.com (free)
2. Get your API key from the dashboard
3. In Neovim: `:WakaTimeApiKey` → paste key → Enter
4. Tracking starts automatically

---

## Debugger — DAP

Step through code, inspect variables, set breakpoints. Supports Python, Go, TypeScript/JavaScript, and IoT (C/C++ via probe-rs and OpenOCD).

### First-time setup

```
:Mason
```

Install: `debugpy` (Python) · `delve` (Go) · `js-debug-adapter` (TS/JS)

For IoT: install `probe-rs` from probe.rs and `open-ocd` via Homebrew.

### UI layout when debugging

```
┌──────────────────────────┬─────────────────────────────────────┐
│  Variables               │                                     │
│  items = [...]           │           YOUR CODE                 │
│  total = 0               │                                     │
│                          │   ▶  current line (with arrow)      │
│  Breakpoints             │      variable values shown inline   │
│  file.py:42  ●           │                                     │
│                          │                                     │
│  Call Stack              │                                     │
│  calculate  line 42      │                                     │
│  main       line 10      │                                     │
│                          │                                     │
│  Watches                 │                                     │
│  (type expressions)      │                                     │
└──────────────────────────┴─────────────────────────────────────┘
│  REPL — evaluate expressions  │  Console — print() output here │
└───────────────────────────────┴────────────────────────────────┘
```

### Controls

```
<F5>         → start / continue to next breakpoint
<F10>        → step OVER (run next line, don't enter functions)
<F11>        → step INTO (enter the function being called)
<F12>        → step OUT  (finish current function, return to caller)
<leader>dc   → run to cursor (skip ahead to cursor position)
<leader>dq   → stop debugging
<leader>dr   → restart session
<leader>du   → toggle UI open/close
```

### Breakpoints

```
<leader>db   → toggle breakpoint  ●  (red dot in gutter)
<leader>dB   → conditional breakpoint  ◆  (only pauses if condition is true)
               e.g. enter condition: total > 100
<leader>dl   → log point  ◎  (print a message WITHOUT pausing)
```

### Inspecting values

```
<leader>de   → evaluate expression under cursor (or visual selection) in a popup
<leader>dh   → hover to see variable value
```

### Step over vs step into

```python
result = calculate_total(items)   # cursor here
```

| Key | What happens |
|-----|---|
| `<F10>` step OVER | Runs `calculate_total()` completely, moves to next line. Use when you trust the function. |
| `<F11>` step INTO | Enters `calculate_total()` so you can debug inside it. Use when the bug is in there. |
| `<F12>` step OUT  | Finishes current function, returns to caller. Use to escape a function you stepped into. |

### Breakpoint signs

```
●  red    → normal breakpoint (always pauses)
◆  blue   → conditional breakpoint
◎  teal   → log point (prints, does not pause)
▶  green  → current line being executed
```

### Python-specific

```
<leader>dtm  → debug current test METHOD under cursor
<leader>dtc  → debug current test CLASS
```

### Go-specific

```
<leader>dgt  → debug current Go test function
<leader>dgl  → debug last Go test
```

### `.vscode/launch.json` support

If your project has a `.vscode/launch.json`, it's loaded automatically at the start of every debug session. No manual setup needed.

### Conditional breakpoint example

```python
for item in items:   # set conditional breakpoint: item.price > 100
```

1. `<leader>dB` → type condition `item.price > 100` → Enter
2. Debugger skips all items with price ≤ 100, only pauses when > 100

---

## IoT / Embedded Development — PlatformIO

For ESP32, Arduino, STM32, Raspberry Pi Pico (RP2040/RP2350). Requires `pip install platformio`.

### First-time project setup

```
<leader>ioi  → init project (board picker, selects framework automatically)
```

Then write code in `src/main.cpp`.

```
<leader>ioc  → generate compile_commands.json (run once for LSP support)
<leader>iog  → generate .clangd   (run once — suppresses cross-compiler LSP errors)
:LspRestart  → pick up the new .clangd
```

### Build and upload

```
<leader>iob  → build
<leader>iou  → upload to device
<leader>iom  → serial monitor (see device output)
<leader>iod  → list connected devices
<leader>iol  → library manager
<leader>ios  → search boards
```

### C/C++ extras — clangd_extensions

```
gh           → switch between .h and .cpp instantly
<leader>ioH  → type hierarchy (what implements this class/struct?)
<leader>ioT  → AST view (expression/type structure)
```

### Debugging embedded devices

**probe-rs (STM32, RP2040/RP2350):**
1. Connect ST-Link / CMSIS-DAP / picoprobe via USB
2. Press `<F5>` → pick the matching debug config from the list

**OpenOCD (ESP32):**
```bash
# In a terminal first:
openocd -f board/esp32-wrover.cfg

# Then in Neovim:
# <F5> → pick "ESP32 — OpenOCD"
```

Edit the `chip` field in `lua/plugins/dap.lua` to match your exact chip: `STM32F103C8`, `STM32H743ZI`, `RP2350`, etc.

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
| **Kanagawa Wave** | `:colorscheme kanagawa` | **Default** — dark Japanese ink, compiled for fast startup |
| **Catppuccin Mocha** | `:colorscheme catppuccin` | Dark, pastel, full integrations (LSP, DAP, fzf, gitsigns, noice…) |
| **Oxocarbon** | `:colorscheme oxocarbon` | IBM Carbon, near-black + electric blue |
| **Cyberdream** | `:colorscheme cyberdream` | Cyberpunk neon |
| **Tokyonight Night** | `:colorscheme tokyonight` | Dark blue/purple |
| **Rose Pine** | `:colorscheme rose-pine` | Warm, earthy |

### Make permanent

Edit `lua/plugins/colorscheme.lua`:

```lua
{ "LazyVim/LazyVim", opts = { colorscheme = "kanagawa" } }
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

## Breadcrumbs — Dropbar

Navigation bar at the **top of every window** showing your current location:

```
src/services/user.service.ts › UserService › createUser
```

Powered by LSP (treesitter fallback). Each segment is clickable — press it to jump to that scope. Updates live as you move.

---

## Sticky Context Header

When you scroll deep into a function, the **function/class signature stays pinned at the top** of the window.

```
class UserService {           ← pinned (even 200 lines below)
  ─────────────────────────────
  ...200 lines of methods...

  async createUser(data):      ← cursor here
```

Shows up to 3 lines of context. Disappears when you scroll back to the top.

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

## Hardtime — Break Bad Habits

Notifies (does **not** block) when you repeat `h`/`j`/`k`/`l` more than 3 times in a row. Teaches more efficient navigation motions like `w`, `b`, `5j`, `}`.

```
<leader>uh   → toggle Hardtime on/off
```

**Arrow keys are fully enabled** — they work in Normal, Insert, and Visual mode without restriction.

Mode is `hint`: after 3 rapid repeats of the same motion key, a notification suggests a better motion. The keypress still registers — nothing is blocked.

Disabled automatically in panel buffers (neo-tree, DAP, oil, toggleterm, etc.) so it never interrupts you in tool windows.

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

## Function Arg Highlight — Hlargs

Function parameters get a distinct warm-amber color — visually different from regular local variables.

```python
def process(items, count, callback):   ← items, count, callback shown in warm orange
    result = []                        ← result shown in normal variable color
```

`self`, `cls`, and `_` are excluded from highlighting (they're not real arguments).

---

## Floating Split Labels — Incline

When you have multiple windows open side by side, each window shows a small floating label in its **top-right corner** with the file icon + name.

```
┌──────────────────────┐  ┌──────────────────────┐
│                      │  │              api.ts   │
│   user.service.ts    │  │                       │
│                      │  │                       │
```

- Only appears when more than one window is open
- Shows `●` if the file has unsaved changes
- Invisible in panels (neo-tree, aerial, DAP, etc.)

---

## Mode Colors

The cursorline color changes subtly based on your current Vim mode:

| Mode | Color |
|---|---|
| Normal | Subtle blue (crystalBlue) |
| Insert | Green (springGreen) |
| Visual | Purple (oniViolet) |
| Delete/Yank | Red/Yellow (samuraiRed/carpYellow) |

15% opacity — just enough to know your mode at a glance without being distracting.

---

## Noice — Centered Cmdline

Pressing `:` opens a clean centered floating dialog instead of the bottom cmdline bar. `/` search also uses it.

Filtered messages (don't appear as notifications):
- `"written"` — file save confirmations
- `"N lines yanked"` — yank messages
- `"search hit BOTTOM"` — search wrap messages
- `"Already at oldest/newest change"` — undo limit messages

---

## Biscuits — Closing Brace Labels

Shows a virtual text label at closing braces/brackets telling you what they close. Only appears when the opening is **12+ lines away**.

```typescript
class UserService {
  // ... 80 lines of methods ...
}  // class UserService  ← label appears here
```

Language-specific comment prefixes:

| Language | Prefix |
|---|---|
| Python | `  # ` |
| Go, TypeScript, JS, C, C++ | `  // ` |
| Lua | `  -- ` |

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

## Cinnamon — Smooth Scroll

`Ctrl+d`, `Ctrl+u`, `Ctrl+f`, `Ctrl+b`, and mouse scroll are animated smoothly — like VS Code.

Mouse scroll behavior: scrolls the **viewport** without moving the cursor (VSCode style).

---

## Scroll-past-EOF — Dynamic Scrolloff

When your cursor is near the bottom of a file, `scrolloff` automatically increases so the last line stays centered with empty space below — matching VSCode's `scrollBeyondLastLine`.

Disabled in panel buffers (neo-tree, DAP, oil, trouble, etc.) to avoid unnecessary computation.

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
| `gp` | Peek definition |
| `gpt` | Peek type definition |
| `gpr` | Peek references |
| `gpi` | Peek implementation |
| `gpc` | Close peek windows |
| `K` | Hover documentation |
| `gr` | All references |
| `<leader>cd` | Show diagnostic float |
| `]d / [d` | Next/prev diagnostic |
| `]h / [h` | Next/prev git hunk |
| `]m / [m` | Next/prev function |
| `]k / [k` | Next/prev class |
| `]f / [f` | Next/prev failed test |
| `]t / [t` | Next/prev TODO |
| `]r / [r` | Next/prev REST request |
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
| `<leader>Rb` | Extract block to function |
| `<leader>as` | Swap argument right |
| `<leader>aS` | Swap argument left |
| `<leader>uh` | Toggle Hardtime |

### Git

| Key | Action |
|-----|--------|
| `<leader>gg` | Open Lazygit |
| `<leader>gc` | Git commits (fzf) |
| `<leader>gB` | Git branches (fzf) |
| `<leader>gd` | Diffview (all changes) |
| `<leader>gD` | Diffview vs last commit |
| `<leader>gfh` | File history (current) |
| `<leader>gFH` | File history (project) |
| `<leader>gdc` | Close Diffview |
| `<leader>gx` | List conflicts in quickfix |
| `<leader>ghp` | Preview hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghb` | Blame current line |
| `<leader>gop` | Octo: list PRs |
| `<leader>goi` | Octo: list issues |
| `<leader>gor` | Octo: start PR review |
| `<leader>gom` | Octo: merge PR |
| `co / ct` | Conflict: choose ours/theirs |
| `cb / c0` | Conflict: choose both/none |

### Tests

| Key | Action |
|-----|--------|
| `<leader>tt` | Run nearest test |
| `<leader>tf` | Run all tests in file |
| `<leader>ta` | Run entire test suite |
| `<leader>tl` | Re-run last test |
| `<leader>tW` | Watch nearest test |
| `<leader>tS` | Stop test |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Toggle test output |
| `<leader>tT` | Run with coverage |
| `<leader>tc` | Toggle coverage signs |
| `<leader>tC` | Coverage summary |

### Debugger

| Key | Action |
|-----|--------|
| `<F5>` | Start / Continue |
| `<F10>` | Step Over |
| `<F11>` | Step Into |
| `<F12>` | Step Out |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dl` | Log point |
| `<leader>dc` | Run to cursor |
| `<leader>dq` | Stop debugging |
| `<leader>dr` | Restart session |
| `<leader>du` | Toggle DAP UI |
| `<leader>de` | Evaluate expression |
| `<leader>dh` | Hover variable |
| `<leader>dtm` | Debug Python test method |
| `<leader>dtc` | Debug Python test class |
| `<leader>dgt` | Debug Go test |
| `<leader>dgl` | Debug Go last test |

### Terminal & REPLs

| Key | Action |
|-----|--------|
| `<C-\>` | Toggle floating terminal |
| `<leader>th` | Terminal horizontal |
| `<leader>tv` | Terminal vertical |
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

### REST Client (`.http` / `.rest` files only)

| Key | Action |
|-----|--------|
| `<leader>rr` | Run request |
| `<leader>ra` | Run all requests |
| `<leader>rp` | Replay last request |
| `<leader>ri` | Inspect request |
| `<leader>rc` | Copy as cURL |
| `<leader>rv` | Toggle body/headers/stats |
| `<leader>rS` | Show response stats |
| `<leader>re` | Switch environment |
| `<leader>rs` | Open scratchpad |
| `<leader>rf` | Import from cURL |

### IoT / PlatformIO

| Key | Action |
|-----|--------|
| `<leader>ioi` | Init project |
| `<leader>iob` | Build |
| `<leader>iou` | Upload to device |
| `<leader>iom` | Serial monitor |
| `<leader>iod` | List devices |
| `<leader>iol` | Library manager |
| `<leader>ios` | Search boards |
| `<leader>ioc` | Generate compile_commands.json |
| `<leader>iog` | Generate .clangd |
| `<leader>ioH` | Type hierarchy (C/C++) |
| `<leader>ioT` | AST view (C/C++) |
| `gh` | Switch header/source (C/C++) |

### Buffers & Windows

| Key | Action |
|-----|--------|
| `<Tab> / <S-Tab>` | Next/prev buffer |
| `H / L` | Prev/next buffer |
| `<leader>bd` | Close current buffer |
| `<leader>bo` | Close other buffers |
| `<leader>e` | Toggle file explorer |
| `<leader>o` | Toggle explorer focus mode |
| `<leader>-` | Split horizontal |
| `<leader>\|` | Split vertical |
| `<C-h/j/k/l>` | Move between windows |
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
| `<leader>z` | Toggle Zen Mode |
| `<leader>tw` | Toggle Twilight |
| `<leader>ui` | Toggle Illuminate |
| `<leader>uh` | Toggle Hardtime |
| `<leader>uu` | Toggle Undo Tree |
| `<leader>uT` | Switch theme |
| `zp` | Peek fold |
| `zR / zM` | Open/close all folds |

### Session & Project

| Key | Action |
|-----|--------|
| `<leader>qs` | Restore session |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Stop saving session |
| `<leader>np` | Toggle package versions |
| `<leader>nu` | Update package |
| `<leader>nd` | Delete package |
| `<leader>ni` | Install package |
| `<leader>nc` | Change package version |
| `<leader>sr` | Project search & replace (grug-far) |
| `<leader>lR` | Restart LSP |

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
