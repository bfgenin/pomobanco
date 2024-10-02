//
//  Content-ViewModel.swift
//  5MinuteTimer
//
//  Created by Federico on 07/04/2022.
//

import Foundation

    final class TimerModel: ObservableObject {
        @Published var isActive = false
        @Published var showingAlert = false
        @Published var time: String = "25:00"
        @Published var minutes: Float = 25.0 {
            didSet {
                self.time = "\(Int(minutes)):00"
            }
        }
        @Published var elapsedTime: Float = 0.0
        @Published var stopWatchTime: String = "00:00"
        
        var initialTime = 0
        private var endDate = Date()
        
        // starts the timer with the given amount of minutes
        func start(minutes: Float) {
            self.initialTime = Int(minutes)
            self.endDate = Date()
            self.isActive = true
            self.endDate = Calendar.current.date(byAdding: .minute, value: Int(minutes), to: endDate)!
        }
        
        func pause() {
            self.isActive = false
        }
        // ends timer: resets timer to inital-time
        func end() {
            self.minutes = Float(initialTime)
            self.isActive = false
            self.time = "\(Int(minutes)):00"
            self.elapsedTime = 0.0
        }
        
        // resets stopwatch to 00:00
        func reset() {
            self.minutes = 0.0
            self.isActive = false
            self.stopWatchTime = "00:00"
            self.elapsedTime = 0.0
        }
        
        
        // stop watch function for focus-mode
        func updateStopwatch() {
            guard isActive else { return }
            self.elapsedTime += 1.0
            
            let totalSeconds = Int(elapsedTime)
            let minutes = (totalSeconds / 60) % 60
            let seconds = totalSeconds % 60
            let hours = totalSeconds / 3600
            
            if hours > 0 {
                stopWatchTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            } else {
                stopWatchTime = String(format: "%02d:%02d", minutes, seconds)
            }
        }

        
        // show updates of the timer
        func updateCountdown(){
            guard isActive else { return }
            
            // Gets the current date and makes the time difference calculation
            let now = Date()
            let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
            // remaining seconds in timer
            
            // Checks that the countdown is not <= 0
            if diff <= 0 {
                self.isActive = false
                self.time = "0:00"
                self.showingAlert = true
                return
            }
            
            // update elapsed time
            self.elapsedTime = Float(initialTime)*60.0 - Float(diff)
            
            // turns the time difference calculation into sensible data and formats it
            let date = Date(timeIntervalSince1970: diff)
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)

            // Updates the time string with the formatted time
            self.minutes = Float(minutes)
            self.time = String(format:"%d:%02d", minutes, seconds)
        }
        
        
    }
