# Roadmap

## M1 — Skeleton (Days 3–4)
*Goal: A playable Doodle Jump clone with placeholder shapes. No cards yet, no art, no audio.*

- [x] Project setup in Godot, version control initialized
- [x] Set up window settings
- [ ] Kamil placeholder (rectangle) with auto-jump and gravity
- [ ] Left/right player input (keyboard/controller)
- [ ] Begin game player input (keyboard, controller)
- [ ] Camera follows Kamil upward only (never scrolls down)
- [ ] Platform placeholder, basic collision (land only on top)
- [ ] Random platform spawning above the camera
- [ ] Platforms despawn when off-screen below
- [ ] Fall-off-bottom detection → triggers game over state
- [ ] Minimal game over screen (text only) with "Play Again" that resets state
- [ ] Height tracker (debug text in corner)
- [ ] Test build export to catch any early issues with the export process

**M1 exit:** I can play a 30-second run, fall off the bottom, click play again, and run again. No art, no audio, no cards. Also, the build should work.

## M2 — Card mechanic (Days 4–5)
*Goal: The novel mechanic works end-to-end. Still placeholder art.*

- [ ] **Decisions to lock before coding this milestone:**
  - [ ] Deck behavior (depletes? draws with replacement? infinite?)
  - [ ] Behavior when hand has 5 cards and Kamil grabs a 6th
  - [ ] Auto-trigger boost when hand is valid, or manual "cash in" by player input
  - [ ] What happens to cards after a boost (full reset, keep unused, etc.)
  - [ ] Whether player can discard/replace cards
- [ ] Card data model (suit, rank)
- [ ] Card-bearing platforms — spawn cards on a fraction of platforms
- [ ] Card collection on landing — adds card to hand
- [ ] Hand UI placeholder (5 slots, text labels showing collected cards)
- [ ] Poker hand evaluator (pair, two pair, three of a kind, straight, flush, full house, four of a kind, straight flush, royal flush)
- [ ] Boost trigger when valid hand detected
- [ ] Boost magnitudes per hand type (initial guesses, will tune later)
- [ ] Hand reset behavior after boost
- [ ] One-time-use breakable platforms (sparse, per the design doc)
- [ ] Platform density falloff with height

**M2 exit:** I can play a full run where collecting cards and forming hands actually drives the gameplay. The core game is provable here. If it isn't fun at this point, that's the moment to stop and rethink — not later.

## M3 — Art pass (Days 5–7)
*Goal: Replace placeholders with real sprites and backgrounds. Visuals match the design doc.*

- [ ] Pick sprite sizes and tile size by making the first Kamil sprite and seeing what reads at the chosen render resolution
- [ ] Kamil sprite — idle
- [ ] Kamil sprite — jumping up
- [ ] Kamil sprite — falling down
- [ ] Regular platform sprite
- [ ] Card platform sprite
- [ ] Breakable platform sprite (visually distinct from regular)
- [ ] Card sprites (52 cards, or a system that composes them from suit + rank parts)
- [ ] Animated waterfall background
- [ ] Bottom-of-screen mist overlay
- [ ] Starting platform sprite
- [ ] Title text/logo
- [ ] Falling splash effect
- [ ] Card hand UI — empty slot sprite (looks like a card back)
- [ ] Card hand UI — populated slot rendering with real card sprites
- [ ] Card combo popup styling
- [ ] "Play Again" button sprite

**M3 exit:** The game looks like the game. Every placeholder is replaced. UI is final-ish (may still need adjustment after audio and feel pass).

## M4 — Audio + screens + feel (Days 7–8)
*Goal: Audio in, framing screens built, the game feels like a game.*

- [ ] Background music — verify BugaBlue source and licensing, drop in track, set up looping
- [ ] Jumping SFX (springy bounce)
- [ ] Card collection SFX (paper/card sound)
- [ ] Card combo SFX (coin cascade + jackpot bell)
- [ ] Falling SFX (cartoon falling sound)
- [ ] Splash SFX (when Kamil hits the bottom mist)
- [ ] Volume mixing — nothing drowns out anything else
- [ ] Title screen — title, Kamil illustration, fade-up-into-gameplay transition
- [ ] Game over screen — final layout, score, high score, play again
- [ ] High score persistence (saved between runs)
- [ ] Hand-flash effect when a combo lands
- [ ] Combo popup ("Two Pair! +3 m") above Kamil's head
- [ ] Tuning pass — jump height, gravity, platform density, boost magnitudes per hand. This is *the* feel work; budget real time for it.

**M4 exit:** A clean run looks, sounds, and feels right. The game is content-complete.

## M5 — Release (Day 8 → Day 9)
*Goal: It's on the jam page and someone other than me has played the actual exported build.*

- [ ] Final bug pass — fix anything that breaks the experience; document and accept the rest
- [ ] Build and export from Godot
- [ ] Test the exported build on a clean system (different machine if possible)
- [ ] Set up itch.io (or jam platform) page — title, description, screenshots, gameplay GIF or short clip
- [ ] Capsule/cover image
- [ ] Verify BugaBlue licensing documentation is in the project files
- [ ] Submit to the jam
- [ ] Day 9 — buffer for anything that goes wrong; if nothing goes wrong, take it off

**M5 exit:** Submitted. Done.