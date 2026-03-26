<img src="docs/videos/header-scroll.svg" alt="PomoBanco" width="100%" height="50%"/>

<h1 align="center">
  <span style="color:#D31140;font-weight:800;letter-spacing:-0.02em;text-shadow:-1px -1px 0 #38131C,1px -1px 0 #38131C,-1px 1px 0 #38131C,1px 1px 0 #38131C,0 0 8px rgba(211,17,64,0.9),0 0 18px rgba(211,17,64,0.5);">Pomo</span><span style="color:#220F58;font-weight:800;letter-spacing:0.1em;text-shadow:-1px -1px 0 #38131C,1px -1px 0 #38131C,-1px 1px 0 #38131C,1px 1px 0 #38131C,0 0 8px rgba(211,17,64,0.9),0 0 18px rgba(211,17,64,0.5);">Banco</span>
</h1>

<p align="center"><em>A Pomodoro-style timer and lightweight project tracker for iOS.</em></p>

<p align="center"><strong><a href="https://bfgenin.github.io/pomobanco/">Full walkthrough with videos →</a></strong></p>

## Quick overview

**PomoBanco** is a Pomodoro-style timer + lightweight project tracker for iOS.

Core features:

- Run a timer session in **Pomodoro** (fixed intervals) or **Focus** (stopwatch) mode
- Attach the session to a **Project** (stored with SwiftData)
- See how much time you spent per project **weekly** and **all time** in the chart view
- Manage projects with a simple **add / select / delete** workflow—organize as lightly or as thoroughly as you like

Screen recordings (timer modes, projects, weekly chart) are on the **GitHub Pages** site.

Built with **SwiftUI**, **SwiftData**, and **RealityKit** (optional 3D “tomato” timer; falls back to a simple placeholder when unavailable).

## Requirements

- Xcode 16+
- iOS 18+ (RealityKit tomato); fallback works on earlier iOS
- Swift 5

## Run locally

1. Clone the repo.
2. Open `PomoBanco.xcodeproj` in Xcode.
3. Pick an iOS simulator or device and run (⌘R).
