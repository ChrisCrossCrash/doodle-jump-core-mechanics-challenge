# Design Document

**Working title:** Kamil's Cards
**Jam deadline:** May 4th 2026 at 4:00 AM CDT

## Pitch
Kamil's Cards is a Doodle Jump inspired game where the player is a card-playing high-rolling Rocky Mountain Bighorn Sheep named Kamil. As Kamil climbs, he collects cards to make the perfect poker hand. When Kamil lands a poker hand, he gets a boost that rockets him up the mountain. The better the hand, the bigger the boost!

## Design Pillars
1. Playable without knowledge of poker, but more fun if you do know poker
2. It pays to be picky, but it's fun to catch a lucky break!
3. Each run is a one-off. No grinding or progression between runs.

## Core Loop
When the player starts a run, they control Kamil as he jumps up the mountain. Kamil automatically jumps up, and the player can move him left and right to land on platforms. If Kamil misses a platform and falls off the screen, it's game over. Some, but not all of the platforms have cards on them. When Kamil lands on a platform with a card, he collects that card and adds it to his hand. If Kamil's hand forms a valid poker hand, he gets a boost that propels him up the mountain. The better the hand, the bigger the boost! The player tries to climb as high as possible before falling off the screen.

## Mechanics
- **Jumping and moving**: Kamil automatically jumps upward, and the player can move him left and right to land on platforms.
- **Card collection**: When Kamil lands on a platform with a card, he collects that card and adds it to his hand.

## Aesthetic Direction
- **Visual:** Modern pixel art. Think Terraria or Stardew Valley. The level design is a mountain waterfall with stone ledges sticking out as the platforms.
- **Audio:** Swanky big band jazz suitable for a casino floor — upbeat, brassy, public-domain era recordings. Primary candidate: BugaBlue by U.S. Army Blues.
- **Tone:** Playful, sunny, and energetic — a casino as an inviting playground rather than a den of vice. The jazz and the bouncy cartoon SFX should reinforce a sense of cheerful momentum: every jump and every card combo feels like a small celebration, not a tense gamble.

## Content List
- Very basic implementation of Doodle Jump as a base to build on.
- Randomly spawning platforms, some with cards attached to them. Platforms get more sparse the higher you go. Some platforms are one time use (they break after being touched)
- UI: Height reached, hand of cards, popups when a card combo is achieved

## Out of Scope
- Settings menu (stretch goal: music on/off toggle)
- Multiplayer functionality
- Mobile (app) build
- Leaderboards
