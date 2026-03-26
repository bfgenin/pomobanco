---
layout: default
---

<style>
  body {
    background:  #2b2b2b !important;
    color: #ffffff !important;
  } 

  header, .site-header, .page-header {
    display: none !important;
  }

  .site-header, .page-header, .border-bottom {
    border-bottom: none !important;
  }


  .container {
    max-width: 1400px !important;
  }

  .wrapper, main {
    max-width: 1400px !important;
    margin-left: auto;
    margin-right: auto;
  }

 
  .page-content {
    background: #141414 !important;
    border-radius: 12px;
    padding: 2rem 1.75rem;
  }
</style>

<h1 align="center">
  <span style="color:#D31140;font-weight:800;letter-spacing:0.1em;-webkit-text-stroke:0.2px white">Pomo</span><span style="color:#220F58;font-weight:800;letter-spacing:0.1em;-webkit-text-stroke:0.2px white">Banco</span>
</h1>

<p align="center"><em>A Pomodoro-style timer and lightweight project tracker for iOS.</em></p>

<p align="center"><video autoplay muted loop playsinline controls width="320" src="{{ '/videos/pomo-workflow.mov' | relative_url }}"></video></p>

## Quick overview

**PomoBanco** is a Pomodoro-style timer + lightweight project tracker for iOS.

Core features:

- Run a timer session in **Pomodoro** (fixed intervals) or **Focus** (stopwatch) mode
- Attach the session to a **Project** (stored with SwiftData)
- See how much time you spent per project **weekly** and **all time** in the chart view
- Manage projects with a simple **add / select / delete** workflow—organize as lightly or as thoroughly as you like


Built with **SwiftUI**, **SwiftData**, and **RealityKit** (a 3D “tomato” timer; falls back to a simple placeholder when unavailable).


---

## Feature walkthrough

### Timer

<p align="center"><video autoplay muted loop playsinline controls width="320" src="{{ '/videos/mode-flip.mov' | relative_url }}"></video></p>

Flip between **Pomodoro** and **Focus** timer modes.

#### Pomodoro mode

<p align="center"><video autoplay muted loop playsinline controls width="320" src="{{ '/videos/change-timer-length.mov' | relative_url }}"></video></p>

Set a timer to a preset length (25, 35, or 45 minutes) and work until it ends, then take a break.

#### Focus mode

<p align="center"><video autoplay muted loop playsinline controls width="320" src="{{ '/videos/focus-time-end.mov' | relative_url }}"></video></p>

Run a stopwatch for as long as you work—handy for deep work without countdown alerts.

<p align="center"><video autoplay muted loop playsinline controls width="320" src="{{ '/videos/focus-mode-flow.mov' | relative_url }}"></video></p>

- Focus mode can blur project details for fewer distractions.

#### Skip session

Started a timer by mistake or did no real work? Skip the session so that time is not added to your project.

<p align="center"><video autoplay muted loop playsinline controls width="320" src="{{ '/videos/pomo-skip-session.mov' | relative_url }}"></video></p>

### Projects

<p align="center"><video autoplay muted loop playsinline controls width="320" src="{{ '/videos/add-delete-workflow.mov' | relative_url }}"></video></p>

Track time against **projects** (name plus optional tag and description).

Projects can be tagged for easier organization. The tag picker supports creating new tags on the fly. Remove a project by tap-and-holding it in the project list.

---

#### Weekly tracking (chart)

<p align="center"><video autoplay muted loop playsinline controls width="320" src="{{ '/videos/view-project-details.mov' | relative_url }}"></video></p>

- Track progress week by week in the chart view. Bars show total duration per day; new sessions appear when you complete them.

---

[← Repository on GitHub](https://github.com/bfgenin/pomobanco)

