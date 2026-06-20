# Dino Run — Assets

## Dino Sprites

| File | Usage |
|------|-------|
| `assets/images/dino/dino_run_00.png` | Run frame 0 / jump / dead |
| `assets/images/dino/dino_run_01.png` | Run frame 1 |
| `assets/images/dino/dino_run_02.png` | Run frame 2 |
| `assets/images/dino/dino_run_03.png` | Run frame 3 |

Cycle: 4 frames, 10 FPS animation speed.

## App Icon

- Source: `assets/icon/logo.png`
- Converted to mipmap via PIL: `python3 -c "from PIL import Image; img=Image.open('logo.png'); [img.resize((s,s), Image.LANCZOS).save(f'android/app/src/main/res/mipmap-{d}/ic_launcher.png') for d,s in [('mdpi',48),('hdpi',72),('xhdpi',96),('xxhdpi',144),('xxxhdpi',192)]]"`

## Fallback

If sprites fail to load, all entities render via Canvas (geometric shapes). No crash.
