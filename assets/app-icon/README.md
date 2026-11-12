# IrisCine app icon

**Drawing:** an open clapperboard (striped arm hinged at the top-left of the striped board) with a
play triangle on the board. It follows the Iris icon language shared with IrisWord: a white glyph
on a rounded gradient tile.

## Palette

| Colour | Hex | Used for |
|---|---|---|
| Iris coral → magenta | `#ff6a5c` → `#bd44c0` | the full-bleed tile (diagonal gradient) and the play triangle |
| Plum | `#4b2148` → `#2e1538` | the clapperboard stripes |
| White | `#ffffff` | the clapperboard |

The coral → magenta gradient sets IrisCine apart from IrisWord's violet (`#8a79ff` → `#bd44c0`)
while sharing its magenta end. The updater's accent colour (`UPDATE_APP` in
`crates/ui-egui/src/lib.rs`) is `#d9507e`, the middle of the gradient.

## Geometry and style

- A 512-unit viewBox tile, rounded square `rx=112`, with the gradient full bleed (no frame or border).
- macOS renders (`filmcraft.icns`, `filmcraft-macos-512.png`) put the tile in Apple's grid (824 of
  1024 px, transparent margin). Windows, Linux and the web use the full-bleed tile.
- Readable down to 16 px: the stripes, the board and the play triangle stay distinct.

## Provenance

Drawn by hand as SVG for IrisCine; no third-party material. FilmCraft's owl icon is not used.
An Iris brand asset owned by Gabriel Alves Tech, not covered by the code license: [LICENSE.txt](LICENSE.txt).

## Files

| File | What |
|---|---|
| `filmcraft.svg` | canonical artwork (the file keeps FilmCraft's name so upstream merges stay simple) |
| `filmcraft-small.svg` | the same drawing, copied to `hicolor/scalable` |
| `filmcraft-1024.png` | 1024 px render |
| `filmcraft-macos-512.png` | runtime Dock icon on macOS (embedded by `apps/filmcraft/src/main.rs`) |
| `filmcraft.icns` | macOS bundle icon (`CFBundleIconFile`) |
| `filmcraft.ico` | Windows icon, 16–256 px (embedded in `filmcraft.exe` by `apps/filmcraft/build.rs`) |
| `hicolor/<size>/apps/com.iris.iriscine.png`, `hicolor/scalable/…svg` | Linux icon theme, used by `packaging/linux/com.iris.iriscine.desktop` |

The web app's `apps/filmcraft-web/web/favicon.png` (128 px) comes from the same artwork.

## How the icon reaches each OS

- **macOS:** the window icon set at startup (`ViewportBuilder::with_icon`) is the Dock and app-switcher
  icon when the app runs unbundled. A future `.app` bundle points `CFBundleIconFile` at `filmcraft.icns`.
- **Windows:** `build.rs` embeds `filmcraft.ico` as the exe's resource icon (Explorer, Start menu,
  pinned taskbar), and the runtime icon covers the window, taskbar and Alt-Tab.
- **Linux:** the runtime icon plus `with_app_id("com.iris.iriscine")`, which Wayland matches to
  the `.desktop` file. Install the `hicolor/` tree under `/usr/share/icons/hicolor/` and the desktop
  file under `/usr/share/applications/`.

## Regenerate

`packaging/icons.sh` (needs `resvg` or `rsvg-convert`; the `.icns` is written by `iconutil` on macOS or
by `python3` elsewhere; the `.ico` is packed by `cargo xtask ico`). To change the artwork, edit `filmcraft.svg`, copy it to `filmcraft-small.svg`, then run the script. Every derived file needs its `.attribution` sidecar
and a row in `ATTRIBUTION.md`.
