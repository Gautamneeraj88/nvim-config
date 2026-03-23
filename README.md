# Neovim Config — Complete Guide

A modern, minimal Neovim setup built on **LazyVim** for TypeScript/JavaScript, Python, and Go.
Everything is documented here so you can learn and use every feature.

---

## Table of Contents

1. [Prerequisites & Installation](#prerequisites--installation)
2. [Understanding Neovim Basics](#understanding-neovim-basics)
3. [File Structure](#file-structure)
4. [The Leader Key & Which-Key](#the-leader-key--which-key)
5. [File Explorer — Neo-tree](#file-explorer--neo-tree)
6. [Fuzzy Search — fzf-lua](#fuzzy-search--fzf-lua)
7. [LSP — Code Intelligence](#lsp--code-intelligence)
8. [Diagnostics Panel — Trouble](#diagnostics-panel--trouble)
9. [Peek Definition — goto-preview](#peek-definition--goto-preview)
10. [Completion](#completion)
11. [Git Integration](#git-integration)
12. [Git Diff Viewer — Diffview](#git-diff-viewer--diffview)
13. [Merge Conflicts — git-conflict](#merge-conflicts--git-conflict)
14. [GitHub — Octo](#github--octo)
15. [Terminal](#terminal)
16. [Test Runner — Neotest](#test-runner--neotest)
17. [Project Find & Replace — Spectre](#project-find--replace--spectre)
18. [REST Client — Kulala](#rest-client--kulala)
19. [Undo Tree](#undo-tree)
20. [Session Management](#session-management)
21. [Multi-cursor](#multi-cursor)
22. [Project Switcher](#project-switcher)
23. [Zen Mode](#zen-mode)
24. [Code Outline — Aerial](#code-outline--aerial)
25. [Live Rename — inc-rename](#live-rename--inc-rename)
26. [Better Folds — UFO](#better-folds--ufo)
27. [Tabout](#tabout)
28. [Color Highlighter](#color-highlighter)
29. [Package Info](#package-info)
30. [Wakatime — Coding Time Tracker](#wakatime--coding-time-tracker)
31. [Debugger — DAP](#debugger--dap)
32. [Auto-save](#auto-save)
33. [TODO Comments](#todo-comments)
34. [Markdown](#markdown)
35. [Themes](#themes)
36. [Panel Layout — Edgy](#panel-layout--edgy)
37. [Breadcrumbs — Dropbar](#breadcrumbs--dropbar)
38. [Sticky Context Header](#sticky-context-header)
39. [Inline Git Blame](#inline-git-blame)
40. [Code Action Lightbulb](#code-action-lightbulb)
41. [Yank History — Yanky](#yank-history--yanky)
42. [Better Quickfix — nvim-bqf](#better-quickfix--nvim-bqf)
43. [Smarter Word Motions — Spider](#smarter-word-motions--spider)
44. [Buffers & Windows](#buffers--windows)
45. [Editing Shortcuts](#editing-shortcuts)
46. [Statusline](#statusline)
47. [Python — Virtual Environment](#python--virtual-environment)
48. [How to Customize](#how-to-customize)
49. [Complete Keybinding Reference](#complete-keybinding-reference)

---

## Prerequisites & Installation

### Required tools

```bash
# macOS — install with Homebrew
brew install neovim git node ripgrep fzf lazygit

# Verify versions
nvim --version     # needs 0.10+
node --version     # needs 18+
rg --version       # ripgrep for grep search
fzf --version      # fuzzy finder
lazygit --version  # git TUI
```

### First launch

```bash
# 1. Open Neovim — plugins will auto-install
nvim

# 2. Wait for lazy.nvim to finish installing (~1 min first time)

# 3. Install LSP servers
:Mason
# Press i next to: pyright, typescript-language-server, gopls, prettierd

# 4. Verify everything works
:checkhealth
```

---

## Understanding Neovim Basics

Neovim is **modal** — it has different modes for different tasks. This is the most important concept to understand.

### Modes

| Mode            | How to Enter  | What it Does                              |
| --------------- | ------------- | ----------------------------------------- |
| **Normal**      | `Esc` or `jk` | Navigate, run commands. **Default mode.** |
| **Insert**      | `i` `a` `o`   | Type text like a regular editor           |
| **Visual**      | `v`           | Select characters                         |
| **Visual Line** | `V` (capital) | Select whole lines                        |
| **Command**     | `:`           | Run vim commands like `:w`, `:q`          |

> **Rule:** Always go back to Normal mode when you're not actively typing. Everything powerful happens in Normal mode.

### Essential Normal Mode Motions

These let you move around without touching arrow keys (much faster once learned):

```
h j k l      → left / down / up / right
w            → jump to start of next word
b            → jump to start of previous word
e            → jump to end of current word
0            → go to start of line
$            → go to end of line
gg           → go to top of file
G            → go to bottom of file
5j           → move 5 lines down (any number + motion)
Ctrl+d       → scroll half page down (smooth)
Ctrl+u       → scroll half page up (smooth)
```

### Operators (actions in Normal mode)

```
d            → delete
y            → yank (copy)
c            → change (delete + enter insert mode)
```

Operators combine with motions:

```
dw           → delete word
d$           → delete to end of line
yy           → yank (copy) entire line
dd           → delete entire line
ciw          → change inner word (delete word, enter insert)
di"          → delete inside quotes
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
├── init.lua                  ← Entry point — just loads lua/config/lazy.lua
│
└── lua/
    ├── config/
    │   ├── lazy.lua          ← Plugin manager setup + LazyVim extras enabled
    │   ├── options.lua       ← Editor settings (line numbers, tabs, etc.)
    │   ├── keymaps.lua       ← Custom keybindings
    │   └── autocmds.lua      ← Automatic actions (save cursor pos, etc.)
    │
    └── plugins/
        ├── autosave.lua      ← Auto-save configuration
        ├── coding.lua        ← Better folds (UFO), tabout
        ├── colorscheme.lua   ← Themes: oxocarbon (default), cyberdream, catppuccin, tokyonight, rose-pine, kanagawa
        ├── dap.lua           ← Debugger (Python, Go, TypeScript/JS)
        ├── editor.lua        ← neo-tree, gitsigns blame, peek definition, smooth scroll, TODO colors, diagnostics
        ├── extras.lua        ← Spectre, persistence, zen mode, yank history, better quickfix
        ├── git-advanced.lua  ← Diffview, git-conflict, Octo (GitHub)
        ├── markdown.lua      ← Markdown browser preview
        ├── navigation.lua    ← Smart splits, multi-cursor, spider word motions, project switcher
        ├── python.lua        ← Python venv auto-detection for pyright
        ├── rest.lua          ← REST client (kulala)
        ├── search.lua        ← fzf-lua fuzzy search
        ├── terminal.lua      ← Terminal inside Neovim
        ├── testing.lua       ← Neotest (Jest, Vitest, pytest, Go test)
        ├── ui.lua            ← Edgy panels, treesitter-context, fidget, lualine, lightbulb, dressing, indent guides
        ├── ui-extras.lua     ← Dropbar breadcrumbs, color highlighter, package info, wakatime
        ├── undotree.lua      ← Undo history tree
        └── visuals.lua       ← Smear cursor, rainbow brackets, scrollbar, animations
```

### What each config file controls

**`lua/config/lazy.lua`** — The most important file. Controls which LazyVim extras (language packs) are active:


- `lang.typescript` → TypeScript + JavaScript LSP, formatting
- `lang.python` → Python LSP (pyright), linting
- `lang.go` → Go LSP (gopls), formatting
- `lang.json` → JSON LSP, schema validation
- `formatting.prettier` → Prettier for TS/JS/CSS
- `lang.markdown` → Markdown LSP, rendering, formatting
- `test.core` → Neotest framework
- `editor.aerial` → Code outline panel
- `editor.inc-rename` → Live rename preview
- `editor.fzf` → fzf-lua as the LazyVim picker

**`lua/config/options.lua`** — Things like relative line numbers, tab size, search behavior.

**`lua/config/keymaps.lua`** — Keybindings you set yourself (not from plugins).

**`lua/plugins/`** — One file per concern. To disable a feature, add `enabled = false` to the relevant plugin.

---

## The Leader Key & Which-Key

The **leader key is `Space`**. It's the gateway to almost all commands.

**Press `Space` and wait 300ms** — a popup appears showing all available commands grouped by category:

```
Space f ...   → File operations
Space s ...   → Search operations
Space g ...   → Git operations
Space c ...   → Code (LSP) operations
Space t ...   → Test + Terminal operations
Space u ...   → UI toggles
Space b ...   → Buffer operations
Space w ...   → Window operations
```

> **Tip:** You don't need to memorize keymaps. Just press `Space`, read the popup, and press the next key. Which-key will guide you.

---

## File Explorer — Neo-tree

A VSCode-style file tree on the left side. **Hidden files (dotfiles) are always
visible by default** — press `H` to hide them temporarily if needed.

### Two modes: Normal and Focus

```
<leader>e    → Normal mode  — toggle tree open/closed, always shows full project root (cwd)
<leader>o    → Focus mode   — toggle focus on the current package / module
               1st press  → roots the tree at the nearest package.json / tsconfig.json
               2nd press  → returns the tree back to the full project root
```

**When to use which:**

| Situation | Key |
|---|---|
| You want to browse the whole project | `<leader>e` |
| You're deep in a monorepo and want to see only the current package | `<leader>o` |
| You want to see `package.json`, `.env`, config files for your current package | `<leader>o` |
| Done with focus, back to full view | `<leader>o` again |

**How focus mode finds the root:**
It walks up from your current file looking for `package.json`, `tsconfig.json`,
`Cargo.toml`, `go.mod`, or `pyproject.toml` — whichever is closest. So if you're
editing `packages/api-gateway/src/routes/workflow.ts`, focus mode roots the tree
at `packages/api-gateway/` where `package.json` lives — showing all its config
files, `.env`, `src/`, `__tests__/` etc.

### Navigation inside the tree

Once the tree is open, use these keys:

```
j / k        → move up / down
Enter        → open file or expand folder
l            → expand folder
h            → collapse folder
```

### File operations

```
a            → create new file (type name + Enter)
               end name with / to create a folder
               e.g. "components/Button.tsx" creates the full path
d            → delete file (asks for confirmation)
r            → rename file
y            → copy file
x            → cut file
p            → paste file
```

### Display controls

```
H            → toggle hidden files (dotfiles shown by default — H hides them)
R            → refresh the tree
q            → close explorer
```

### Resizing the explorer

The explorer is managed by **edgy.nvim** (the panel layout engine). Standard
Neovim resize commands like `<leader>w>` don't work here because edgy re-applies
its stored sizes on every layout event, reverting any direct window resize.

The fix: these keys update edgy's internal size value directly, so the resize
sticks permanently until you resize again.

```
Shift+>   (i.e. >)   → widen the explorer by 5 columns
Shift+<   (i.e. <)   → narrow the explorer by 5 columns
```

Both keys only work **while your cursor is inside the Neo-tree panel**.
Press `<leader>e` or `<leader>o` first to open the tree, then use `>` / `<`.

Default width is **40 columns**. Minimum is clamped at 20 so it can't collapse.

> **Example:** On a large monitor press `>` four or five times to get ~60 columns,
> giving enough room to read long nested paths without truncation.

> **Tip:** The tree auto-follows your current file. When you open a file with `<leader>ff`, the tree highlights it automatically.

---

## Fuzzy Search — fzf-lua

Find anything instantly. This is one of the most important tools.

### Finding files

```
<leader>ff   → find files by name (searches entire project)
<leader>fr   → recent files (files you opened before)
<leader>fb   → switch between currently open buffers (open files)
```

### Searching inside files

```
<leader>/    → live grep — search for text across ALL project files
<leader>fw   → search the exact word your cursor is on
```

**How live grep works:**

1. Press `<leader>/`
2. Start typing the text you're looking for
3. Results update instantly
4. Press `Enter` to open that file at that line

### LSP-powered search

```
<leader>ss   → all functions/classes/variables in current file
<leader>sS   → all symbols across the entire project
gr           → find all places where current symbol is used
```

### Git search

```
<leader>gc   → browse all git commits (with diff preview)
<leader>gB   → browse all branches (press Enter to switch)
```

### Other search

```
<leader>ft   → search all TODO/FIXME/NOTE comments in project
<leader>sk   → search all keymaps (useful when you forget a shortcut)
<leader>:    → browse command history
<leader>uT   → switch theme with live preview
```

### Inside any fzf window

```
Type         → filter results in real time
Enter        → open / select
Ctrl+j       → move down
Ctrl+k       → move up
Ctrl+d       → scroll preview pane down
Ctrl+u       → scroll preview pane up
Esc          → close without selecting
```

---

## LSP — Code Intelligence

LSP (Language Server Protocol) gives you IDE features. It works automatically when you open a supported file.

**Active language servers:**

- **TypeScript/JS** → `vtsls` or `tsserver`
- **Python** → `pyright`
- **Go** → `gopls`
- **JSON** → `jsonls`

### Navigation

```
gd           → go TO definition (jumps to where it's defined)
gp           → peek definition (shows in floating window, you stay put)
K            → show hover documentation (type info, docstring, signature)
gr           → show all references (opens fzf list of every usage)
```

### Code actions & editing

```
<leader>ca   → code actions — context-aware fixes:
               • Add missing import
               • Remove unused import
               • Extract to function
               • Implement interface
               • Fix lint errors

<leader>cr   → rename symbol — renames everywhere in the project
               (safer than find & replace — only renames actual usages)

<leader>cf   → format current file with the configured formatter
```

### Diagnostics — errors & warnings shown in your code

When LSP finds a problem, it shows it **directly in your code** in two places:

**1. Sign column** (the narrow strip on the far left):

```
E  → error (red)
W  → warning (yellow)
I  → info (blue)
H  → hint (cyan)
```

**2. Virtual text** — only shown on the line your cursor is on (keeps other lines clean):

```python
from sqlalchemy import create_engine    ← no text shown (just underline + sign)
async def my_func(data: MyType):        ● Pyright: "MyType" is not defined  ← cursor is here
```

This keeps the code readable — you see the full message only when you move to a line.
Press `<leader>cd` for the full detailed float with source info on any line.

**3. Statusline counts** (bottom bar):

```
 6  8   → 6 errors, 8 warnings in this file
```

### Navigating diagnostics

```
]d           → jump to NEXT error or warning in file
[d           → jump to PREVIOUS error or warning in file
<leader>cd   → show the FULL error message for issue on current line (floating popup)
<leader>xx   → open Trouble panel — see ALL errors in a list (see Trouble section)
```

> **Workflow:** See `E6` in statusline → press `<leader>xx` to open all errors → press `Enter` on each to jump to it → fix it → errors disappear.

### LSP management

```
:LspInfo     → show which servers are running for current file
:LspRestart  → restart all LSP servers (use when they get stuck)
:Mason       → open Mason to install/uninstall language servers
```

---

## Diagnostics Panel — Trouble

Inline diagnostics show errors **next to the line** they occur on — but when you have many errors across many files, you need a way to see them all at once. That's what **Trouble** is for.

### Opening Trouble

```
<leader>xx   → ALL diagnostics across the entire project (every file)
<leader>xX   → diagnostics for current file only
<leader>xL   → location list
<leader>xQ   → quickfix list
<leader>cs   → all symbols in current file (functions, classes, etc.)
```

### What Trouble looks like

```
 ERRORS & WARNINGS ─────────────────────────────────────
  purchase_orders.py
    39  E  Pyright: Function declaration obscured by...
    12  W  Ruff: "sqlalchemy" imported but unused
  invoice_service.py
    5   E  Import "httpx" could not be resolved
    18  W  "response" is not accessed
```

### Navigating inside Trouble

```
j / k        → move up and down the list
Enter        → jump TO that error (closes Trouble, opens file at that line)
o            → preview the error without closing Trouble
P            → toggle live preview pane
]d / [d      → next/prev item while staying in Trouble
q            → close Trouble panel
```

### Fixing errors workflow

1. Press `<leader>xx` — see all errors listed
2. Press `j/k` to move to an error
3. Press `Enter` to jump to it in your code
4. Fix the error
5. Press `<leader>xx` again — the fixed error disappears from the list
6. Repeat until the list is empty

### Trouble vs inline diagnostics

|              | Inline (always visible)        | Trouble panel                  |
| ------------ | ------------------------------ | ------------------------------ |
| **Shows**    | Error text next to the line    | All errors in a browsable list |
| **Scope**    | Current visible code           | Whole project or current file  |
| **Navigate** | `]d` / `[d`                    | `j` / `k` then `Enter`         |
| **Best for** | Seeing what's wrong right here | Finding and fixing all errors  |

> **Tip:** Inline diagnostics + Trouble work together. Use inline for quick awareness, Trouble when you want to systematically fix everything.

---

## Peek Definition — goto-preview

Shows definition/references in a floating window **without leaving your current position**. Very useful when you want to quickly check something without losing your place.

```
gp           → peek definition
gpt          → peek type definition
gpr          → peek all references
gpi          → peek implementation (TypeScript & Go only)
gpc          → close all open peek windows
Esc          → close peek window when focused inside it
```

### gd vs gp — what's the difference?

| Key  | Behavior                                                                   |
| ---- | -------------------------------------------------------------------------- |
| `gd` | **Jumps** to definition — you leave your current file                      |
| `gp` | **Peeks** at definition — stays in floating window, current file unchanged |

> **Use `gp`** when you just want to check how something is implemented.
> **Use `gd`** when you actually want to navigate there and work on it.

### Note on `gpi`

`gpi` (peek implementation) only works with TypeScript and Go because those languages have the concept of interfaces + implementations. Python is dynamic so it doesn't apply.

---

## Completion

A popup appears automatically as you type. No configuration needed.

```
Tab          → select next suggestion
Shift+Tab    → select previous suggestion
Enter        → accept the selected suggestion
Ctrl+e       → dismiss/close the popup
Ctrl+b       → scroll documentation in popup upward
Ctrl+f       → scroll documentation in popup downward
```

The completion shows:

- **LSP suggestions** — functions, variables, types from your language server
- **Snippets** — code templates
- **Buffer words** — words already in your open files
- **Path completion** — file paths when typing strings

---

## Git Integration

### Lazygit — full Git UI

```
<leader>gg   → open lazygit (full screen)
<leader>tg   → open lazygit in a terminal panel
```

**Inside lazygit** (press `?` to see all keys):

```
Space        → stage/unstage file
c            → commit
p            → push
P            → pull
b            → branch menu
d            → view diff
Enter        → open file / expand
q            → quit
```

### Gitsigns — inline git in editor

Changed lines show in the **sign column** (left gutter):

- Green `│` = new line added
- Orange `│` = line modified
- Red `_` = line deleted below

```
]h           → jump to next changed hunk
[h           → jump to previous changed hunk
<leader>ghp  → preview the diff of this hunk in a floating window
<leader>ghs  → stage just this hunk (without staging whole file)
<leader>ghr  → reset/discard changes in this hunk
<leader>ghb  → show git blame for current line (who wrote this & when)
```

### Inline git blame (always visible)

Every line shows a subtle blame annotation at the end — author, date, and commit summary — like GitLens in VS Code:

```
const port = process.env.PORT ?? 3000;   You, 15 Mar 2026 · add port config
```

This appears automatically on the line your cursor is on. After 500ms it fades in. No keypress needed.

### FZF git commands

```
<leader>gc   → browse commit history with diff preview
<leader>gB   → browse branches, press Enter to checkout
```

---

## Git Diff Viewer — Diffview

Side-by-side diffs, full file history, and 3-way merge conflict resolution — all inside Neovim.

### Viewing changes

```
<leader>gd    → open diff view (all uncommitted changes, side by side)
<leader>gD    → diff current state vs last commit (HEAD~1)
<leader>gfh   → history of current file (every commit that touched it)
<leader>gFH   → history of entire project
<leader>gdc   → close diff view
```

### Inside Diffview

```
Tab / S-Tab   → jump between changed files in the file panel
]c / [c       → next / previous change (hunk) in the diff
<leader>b     → toggle file panel (left sidebar)
q             → close diffview
```

### Reading a diff

```
Left pane     → OLD version (before your changes)
Right pane    → NEW version (your current changes)

Green lines   → added
Red lines     → removed
```

---

## Merge Conflicts — git-conflict

When you pull or merge and get conflicts, this plugin highlights them and lets you resolve with single keypresses.

### What a conflict looks like

```python
<<<<<<< HEAD (current branch — YOUR changes)
def calculate(x):
    return x * 2
=======
def calculate(x, y):
    return x + y
>>>>>>> feature/new-calc (incoming branch — THEIR changes)
```

### Resolving conflicts

Place cursor anywhere inside the conflict block and press:

```
co   → choose OURS   — keep HEAD (your current branch version)
ct   → choose THEIRS — keep incoming (their version)
cb   → choose BOTH   — keep both versions stacked
c0   → choose NONE   — delete the entire conflict block
```

### Navigating conflicts

```
]x   → jump to next conflict in file
[x   → jump to previous conflict in file
```

### Full merge conflict workflow

1. Pull / merge → git says "conflict in file.py"
2. Open the file in Neovim — conflicts are highlighted
3. Press `]x` to jump to first conflict
4. Read both sides, press `co` / `ct` / `cb` to resolve
5. Press `]x` for next conflict, repeat
6. Save file, stage it with `<leader>ghs`, then commit

> **Tip:** Use `<leader>gd` (Diffview) alongside git-conflict for a full picture of what changed.

---

## GitHub — Octo

Browse and manage GitHub PRs and issues without leaving Neovim. Review diffs, add comments, merge PRs — all in the editor.

### Setup (one-time)

```bash
# Install and authenticate the GitHub CLI
brew install gh
gh auth login
```

### Opening Octo

```
<leader>gop   → list all open PRs for current repo
<leader>goi   → list all open issues
<leader>gor   → start a PR review (adds comments, approve/request changes)
<leader>gom   → merge the current PR
```

Or use `:Octo` to run any command directly. Examples:

```
:Octo pr list
:Octo issue list
:Octo pr checkout 42     ← checkout PR #42 as a local branch
:Octo review start
:Octo pr merge
```

### Inside a PR view

```
<leader>ca   → add a comment
<leader>ic   → insert a suggestion
Tab          → move to next file in the PR diff
]c / [c      → next / previous comment thread
q            → close
```

> **Tip:** Use `<leader>gop` → select a PR → review the diff inline → `<leader>gor` to start review — all without opening a browser.

---

## Terminal

A terminal inside Neovim so you don't need to leave.

### Opening terminals

```
<C-\>        → toggle floating terminal (press again to hide)
<leader>th   → open terminal in horizontal split (bottom panel)
<leader>tv   → open terminal in vertical split (right panel)
<leader>tg   → open lazygit
```

### What <C-\> does — two different things

`<C-\>` behaves differently depending on where you press it:

| Where                          | What happens                     |
| ------------------------------ | -------------------------------- |
| **Normal mode** (editing code) | Opens the floating terminal      |
| **Inside terminal**            | Hides/closes the terminal window |

### Exiting terminal mode

When the terminal opens you are in **terminal INSERT mode** — keystrokes go to the shell.
To get back to Neovim's normal mode there are two options:

```
<C-\><C-n>   → exit terminal INSERT mode → back to Normal mode
               (RELIABLE — always works, native Neovim shortcut)

Esc Esc      → same thing, but may not work if noice.nvim intercepts Esc
```

Once in Normal mode inside the terminal window you can:

```
Ctrl+h/j/k/l → move to another window (leave terminal open)
<C-\>        → hide the terminal entirely
j / k        → scroll up and down through terminal output
```

### Practical workflow

```
1. Press <C-\>        → terminal opens, you're in terminal mode
2. Type your command  → e.g. npm run dev / python main.py / go run .
3. Press <C-\><C-n>   → exit to Normal mode (terminal stays open)
4. Scroll with j/k    → read the output
5. Press <C-\>        → hide terminal, go back to code
6. Press <C-\>        → show terminal again (session still running!)
```

> **Key insight:** Hiding the terminal (`<C-\>`) does NOT kill your shell. The process keeps running in the background. You can show/hide it freely.

---

## Test Runner — Neotest

Run tests without leaving Neovim. Supports Jest, Vitest, pytest, and Go test. Auto-detects which framework your project uses.

### Running tests

```
<leader>tt   → run the test that your cursor is inside/on
<leader>tf   → run ALL tests in the current file
<leader>tl   → re-run the last test you ran
<leader>tS   → stop a running test
```

### Viewing results

```
<leader>ts   → toggle test summary panel (tree of all tests, pass/fail)
<leader>to   → toggle test output panel (full output, stdout, errors)
]f           → jump to next failed test
[f           → jump to previous failed test
```

### Result icons shown in your code

After running tests, icons appear next to each test function:

```
 (green)  → test passed
 (red)    → test failed
 (yellow) → test running
 (grey)   → test skipped
```

### Language-specific notes

**TypeScript/JavaScript:**

- Automatically uses Jest if `jest.config.*` exists
- Automatically uses Vitest if `vitest.config.*` exists
- Runs via `npx jest` or `npx vitest`

**Python:**

- Uses pytest as the runner
- Works with virtual environments (auto-detected)

**Go:**

- Runs with `-count=1 -timeout=60s -race` flags
- Works with standard `go test`

---

## Project Find & Replace — Spectre

Search for a string across your **entire project** and replace it — with a preview of every change before applying. Much more powerful than `:%s/old/new/g` which only works in one file.

### Opening Spectre

```
<leader>sr   → open Spectre (project-wide search & replace)
<leader>sw   → search for word under cursor across project
```

### Inside Spectre

```
dd           → toggle excluding a specific result (don't replace this one)
<leader>rr   → replace ALL results
<leader>rc   → replace only the result under cursor
<leader>ri   → toggle case-insensitive search
<leader>rw   → toggle whole-word match
<leader>re   → toggle regex mode
q            → close Spectre
```

### Workflow

1. Press `<leader>sr` — Spectre opens
2. Type your search term — all matches show with file + line preview
3. Type your replacement term
4. Use `dd` to exclude any results you don't want changed
5. Press `<leader>rr` to apply all replacements

> **Tip:** Spectre supports regex. For example search `function (\w+)\(` to find all function declarations.

---

## REST Client — Kulala

Write and run HTTP requests directly in Neovim — like Postman/Insomnia but in a `.http` or `.rest` file you can commit to your repo. The response opens in a **vertical split on the right**, JSON is auto-formatted with `jq`.

### Create a request file

Create any file ending in `.http` or `.rest`. You can define variables at the top with `@`:

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

### Update workflow
PUT {{baseUrl}}/workflows/{{workflowId}}
Content-Type: application/json

{
  "name": "updated-workflow"
}

### Delete workflow
DELETE {{baseUrl}}/workflows/{{workflowId}}
```

Variables defined with `@` show their values inline in the file automatically.

### Running requests

Place cursor inside any request block and press:

```
<leader>rr   → run request under cursor (response opens on the right)
<leader>ra   → run ALL requests in the file sequentially
<leader>rp   → replay the last request (re-run without moving cursor)
<leader>ri   → inspect request (see full URL, headers, body before sending)
<leader>rc   → copy request as a cURL command (paste in terminal)
]r           → jump to next request in file
[r           → jump to previous request in file
```

### Viewing the response

After running a request the response opens in a split. Toggle between views:

```
<leader>rv   → cycle through: Body → Headers → Stats
<leader>rS   → show timing stats (time to first byte, total duration)
```

**Body view** — the actual response content, JSON auto-formatted:

```json
{
  "id": "wf-123",
  "name": "charge-card",
  "status": "active"
}
```

**Headers view** — all response headers:

```
HTTP/1.1 200 OK
Content-Type: application/json
X-Request-Id: abc-123
```

**Stats view** — timing breakdown (useful for performance testing).

### Environments

Create a `kulala.env.json` file in your project root to manage different environments:

```json
{
  "dev": {
    "baseUrl": "http://localhost:3000",
    "token": "dev-secret-token",
    "workflowId": "wf-001"
  },
  "staging": {
    "baseUrl": "https://staging-api.example.com",
    "token": "staging-secret-token",
    "workflowId": "wf-staging-001"
  },
  "prod": {
    "baseUrl": "https://api.example.com",
    "token": "prod-secret-token",
    "workflowId": "wf-prod-001"
  }
}
```

Switch environment:

```
<leader>re   → open environment picker → select dev / staging / prod
```

All `{{variables}}` in your `.http` file update to the selected environment's values.

### Scratchpad

A temporary request file for quick testing — no need to create a real file:

```
<leader>rs   → open scratchpad (temporary .http buffer, not saved to disk)
```

### Import from cURL

If you have a cURL command (e.g. copied from browser DevTools → Copy as cURL), you can convert it to a `.http` request:

```
<leader>rf   → paste a cURL command → converts it to kulala format automatically
```

### Full API testing workflow

```
1. Create requests/api-gateway.http in your project
2. @baseUrl = http://localhost:3000
3. Write your requests with ### separators
4. Press <leader>rr to run the request under cursor
5. Response appears on the right — JSON is formatted automatically
6. <leader>rv to see headers if needed
7. <leader>re to switch to staging and test there
8. Commit the .http file with your code — it's documentation too
```

> **Tip:** Keep a `.http` file per service in your project. They're readable, committable, and replace Postman collections entirely.

---

## Undo Tree

Neovim tracks **every change you ever make** to a file (even across sessions). Normally `u` is linear undo — if you undo something and then make a new edit, the undone changes are lost. Undotree shows your entire history as a **tree** so you can go back to any past state.

```
<leader>uu   → toggle Undo Tree panel
```

### Inside Undo Tree

```
j / k        → move through history states
Enter        → jump to that state (your file changes to match)
d            → toggle diff panel (see what changed between states)
q            → close undo tree
```

### Reading the tree

```
●            → a save point
│            → linear sequence of changes
├─           → branch (you undid then made a new change)
```

> **When to use:** You've been editing for a while, did some undos, made more changes, and now want to get back to a specific earlier version — Undotree lets you find and restore it.

---

## Session Management

Saves your entire workspace state — open files, splits, cursor positions — and restores it when you reopen Neovim in the same project.

### Usage

```
<leader>qs   → restore session for current directory
<leader>ql   → restore last session (wherever you were last)
<leader>qd   → stop auto-saving session for this session
```

### How it works

- When you quit Neovim, the session is **automatically saved**
- Next time you open Neovim in the same folder, press `<leader>qs` and everything comes back exactly as you left it — same files, same splits, same cursor positions

### Workflow

```bash
# Start working
cd ~/projects/my-app
nvim .

# Do your work — open files, arrange splits
# Quit normally
:qa

# Next day
cd ~/projects/my-app
nvim .
# Press <leader>qs — everything is back
```

---

## Auto-save

Your files save **automatically**. You don't need to press `<C-s>` constantly.

### When it saves

| Event                                | Delay             |
| ------------------------------------ | ----------------- |
| You stop typing                      | After 1.5 seconds |
| You switch to another buffer         | Instantly         |
| Neovim loses focus (switch app)      | Instantly         |
| You leave insert mode (`jk` / `Esc`) | After 1.5 seconds |

### When it does NOT save

- Inside Neo-tree, Lazy, Mason windows
- Read-only files
- If you immediately start typing again (cancels the deferred save)

You can still manually save with `<C-s>` anytime.

---

## TODO Comments

Special comment keywords are **highlighted in distinct colors** automatically in any language.

### Keywords and colors

```python
#  TODO: something to do later                  → Blue
#  FIXME: this is broken, needs fixing           → Red
#  NOTE: important context for this code         → Green
#  HACK: workaround, not the right solution      → Yellow
#  WARN: be careful, edge case here              → Orange
#  PERF: opportunity to improve performance      → Purple
#  TEST: note about testing this                 → Teal
#  INFO: informational note about the code       → Reddish-orange
```

These work in all languages (Python `#`, JavaScript `//`, Go `//`, Lua `--`, etc.)

### Navigating TODOs

```
<leader>ft   → search all TODOs in project (fzf)
<leader>sT   → search TODO/FIX/FIXME only
]t           → jump to next TODO in current file
[t           → jump to previous TODO in current file
```

---

## Markdown

### In-editor rendering

When you open a `.md` file, Neovim **renders it visually**:

- Headers appear larger/bold
- **Bold** and _italic_ text renders styled
- Code blocks get syntax highlighted
- Bullet points and checkboxes render as actual symbols

### Browser preview

```
<leader>mp   → open live preview in your default browser
               (auto-reloads every time you save)
```

> First time: run `:Lazy sync` then `:MarkdownPreviewInstall` to build the preview server.

### Formatting

```
<leader>cf   → format the markdown file with prettier
```

---

## Themes

6 themes installed. You can switch anytime — no restart needed.

### Switch theme

```
<leader>uT   → open live theme picker (preview updates as you move)
```

### Available themes

| Theme                | Command                      | Style                                        |
| -------------------- | ---------------------------- | -------------------------------------------- |
| **Oxocarbon**        | `:colorscheme oxocarbon`     | **Default** — IBM Carbon, near-black + electric blue |
| **Cyberdream**       | `:colorscheme cyberdream`    | Cyberpunk neon, vibrant dark                 |
| **Catppuccin Mocha** | `:colorscheme catppuccin`    | Dark, purple/pink tones                      |
| **Tokyonight Night** | `:colorscheme tokyonight`    | Dark blue/purple                             |
| **Rose Pine**        | `:colorscheme rose-pine`     | Warm, earthy, rose tones                     |
| **Kanagawa Wave**    | `:colorscheme kanagawa`      | Dark Japanese ink aesthetic                  |

### Variants within themes

```lua
-- Catppuccin variants: "latte" (light), "frappe", "macchiato", "mocha" (dark)
opts = { flavour = "mocha" }

-- Tokyonight variants: "night", "storm", "moon", "day" (light)
opts = { style = "night" }

-- Rose Pine variants: "main", "moon", "dawn" (light)
opts = { variant = "main" }

-- Kanagawa variants: "wave", "dragon", "lotus" (light)
opts = { theme = "wave" }
```

### Make a theme permanent

Edit `lua/plugins/colorscheme.lua`, find this line and change the value:

```lua
{ "LazyVim/LazyVim", opts = { colorscheme = "oxocarbon" } }
-- change to: "cyberdream", "catppuccin", "tokyonight", "rose-pine", or "kanagawa"
```

---

## Panel Layout — Edgy

Edgy locks your tool windows into consistent positions — just like VS Code's sidebar system. You never have a random split opening in the wrong place.

| Panel | Where | Opens when |
|-------|-------|------------|
| **Neo-tree** (Explorer) | Left | `<leader>e` |
| **Aerial** (Outline) | Right | `<leader>cs` |
| **Quickfix** | Bottom | `:copen` or `<leader>xQ` |
| **Trouble** (Diagnostics) | Bottom | `<leader>xx` |
| **Help** | Bottom | `:help <topic>` |

When you open any of these, they snap into their designated panel instead of taking over your code window. Your editing area stays clean and uninterrupted.

---

## Breadcrumbs — Dropbar

A navigation bar at the **top of every window** showing your current location in the code:

```
src/services/user.service.ts › UserService › createUser
```

- Powered by LSP (accurate symbol names) with treesitter as fallback
- Each segment is **clickable** — press it to jump to that scope
- Updates live as you move your cursor

No keymaps needed — it's always visible at the top of code windows.

---

## Sticky Context Header

When you scroll deep into a function or class, the **function/class signature stays pinned at the top** of the window — you never lose track of where you are.

```
class UserService {           ← pinned header (even when scrolled 200 lines down)
  ─────────────────────────────────────────────────────
  ...200 lines of methods...

  async createUser(data: CreateUserDto) {   ← cursor is here
```

- Shows up to 3 lines of context
- Separated from your code by a thin `─` line
- Disappears when you scroll back to the top (not needed there)

No keymaps needed — always on automatically.

---

## Inline Git Blame

Every line shows a subtle blame annotation at the end — who wrote it, when, and what the commit said. Just like GitLens in VS Code or Zed's blame.

```typescript
const port = process.env.PORT ?? 3000;    You, 15 Mar 2026 · add port config
```

- Appears automatically on the **cursor line** after 500ms
- Shows: `author, date · commit summary`
- No keypress needed — just move to the line

For the full blame of any line: `<leader>ghb`

---

## Code Action Lightbulb

When the LSP has **code actions available** on your cursor line, a lightbulb icon `󰌶` appears in the sign column (left gutter).

```
󰌶 const x = require('lodash')   ← lightbulb means: "I can fix/improve this"
```

Common code actions:
- Add missing import
- Remove unused import
- Extract to function
- Implement interface
- Fix ESLint rule violation

Press `<leader>ca` to open the action menu when you see the lightbulb.

---

## Yank History — Yanky

Every time you yank (copy) something, it's saved to a **yank ring**. After pasting, you can cycle through previous yanks to pick the right one — like a clipboard manager.

### Basic usage

```
y            → yank (copy) — same key, now tracked in history
p            → paste after cursor
P            → paste before cursor
```

### Cycling through history

```
<M-p>        → after pasting: replace with previous yank   (Alt+p)
<M-n>        → after pasting: replace with next yank        (Alt+n)
<leader>fy   → browse full yank history in a picker
```

> **Note:** Cycle keys use `Alt` (not `Ctrl`) to avoid conflicting with
> `<C-n>` which is used by the multi-cursor plugin.

### Example workflow

```
1. Yank "hello"    (saved to ring)
2. Yank "world"    (saved to ring)
3. Yank "foo"      (saved to ring — this is now what p pastes)
4. Press p         → pastes "foo"
5. Press <M-p>     → replaces with "world"
6. Press <M-p>     → replaces with "hello"
```

---

## Better Quickfix — nvim-bqf

The quickfix window (used by LSP, grep results, test failures) now has an **fzf preview pane** — you can filter the list and see the context of each result before jumping.

```
<leader>xQ   → open quickfix list (enhanced)
[q / ]q      → navigate previous / next quickfix item
```

### Inside the quickfix window

```
Tab          → toggle selection of an item
zf           → filter list with fzf (type to narrow results)
<C-s>        → open item in horizontal split
o            → open item, stay in quickfix
q            → close
```

---

## Smarter Word Motions — Spider

The `w`, `b`, `e` keys are replaced with smarter versions that understand **camelCase** and **snake_case**.

### The difference

Standard `w` jumps the whole word:

```
camelCaseWord   →   w moves from c to W (whole word in one jump)
```

Spider `w` stops at each hump:

```
camelCaseWord   →   w stops at: camel → Case → Word
```

Same for `snake_case`:

```
my_variable_name   →   w stops at: my → variable → name
```

### All affected keys

```
w    → next word start (stops at camelCase humps + snake_case underscores)
b    → previous word start
e    → next word end
```

All operators work too: `dw`, `cw`, `vw`, `yw` all respect word boundaries.

### Why this matters for TypeScript/Go

```typescript
// Renaming part of a camelCase name:
getUserById   →   position cursor on "User", press ciw → type "Member"
// Result: getMemberById
// Without spider: ciw would change the entire "getUserById"
```

---

## Buffers & Windows

### What's a buffer?

A **buffer** is an open file. You can have many files open at once — they show as tabs in the top bar.

```
Tab          → go to NEXT open buffer (next tab)
Shift+Tab    → go to PREVIOUS open buffer (prev tab)
H            → previous buffer (same as Shift+Tab)
L            → next buffer
<leader>bd   → close current buffer (close this tab)
<leader>fb   → see all open buffers in fzf (switch by searching)
```

### What's a window?

A **window** is a pane/split showing a buffer. You can have multiple windows open side by side.

**Create splits:**

```
<leader>-    → split current window HORIZONTALLY (top/bottom)
<leader>|    → split current window VERTICALLY (left/right)
```

**Navigate between windows:**

```
Ctrl+h       → move cursor to LEFT window
Ctrl+j       → move cursor to BOTTOM window
Ctrl+k       → move cursor to TOP window
Ctrl+l       → move cursor to RIGHT window
```

**Resize windows (smart-splits):**

```
<A-Left>     → resize split narrower
<A-Right>    → resize split wider
<A-Up>       → resize split taller
<A-Down>     → resize split shorter
```

**Or use leader keys:**

```
<leader>w+   → increase height (taller)
<leader>w-   → decrease height (shorter)
<leader>w>   → increase width (wider)
<leader>w<   → decrease width (narrower)
<leader>w=   → make all windows equal size
```

> **Tip:** Smart splits also works across tmux panes — `<C-hjkl>` navigation and `<A-arrow>` resize work seamlessly between Neovim and tmux.

---

## Editing Shortcuts

### Exiting insert mode

```
jk           → exit insert mode (much faster than reaching Escape)
Esc          → also works
```

### Saving

```
<C-s>        → save file (works in normal, insert, and visual mode)
               (auto-save handles it anyway, but useful for manual saves)
```

### Moving lines

```
Alt+j        → move current line DOWN one line
Alt+k        → move current line UP one line
```

In visual mode, select multiple lines first, then `Alt+j/k` moves the whole selection.

### Indenting

```
> (visual)   → indent selection RIGHT (stays in visual mode)
< (visual)   → indent selection LEFT (stays in visual mode)
```

### Pasting

```
p (visual)   → paste over selection WITHOUT losing clipboard
               (normally, pasting over text would copy the replaced text)
```

### Selecting

```
<leader>A    → select entire file (all content)
v            → start visual selection, then move cursor to extend
V            → select whole lines
viw          → select inner word (cursor anywhere on word)
vi"          → select content inside quotes
vi(          → select content inside parentheses
```

### Search & Replace

```
/pattern     → search forward for pattern
?pattern     → search backward for pattern
n            → next search result
N            → previous search result
Esc          → clear search highlight

:%s/old/new/g      → replace all occurrences in file
:%s/old/new/gc     → replace with confirmation for each
```

### Quickfix navigation

When you have a list of errors/results to navigate:

```
[q           → previous item in quickfix list
]q           → next item in quickfix list
```

---

## Statusline

The bar at the bottom of the screen shows (left to right):

```
[MODE]  branch  filename  errors  warnings   filetype  line:col  HH:MM IST
```

- **MODE** — NORMAL / INSERT / VISUAL / COMMAND
- **branch** — current git branch name
- **filename** — relative path of current file, `[+]` if unsaved
- **errors** — count of LSP errors (red)
- **warnings** — count of LSP warnings (yellow)
- **filetype** — detected language (python, typescript, go, etc.)
- **line:col** — cursor position
- **HH:MM IST** — current time in India Standard Time, 24-hour format

---

## Python — Virtual Environment

Pyright (the Python LSP) needs to know your venv to find installed packages.

### Auto-detection order

1. **`VIRTUAL_ENV` env var** — if you activate venv before opening Neovim
2. **Walk up directory tree** — looks for `.venv`, `venv`, `env`, `.env` from file location upward
3. **Scan monorepo subdirs** — finds `backend/.venv`, `services/api/.venv`, etc.

### Best practice (monorepo)

```bash
cd /your-monorepo/backend
source .venv/bin/activate
nvim .
```

The config auto-detects `backend/.venv` because it scans subdirectories.

### Manual override

If auto-detection fails:

```
:PyrightSetPythonPath /full/path/to/.venv/bin/python
```

### Verify it's working

```
:LspInfo
```

Look for `pyright` in the active clients list. The Python path should show your venv's Python.

---

## Multi-cursor — vim-visual-multi

Works exactly like VS Code's `Ctrl+D` — select a word and keep adding the next
occurrence, then type once and all cursors edit simultaneously.

### Selecting occurrences (the main workflow)

```
<C-n>          → select word under cursor
               → press again to add the NEXT occurrence
               → keep pressing to keep adding more
<C-x>          → skip current occurrence, jump to next  (like VS Code Ctrl+K Ctrl+D)
<C-q>          → remove the last added cursor / deselect current
<leader>ma     → select ALL occurrences at once
```

### Add cursors vertically (column editing)

```
<C-Down>       → add a cursor on the line below
<C-Up>         → add a cursor on the line above
```

Great for adding the same text to multiple lines at once.

### Once cursors are active

All standard Neovim editing works on every cursor simultaneously:

```
i              → insert mode at all cursors
a              → append at all cursors
c              → change (delete + insert) at all cursors
d              → delete at all cursors
I              → insert at start of all lines
A              → append at end of all lines
<Esc>          → exit multi-cursor mode
```

### Navigation inside multi-cursor mode

```
n / N          → move to next / previous match
```

### Example: rename a variable

You're editing a function and want to rename `userData` → `userInfo`:

```
1. Put cursor on userData
2. Press <C-n>               → selects first "userData"
3. Press <C-n> again         → adds next "userData" match
4. Press <C-n> until all are selected  (or \\A to grab all at once)
5. Press c                   → deletes all and enters insert mode
6. Type userInfo             → all cursors type simultaneously
7. Press <Esc>               → done, all renamed
```

### Example: add a property to multiple objects

```javascript
const a = { name: "foo" }
const b = { name: "bar" }
const c = { name: "baz" }
```

1. Press `<C-Down>` three times to place cursors on all three lines
2. Press `A` to append at end of each line
3. Type `, active: true }` — all three lines updated at once

> **Keybinding note:** `<C-n>` is reserved for multi-cursor. Yanky's yank-cycle
> uses `<M-p>` / `<M-n>` (Alt) instead to avoid conflict.

---

## Project Switcher

Jump between your different projects instantly without leaving Neovim.

```
<leader>fp     → open project picker (fuzzy search all your projects)
```

### How it works

- Auto-detects projects by looking for `.git`, `package.json`, `go.mod`, `pyproject.toml`
- When you open a file, it automatically `cd`s to the project root
- All your previously opened projects are remembered

### Workflow

```
<leader>fp     → type project name → Enter → Neovim switches to that project
                 (changes directory, updates file explorer, LSP restarts for new root)
```

---

## Zen Mode

Hides everything except your code — no statusline, no explorer, no tabs. Centers the text. Good for deep focus sessions.

```
<leader>z    → toggle zen mode (press again to exit)
```

When zen mode is active:

- File explorer hides
- Statusline hides
- Buffer tabs hide
- Code is centered in the window
- All your keymaps still work normally

---

## Code Outline — Aerial

A panel showing all functions, classes, and methods in the current file as a tree. Jump to any symbol instantly. Like VS Code's outline panel.

```
<leader>cs   → toggle aerial outline panel
{            → jump to previous symbol (function/class)
}            → jump to next symbol
```

### Inside the aerial panel

```
Enter        → jump to that symbol in your code
p            → preview symbol without leaving aerial
q            → close aerial
```

> **Tip:** Use aerial when working in a large file — instead of scrolling to find a function, open aerial and jump straight to it.

---

## Live Rename — inc-rename

When you rename a symbol (`<leader>cr`), it shows a **live preview** of every place that will change as you type — before you press Enter to confirm.

```
<leader>cr   → start renaming (now shows live preview as you type)
Enter        → confirm rename
Esc          → cancel
```

**Before inc-rename:** you typed the new name blindly then it changed everywhere
**After inc-rename:** you see all usages update in real time as you type the new name

---

## Better Folds — UFO

Smarter code folding using LSP and treesitter. Fold entire functions, classes, or import blocks. Shows a hint of how many lines are folded.

```
za           → toggle fold under cursor (open if closed, close if open)
zo           → open fold under cursor
zc           → close fold under cursor
zR           → open ALL folds in file
zM           → close ALL folds in file
zr           → open folds one level at a time
zm           → close folds one level at a time
zp           → peek inside a fold without opening it
```

### Fold hints

When a section is folded, UFO shows:

```python
class UserService:  ···  47 lines
```

The `47 lines` tells you how much is folded.

> **Tip:** Press `zM` to fold everything and get a high-level overview of the file structure. Then `za` on the function you want to work on.

---

## Tabout

When your cursor is **inside** brackets, quotes, or parentheses, press `Tab` to jump **out** to after the closing symbol — without reaching for arrow keys.

```
"hello|"   → press Tab → cursor moves to after the "
[item|]    → press Tab → cursor moves to after the ]
(arg|)     → press Tab → cursor moves to after the )
```

Works with: `"` `'` `` ` `` `(` `)` `[` `]` `{` `}` `<` `>`

> **Note:** When the completion popup is open, `Tab` still selects suggestions. Tabout only activates when the popup is closed.

---

## Color Highlighter

Hex, RGB, HSL, CSS named colors, and Tailwind classes are shown with a **colored background** inline — no more guessing what a color looks like.

```css
color: #ff6b6b; /* shows with pink/red background */
background: rgb(100, 200, 50); /* shows with green background */
color: red; /* shows with red background */
```

```html
<div class="bg-blue-500 text-red-300"><!-- both colors shown inline --></div>
```

No keymaps needed — it's always on automatically.

---

## Package Info

When you open `package.json`, shows the **current installed version** of each package inline, and highlights outdated ones.

```
<leader>np   → toggle showing package versions
<leader>nu   → update package under cursor to latest
<leader>nd   → delete package under cursor
<leader>ni   → install a new package
<leader>nc   → change version of package under cursor
```

Example view in `package.json`:

```json
"react": "^18.2.0"     ← shows installed version, green if up to date
"axios": "^1.3.0"      ← shows in red/orange if outdated
```

---

## Wakatime — Coding Time Tracker

Runs **silently in the background** — tracks exactly how much time you spend coding, broken down by project, language, and file. View your stats at wakatime.com.

### First-time setup

1. Sign up at wakatime.com (free)
2. Get your API key from the dashboard
3. In Neovim: `:WakaTimeApiKey` → paste your key → Enter
4. That's it — tracking starts automatically

### Useful commands

```
:WakaTimeApiKey   → set or update your API key
```

Stats are only visible at **wakatime.com/dashboard** — the plugin has no in-editor display.
It tracks silently in the background and sends data to your dashboard.

---

## Debugger — DAP

Step through code line by line, inspect variables, set breakpoints — all inside Neovim.
Works for **Python**, **Go**, and **TypeScript/JavaScript**.

---

### First-time setup

```
:Mason
```

Press `i` to install:

- `debugpy` — Python debugger
- `delve` — Go debugger
- `js-debug-adapter` — TypeScript/JavaScript debugger

---

### Understanding the UI layout

When you start debugging (`<F5>`), the UI opens automatically:

```
┌──────────────────────────────────┬──────────────────────────────────────┐
│  Variables                       │                                      │
│  ────────────────────────────    │                                      │
│  items = [Item(price=10), ...]   │         YOUR CODE                    │
│  total = 0                       │                                      │
│  item  = Item(price=10)          │   →  current line marked with ▶      │
│                                  │      variable values shown inline    │
│  Breakpoints                     │                                      │
│  ────────────────────────────    │                                      │
│  purchase_orders.py:42  ●        │                                      │
│                                  │                                      │
│  Call Stack                      │                                      │
│  ────────────────────────────    │                                      │
│  calculate_total  line 42        │                                      │
│  main             line 10        │                                      │
│                                  │                                      │
│  Watches                         │                                      │
│  ────────────────────────────    │                                      │
│  (type expressions to monitor)   │                                      │
└──────────────────────────────────┴──────────────────────────────────────┘
│  REPL — type: total * 2 → shows result │  Console — print() output here │
└────────────────────────────────────────┴────────────────────────────────┘
```

### What each panel means

**Variables (top-left)**
Shows every variable in the current scope and its live value. Expand objects with `▸`.
Updates automatically as you step through code.

**Breakpoints (middle-left)**
Lists every breakpoint you've set across all files. You can toggle them on/off here.

**Call Stack (lower-left)**
Shows the chain of function calls that led to the current line.
Example: `main()` called `process_order()` which called `calculate_total()`.
Click any frame to jump to that point and see its variables.

**Watches (bottom-left)**
Type any expression here to monitor it continuously as you step.
Example: add `len(items)` to always see the list length.

**REPL (bottom-center)**
Type any expression and press Enter to evaluate it live.
Example: type `total * 1.2` to calculate what the value would be with tax.

**Console (bottom-right)**
Your `print()` / `console.log()` / `fmt.Println()` output appears here.

---

### Controls

```
<F5>          → start / continue to next breakpoint
<F10>         → step OVER — run next line (don't enter functions)
<F11>         → step INTO  — enter the function being called
<F12>         → step OUT   — finish current function, return to caller
<F9>          → step BACK  — go one line back
<leader>dc    → run to cursor — skip ahead to where cursor is
<leader>dq    → stop debugging
<leader>dr    → restart session
<leader>du    → toggle UI open/close
```

### Breakpoints

```
<leader>db    → toggle breakpoint (red ● dot in gutter)
<leader>dB    → conditional breakpoint — only pauses if condition is true
                e.g. pause only when: total > 100
<leader>dl    → log point — print a message WITHOUT pausing execution
```

### Inspecting values

```
<leader>de    → evaluate expression under cursor in a floating popup
<leader>dh    → hover variable to see its value
```

In visual mode, select any expression then `<leader>de` to evaluate it.

---

### Step over vs step into — the most important distinction

```python
result = calculate_total(items)   # cursor is here
```

| Key               | What happens                                                                                 |
| ----------------- | -------------------------------------------------------------------------------------------- |
| `<F10>` step OVER | Runs `calculate_total()` completely and moves to next line. Use when you trust the function. |
| `<F11>` step INTO | Enters `calculate_total()` so you can debug inside it. Use when the function has a bug.      |
| `<F12>` step OUT  | Finishes the current function and returns to where it was called.                            |

---

### Breakpoint signs in gutter

```
●   red    → normal breakpoint — always pauses here
◆   blue   → conditional breakpoint — pauses only if condition is true
◎   teal   → log point — prints message, does not pause
▶   green  → current line being executed right now
```

---

### Full workflow — Python example

```python
def calculate_total(items):
    total = 0
    for item in items:        # step 1: set breakpoint here
        total += item.price
    return total
```

1. Open the file in Neovim
2. Place cursor on the `for` line → `<leader>db` → red dot `●` appears
3. Run your program / press `<F5>` → execution pauses at the breakpoint
4. **Variables panel** shows: `items = [...]`, `total = 0`
5. Press `<F10>` → moves to `total += item.price`
6. **Variables panel** updates: `item = Item(price=10.0)`
7. Press `<leader>de` with cursor on `item.price` → shows the value in a popup
8. Press `<F10>` again → `total` updates to `10.0` in the Variables panel
9. Press `<F5>` → continues to end (or next breakpoint)
10. Press `<leader>dq` → stop debugging

---

### Conditional breakpoint example

Useful when a bug only happens on a specific iteration:

```python
for item in items:   # set conditional breakpoint: item.price > 100
```

1. `<leader>dB` → a prompt appears: type `item.price > 100` → Enter
2. Debugging skips all items with price ≤ 100 and only pauses when price > 100

---

### Python-specific

```
<leader>dtm   → debug the test method cursor is inside
<leader>dtc   → debug the entire test class
```

### Go-specific

```
<leader>dgt   → debug the Go test under cursor
<leader>dgl   → re-run and debug last Go test
```

### How step over vs step into works

```
code:  result = calculate(x, y)

<F10> step OVER → runs calculate() completely, moves to next line
<F11> step INTO  → enters calculate() function, debugs inside it
<F12> step OUT   → finishes current function, returns to caller
```

---

## How to Customize

### Add a new plugin

Create a new file in `lua/plugins/` (or add to an existing one):

```lua
-- lua/plugins/my-plugin.lua
return {
  {
    "author/plugin-name",
    event = "VeryLazy",    -- load lazily for performance
    opts = {
      -- plugin options here
    },
    keys = {
      { "<leader>x", "<cmd>PluginCommand<cr>", desc = "Do something" },
    },
  },
}
```

### Disable a plugin

Add `enabled = false` to any plugin spec:

```lua
-- In the relevant plugin file:
{ "plugin/name", enabled = false }
```

### Add a new language

Edit `lua/config/lazy.lua` and add a LazyVim language extra:

```lua
{ import = "lazyvim.plugins.extras.lang.rust" },
{ import = "lazyvim.plugins.extras.lang.docker" },
{ import = "lazyvim.plugins.extras.lang.yaml" },
```

Then run `:Mason` to install the LSP server.

### Change a keymap

Edit `lua/config/keymaps.lua`:

```lua
-- Format: map("mode", "keys", "action", { desc = "description" })
map("n", "<leader>x", "<cmd>SomeCommand<cr>", { desc = "My command" })
```

Modes: `"n"` = normal, `"i"` = insert, `"v"` = visual, `"t"` = terminal

### Change editor settings

Edit `lua/config/options.lua`. All options are `vim.opt.setting = value`.

Common things to change:

```lua
opt.tabstop = 4      -- use 4-space tabs instead of 2
opt.wrap = false     -- disable line wrapping
opt.relativenumber = false  -- use absolute line numbers
```

---

## Complete Keybinding Reference

### Leader (`Space`) commands

| Key           | Action                               |
| ------------- | ------------------------------------ |
| `<leader>e`   | Toggle file explorer                 |
| `<leader>o`   | Focus file explorer                  |
| `<leader>ff`  | Find files                           |
| `<leader>fr`  | Recent files                         |
| `<leader>fb`  | Open buffers                         |
| `<leader>/`   | Live grep                            |
| `<leader>fw`  | Search word under cursor             |
| `<leader>ft`  | Search TODOs                         |
| `<leader>ss`  | Document symbols                     |
| `<leader>sS`  | Workspace symbols                    |
| `<leader>sk`  | Search keymaps                       |
| `<leader>:`   | Command history                      |
| `<leader>gc`  | Git commits                          |
| `<leader>gB`  | Git branches                         |
| `<leader>gg`  | Lazygit                              |
| `<leader>gop` | GitHub: list PRs                     |
| `<leader>goi` | GitHub: list issues                  |
| `<leader>gor` | GitHub: start PR review              |
| `<leader>gom` | GitHub: merge PR                     |
| `<leader>gd`  | Diffview (all changes)               |
| `<leader>gD`  | Diff vs last commit                  |
| `<leader>gfh` | File history                         |
| `<leader>gFH` | Project history                      |
| `<leader>gdc` | Close Diffview                       |
| `<leader>ghp` | Preview git hunk                     |
| `<leader>ghs` | Stage git hunk                       |
| `<leader>ghr` | Reset git hunk                       |
| `<leader>ghb` | Git blame line                       |
| `<leader>sr`  | Spectre (find & replace)             |
| `<leader>sW`  | Spectre (search word under cursor)   |
| `<leader>rr`  | REST: run request                    |
| `<leader>ra`  | REST: run all requests               |
| `<leader>rc`  | REST: copy as cURL                   |
| `<leader>re`  | REST: switch environment             |
| `<leader>uu`  | Toggle Undo Tree                     |
| `<leader>qs`  | Restore session                      |
| `<leader>ql`  | Restore last session                 |
| `<leader>qd`  | Discard session                      |
| `<leader>fp`  | Switch project                       |
| `<leader>ma`  | Multi-cursor: select all occurrences |
| `<leader>z`   | Toggle Zen mode                      |
| `<leader>cs`  | Code outline (Aerial)                |
| `<leader>np`  | Toggle package versions              |
| `<leader>nu`  | Update npm package                   |
| `<leader>ni`  | Install npm package                  |
| `<leader>nc`  | Change package version               |
| `zR`          | Open all folds                       |
| `zM`          | Close all folds                      |
| `zp`          | Peek inside fold                     |
| `<leader>ca`  | Code action                          |
| `<leader>cr`  | Rename symbol                        |
| `<leader>cf`  | Format file                          |
| `<leader>cd`  | Show diagnostic                      |
| `<leader>db`  | Debug: toggle breakpoint             |
| `<leader>dB`  | Debug: conditional breakpoint        |
| `<leader>dc`  | Debug: run to cursor                 |
| `<leader>du`  | Debug: toggle UI                     |
| `<leader>de`  | Debug: evaluate expression           |
| `<leader>dh`  | Debug: hover variable                |
| `<leader>dq`  | Debug: stop                          |
| `<leader>dr`  | Debug: restart                       |
| `<leader>dtm` | Debug: Python test method            |
| `<leader>dgt` | Debug: Go test                       |
| `<F5>`        | Debug: start / continue              |
| `<F10>`       | Debug: step over                     |
| `<F11>`       | Debug: step into                     |
| `<F12>`       | Debug: step out                      |
| `<leader>tt`  | Run nearest test                     |
| `<leader>tf`  | Run file tests                       |
| `<leader>tl`  | Re-run last test                     |
| `<leader>ts`  | Test summary panel                   |
| `<leader>to`  | Test output panel                    |
| `<leader>tS`  | Stop test                            |
| `<leader>tg`  | Lazygit terminal                     |
| `<leader>th`  | Horizontal terminal                  |
| `<leader>tv`  | Vertical terminal                    |
| `<leader>mp`  | Markdown preview                     |
| `<leader>uT`  | Switch theme                         |
| `<leader>fy`  | Yank history picker                  |
| `<leader>xx`  | All diagnostics (Trouble)            |
| `<leader>xX`  | File diagnostics (Trouble)           |
| `<leader>xL`  | Location list                        |
| `<leader>xQ`  | Quickfix list (enhanced)             |
| `<leader>cs`  | Symbols (Trouble)                    |
| `<leader>-`   | Split horizontal                     |
| `<leader>\|`  | Split vertical                       |
| `<leader>w=`  | Equalize windows                     |
| `<leader>w+`  | Increase window height               |
| `<leader>w-`  | Decrease window height               |
| `<leader>w>`  | Increase window width                |
| `<leader>w<`  | Decrease window width                |
| `<leader>bd`  | Close buffer                         |
| `<leader>A`   | Select all                           |
| `<leader>qq`  | Quit all                             |

### Multi-cursor (no leader)

| Key        | Action                                          |
| ---------- | ----------------------------------------------- |
| `<C-n>`    | Multi-cursor: select word / add next occurrence |
| `<C-Down>` | Multi-cursor: add cursor below                  |
| `<C-Up>`   | Multi-cursor: add cursor above                  |
| `n`        | Multi-cursor: add next match                    |
| `q`        | Multi-cursor: skip current match                |
| `Esc`      | Exit multi-cursor mode                          |

### LSP & Peek keys (no leader)

| Key   | Action                           |
| ----- | -------------------------------- |
| `gd`  | Go to definition                 |
| `gp`  | Peek definition                  |
| `gpi` | Peek implementation              |
| `gpr` | Peek references                  |
| `gpt` | Peek type definition             |
| `gpc` | Close peek windows               |
| `gr`  | Find references (fzf)            |
| `K`   | Hover documentation              |
| `]d`  | Next diagnostic                  |
| `[d`  | Previous diagnostic              |
| `]h`  | Next git hunk                    |
| `[h`  | Previous git hunk                |
| `]x`  | Next merge conflict              |
| `[x`  | Previous merge conflict          |
| `co`  | Resolve conflict — choose ours   |
| `ct`  | Resolve conflict — choose theirs |
| `cb`  | Resolve conflict — keep both     |
| `c0`  | Resolve conflict — keep none     |
| `]r`  | Next REST request                |
| `[r`  | Previous REST request            |
| `]f`  | Next failed test                 |
| `[f`  | Previous failed test             |
| `]q`  | Next quickfix                    |
| `[q`  | Previous quickfix                |

### Window & Split keys

| Key           | Action                          |
| ------------- | ------------------------------- |
| `<C-h/j/k/l>` | Navigate windows (tmux-aware)   |
| `<A-Left>`    | Resize split narrower           |
| `<A-Right>`   | Resize split wider              |
| `<A-Up>`      | Resize split taller             |
| `<A-Down>`    | Resize split shorter            |
| `<C-p>`       | Cycle yank history backward     |
| `<C-n>`       | Cycle yank history forward      |

### General keys

| Key           | Action                    |
| ------------- | ------------------------- |
| `<C-s>`       | Save file                 |
| `<C-\>`       | Toggle terminal           |
| `Tab`         | Next buffer               |
| `Shift+Tab`   | Previous buffer           |
| `H`           | Previous buffer           |
| `L`           | Next buffer               |
| `jk`          | Exit insert mode          |
| `Esc`         | Clear search / close peek |
| `Alt+j`       | Move line/selection down  |
| `Alt+k`       | Move line/selection up    |
| `>` (visual)  | Indent right              |
| `<` (visual)  | Indent left               |
| `p` (visual)  | Paste without yank        |

### Vim built-ins worth knowing

| Key      | Action                            |
| -------- | --------------------------------- |
| `u`      | Undo                              |
| `Ctrl+r` | Redo                              |
| `yy`     | Copy line                         |
| `dd`     | Delete line                       |
| `p`      | Paste after cursor                |
| `P`      | Paste before cursor               |
| `ciw`    | Change inner word                 |
| `di"`    | Delete inside quotes              |
| `o`      | New line below, enter insert      |
| `O`      | New line above, enter insert      |
| `A`      | Go to end of line, enter insert   |
| `I`      | Go to start of line, enter insert |
| `%`      | Jump to matching bracket          |
| `*`      | Search for word under cursor      |
| `za`     | Toggle fold                       |
| `.`      | Repeat last action                |

---

## Useful Commands

```
:Lazy          → open plugin manager
:Lazy sync     → install + update all plugins
:Lazy clean    → remove unused plugins
:Mason         → manage LSP server installations
:LspInfo       → show active LSP servers for current file
:LspRestart    → restart LSP servers
:checkhealth   → diagnose issues with Neovim setup
:noh           → clear search highlights
:e filename    → open a file
:vs filename   → open file in vertical split
:sp filename   → open file in horizontal split
```
