# The m3ga emacs experience

Inspired by the muscle memory of common text editors and IDEs: Kate, VSCode, IntelliJ, NetBeans, and regular browser defaults.

Also inspired by the ideas behind ergoemacs by that Xah guy (fly keys).

This config is mine. It is for me. I'm not building it with the intention to distribute.
But I have a mind for standards, so I'm exercising my freedom to develop a pseudo-one, or two.

## elpaca packaging

Chose between package-vc-install vs straight vs use-package vs elpaca.

Orderless + vertico + corfu to turn minibuffer into centered floating command palette.

## Bindings

- ✅ `ctrl+t` : new tab
- ✅ `ctrl+←↑↓→` : jumps text
- ✅ `ctrl+pgup/pgdn` : tab right/left
- ✅ `shift+←↑↓→` : selects text
- ✅ `ctrl+(` : split pane right
- ✅ `ctrl+)` : split pane down

## Frutiger Motions

- `shift`: select, invert, intensify, 2nd function
- `alt`: navigation 
- `ctrl`: modification, mode switching, jumping

1D nav: ←→ ↓↑ ad sw ( hl jk / j; lk )  
2D nav: ←↓↑→ aswd ( hjkl / jlk; )  
3D nav: wasdqe

1D navigable orders examples:

- adjacent (visually next to, on an axis xyz. e.g., visual list of tabs/buffers in a line)
- hierarchy (↑↓ filetree)
- time (mru lru, undo redo)

## Typhob-Myedne Navigation

A navigation paradigm that uses LRU & bounding box related scanning to reliably and deterministically navigate focusable rectangles in a 2D plane.

~~~
╔══════════╗ ╔┏━━┓══════╗
║╔════╗╔══╗║ ║┗━━┛═╗╔══╗║
║║╔╗╔╗║║╔╗║║ or ║║╔╗╔┏━━┓╗║║
║║╚╝╚╝║║╚╝║║ even ║║┏━━┓━━┛╝║║
║║╔══╗║║╔╗║║ ║║┃ ┃║║╔╗║║
║║╚══╝║║╚╝║║ ║║┗━━┛┏━━┓║║
║╚════╝╚══╝║ ║╚════┗━━┛╝║
╚══════════╝ ╚══════════╝
~~~



## Parity With KDE Kate

- 🔳 XDG file picker
- 🔳 Unsaved buffer confirmation dialogue before quit
- 🔳 Unsaved buffer confirmation dialogue inhibit KDE Plasma shutdown
- 🔳 File tree sidemenu (auto refreshing)
- 🔳 Code navigation sidemenu (menu of variables, functions, classes, etc.)
- 🔳 Buffer list sidemenu
- 🔳 `shift+enter` auto copies bullet point, non-normal leading text over to new line
- 🔳 Multi-cursor ↑↓
- 🔳 `S-Tab` / `Tab` on selection (un)indents

## Potentials

- 🔳 `ctrl+tab` triggers autocompletion, intellisense
- 🔳 `ctrl+esc` / `ctrl+space` leader for keychord sequence listening
- 🔳 `shift+esc` same as `C-g` (quit any keychord sequence lock)
- 🔳 Timed passive keychord sequence listening
