# Podcast Reaction Demo

A SwiftUI demo that prototypes **timestamp-based reactions** on top of a **podcast episode player**. It uses local mock data only: no backend, no real audio playback, and no user accounts. The goal is a clear product flow: listen (simulated), open comments, browse by tab or by moment, and post a reaction tied to a specific time in the episode.

## Requirements

- Xcode 15 or newer (recommended)
- iOS **17.0** or later (deployment target)
- Swift 5.9+ (as provided by the Xcode toolchain)

## How to run

1. Open `PodcastReactionDemo/PodcastReactionDemo.xcodeproj` in Xcode.
2. Select an iPhone simulator or device.
3. Build and run the `PodcastReactionDemo` scheme.

## What is included

- **Episode player screen**  
  Mock playback UI: progress, time, transport controls, and an entry to the comment area (no real audio engine).

- **Comments hub**  
  Tabs: **All**, **Latest**, and **Moments** (grouped by timestamp). A **current playhead** row jumps to comments at the simulated “now” time.

- **Moment thread**  
  Comments for a single timestamp, with **Timeline** vs **Popular** sorting.

- **Add comment**  
  Sheet to compose text, pick a mood, and post. New items append to the in-memory store and refresh lists.

## Architecture (short)

- **SwiftUI** for UI, **MVVM**-style separation.
- **`EpisodeViewModel`** (`@Observable`, main actor) holds UI state and talks to a **`MockReactionService`**.
- **`MockData`** seeds one podcast, one episode, and sample comments.

## Repository layout

```text
PodcastReactionDemo/
├── PodcastReactionDemo.xcodeproj
└── PodcastReactionDemo/
    ├── App/                 App entry
    ├── Models/              Domain types (episode, comment, mood, tabs)
    ├── ViewModels/
    ├── Views/               Player, comments, moment thread, add sheet
    ├── Views/Components/
    ├── Services/            Mock reaction service
    ├── Data/                Mock seed data
    └── Utils/               `TimeFormatter.swift` (time + `DesignTokens` for the comment stack)
```

## Screenshots

Images live in **`docs/screenshots/`** (PNG).

**Episode player**

![Episode player screen](docs/screenshots/episode-player.png)

**Comments hub (tabs and current moment entry)**

![Comments hub](docs/screenshots/comments-hub.png)

**Moment comments (1)**

![Moment comments 1](docs/screenshots/moment-comments1.png)

**Moment comments (2)**

![Moment comments 2](docs/screenshots/moment-comments2.png)

**Add comment sheet**

![Add comment](docs/screenshots/add-comment.png)

## License

No license is specified in this repository. Add one if you plan to distribute or open-source the project.
