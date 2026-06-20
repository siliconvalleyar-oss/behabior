# Reglas de Programación — Behabior

## Convenciones generales

- **Idioma**: Código, comentarios y nombres en **inglés**.
- **Estilo Dart**: Usar `flutter_lints` con reglas estrictas (`pedantic`/`lints`).
- **Formato**: Correr `dart format` antes de cada commit.

## Arquitectura

- **Flame para el mundo del juego**, widgets de Flutter para HUD/menús.
- **Systems** (`lib/core/systems/`) para lógica transversal (audio, puntuación, oleadas).
- **Entities** (`lib/core/entities/`) para componentes del juego (player, enemy, boss, projectile).
- **Components** (`lib/core/components/`) para elementos visuales reutilizables (joystick, partículas, transiciones).
- **Data** (`lib/data/`) con separación models / providers / repositories.

## Assets

- **Sprites**: `assets/images/sprites/` — PNGs sin animación.
- **Animaciones Rive**: `assets/animations/` — archivos `.riv`.
- **Audio**: `assets/audio/music/` y `assets/audio/sfx/`.
- **Icono de app**: `assets/icon/logo.png` — convertir a mipmap manualmente.

## Manejo de errores

- Toda inicialización asíncrona debe tener `try/catch` para evitar pantallas congeladas.
- Usar `debugPrint()` para errores de desarrollo con prefijo `[BEHABIOR]`.

## Commits y versionado

- Prefijos de commit: `fix:`, `feat:`, `refactor:`, `docs:`, `chore:`.
- Tags semánticos: `v1.0.0`, `v1.1.0`, etc.

## Flujo de juego

```
menu → levelSelect → playing → (gameOver | levelComplete) → menu
```

- `AppScreen` enum en `GameState` gobierna la navegación.
- `GameState` (ChangeNotifier) es el estado global vía Provider.
- No mutar `GameState` desde dentro del bucle de Flame.
