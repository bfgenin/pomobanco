<img src="docs/videos/header-scroll.svg" alt="PomoBanco" width="100%" height="200px"/>

<h1 align="center">
  <span style="color:#D31140;font-weight:800;letter-spacing:-0.02em">Pomo</span><span style="color:#220F58;font-weight:800;letter-spacing:0.1em;text-shadow:-1px -1px 0 #38131C,1px -1px 0 #38131C,-1px 1px 0 #38131C,1px 1px 0 #38131C,0 0 8px rgba(211,17,64,0.9),0 0 18px rgba(211,17,64,0.5);">Banco</span>
</h1>

<p align="center"><em>A Pomodoro-style timer and lightweight project tracker for iOS.</em></p>

<p align="center"><img src="docs/videos/pomo-workflow.gif" alt="Pomo workflow" width="320" /></p>

## Quick overview

**PomoBanco** is a Pomodoro-style timer + lightweight project tracker for iOS.

Core features:

- Run a timer session in **Pomodoro** (fixed intervals) or **Focus** (stopwatch) mode
- Attach the session to a **Project** (stored with SwiftData)
- See how much time you spent per project **weekly** and **all time** in the chart view
- Manage projects with a simple **add / select / delete** workflow—organize as lightly or as thoroughly as you like

---

## Feature walkthrough

### Timer

<p align="center"><img src="docs/videos/mode-flip.gif" alt="Flip timer modes" width="320" /></p>

Flip between **Pomodoro** and **Focus** timer modes.

#### Pomodoro mode

<p align="center"><img src="docs/videos/change-timer-length.gif" alt="Change timer length" width="320" /></p>

Set a timer to a preset length (25, 35, or 45 minutes) and work until it ends, then take a break.

#### Focus mode

<p align="center"><img src="docs/videos/focus-time-end.gif" alt="Focus mode timer end" width="320" /></p>

Run a stopwatch for as long as you work—handy for deep work without countdown alerts.

<p align="center"><img src="docs/videos/focus-mode-flow.gif" alt="Focus mode flow" width="320" /></p>

- Focus mode can blur project details for fewer distractions.

#### Skip session

Started a timer by mistake or did no real work? Skip the session so that time is not added to your project.

<p align="center"><img src="docs/videos/pomo-skip-session.gif" alt="Skip session" width="320" /></p>

### Projects

<p align="center"><img src="docs/videos/add-delete-workflow.gif" alt="Add and delete projects" width="320" /></p>

Track time against **projects** (name plus optional tag and description).

Projects can be tagged for easier organization. The tag picker supports creating new tags on the fly. Remove a project by tap-and-holding it in the project list.

---

#### Weekly tracking (chart)

<p align="center"><img src="docs/videos/view-project-details.gif" alt="Weekly chart and project details" width="320" /></p>

- Track progress week by week in the chart view. Bars show total duration per day; new sessions appear when you complete them.

Built with **SwiftUI**, **SwiftData**, and **RealityKit** (optional 3D "tomato" timer; falls back to a simple placeholder when unavailable).

## Requirements

- Xcode 16+
- iOS 18+ (RealityKit tomato); fallback works on earlier iOS
- Swift 5

## Run locally

1. Clone the repo.
2. Open `PomoBanco.xcodeproj` in Xcode.
3. Pick an iOS simulator or device and run (⌘R).

<img src="docs/videos/header-scroll-blue.svg" alt="PomoBanco" width="100%" height="50%"/>