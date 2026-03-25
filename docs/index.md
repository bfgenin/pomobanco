---
layout: default
---

<img src="{{ '/videos/header-scroll.svg' | relative_url }}" alt="PomoBanco" width="100%"/>

<h1 align="center">
  <span style="color:#D31140;font-weight:800;letter-spacing:-0.02em;text-shadow:-1px -1px 0 #38131C,1px -1px 0 #38131C,-1px 1px 0 #38131C,1px 1px 0 #38131C,0 0 8px rgba(211,17,64,0.9),0 0 18px rgba(211,17,64,0.5);">Pomo</span><span style="color:#220F58;font-weight:800;letter-spacing:0.1em;text-shadow:-1px -1px 0 #38131C,1px -1px 0 #38131C,-1px 1px 0 #38131C,1px 1px 0 #38131C,0 0 8px rgba(211,17,64,0.9),0 0 18px rgba(211,17,64,0.5);">Banco</span>
</h1>

<p align="center"><em>A Pomodoro-style timer and lightweight project tracker for iOS.</em></p>

<p align="center"><video controls loop width="320" src="{{ '/videos/pomo-workflow.mov' | relative_url }}"></video></p>

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

<p align="center"><video controls loop width="320" src="{{ '/videos/mode-flip.mov' | relative_url }}"></video></p>

Flip between **Pomodoro** and **Focus** timer modes.

#### Pomodoro mode

<p align="center"><video controls loop width="320" src="{{ '/videos/change-timer-length.mov' | relative_url }}"></video></p>

Set a timer to a preset length (25, 35, or 45 minutes) and work until it ends, then take a break.

#### Focus mode

<p align="center"><video controls loop width="320" src="{{ '/videos/focus-time-end.mov' | relative_url }}"></video></p>

Run a stopwatch for as long as you work—handy for deep work without countdown alerts.

<p align="center"><video controls loop width="320" src="{{ '/videos/focus-mode-flow.mov' | relative_url }}"></video></p>

- Focus mode can blur project details for fewer distractions.

#### Skip session

Started a timer by mistake or did no real work? Skip the session so that time is not added to your project.

<p align="center"><video controls loop width="320" src="{{ '/videos/pomo-skip-session.mov' | relative_url }}"></video></p>

### Projects

<p align="center"><video controls loop width="320" src="{{ '/videos/add-delete-workflow.mov' | relative_url }}"></video></p>

Track time against **projects** (name plus optional tag and description).

Projects can be tagged for easier organization. The tag picker supports creating new tags on the fly. Remove a project by tap-and-holding it in the project list.

---

#### Weekly tracking (chart)

<p align="center"><video controls loop width="320" src="{{ '/videos/view-project-details.mov' | relative_url }}"></video></p>

- Track progress week by week in the chart view. Bars show total duration per day; new sessions appear when you complete them.

Built with **SwiftUI**, **SwiftData**, and **RealityKit** (optional 3D “tomato” timer; falls back to a simple placeholder when unavailable).

---

[← Repository on GitHub](https://github.com/bfgenin/pomobanco)
