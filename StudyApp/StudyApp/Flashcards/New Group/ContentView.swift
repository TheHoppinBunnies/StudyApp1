//
//  ContentView.swift
//  Pomodoro
//
//  Created by Othmane EL MARIKY on 2025-01-10.
//

import SwiftUI
import UserNotifications
import AVFoundation
import Foundation


struct PomodoroTimerView: View {
    @State private var timeRemaining: Int = 1 * 10 // Default to 25 minutes
    @State private var isRunning: Bool = false
    @State private var isWorkSession: Bool = true // Track whether it's a work or break session
    @State private var timer: Timer? = nil
    @State var audioPlayer: AVAudioPlayer!
    
    private var workTime: Int = 1 * 10
    private var breakTime: Int = 5 * 1
    
    private var totalTime: Int {
        return isWorkSession ? workTime : breakTime
    }
    
    private var progress: Double {
        return 1.0 - Double(timeRemaining) / Double(totalTime)
    }
    
    private var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
        
    var body: some View {
        ZStack {
            
            LinearGradient(colors: [.cyan, .green], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            
            VStack(spacing: 100) {
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .frame(width: 300, height: 90)
                        .foregroundColor(.white)
                        .opacity(0.8)
                    Text(isWorkSession ? "Study Session" : "Break Session")
                        .shadow(color:.gray, radius:1.5)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 400)
                        .frame(width: 300, height: 300)
                        .foregroundColor(.white)
                        .opacity(0.8)
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 25)
                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(isWorkSession ? Color(red: 0.250, green: 0.350, blue: 1.0): Color.orange, style: StrokeStyle(lineWidth: 25, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut, value: progress)
                    
                    Text(formattedTime)
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .shadow(color:.gray, radius:2)
                }
                .frame(width: 200, height: 200)
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 350, height: 80)
                        .foregroundColor(.white)
                        .opacity(0.4)
                    HStack(spacing: 10) {
                        Button(action: startTimer) {
                            Text(isRunning ? "Pause" : "Start")
                                .shadow(color:.black, radius:3)
                                .font(.title2)
                                .padding()
                                .frame(width: 150)
                                .background(isRunning ? Color.yellow : Color(red: 0.3, green: 0.8, blue: 0.2))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                    
                        Button(action: resetTimer) {
                            Text("Reset")
                                .shadow(color:.black, radius:3)
                                .font(.title2)
                                .padding()
                                .frame(width: 150)
                                .background(Color(red: 0.75, green: 0.1, blue: 0.0))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                    }
                }
            }
            .padding()
            .onAppear(perform: requestNotificationPermissions)
            .onDisappear { stopTimer() }
        }
    }
    
        func playSounds(_ soundFileName : String) {
            guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "mp3")    else { fatalError("Unable to find \(soundFileName) in bundle")}

                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                } catch {
                    print(error.localizedDescription)
                }
                audioPlayer.play()
            }
    
        func startTimer() {
            if isRunning {
                stopTimer()
            } else {
                isRunning = true
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        sendNotification()
                        playSounds("hi")
                        switchSession()
                    }
                }
            }
        }
        
        private func stopTimer() {
            isRunning = false
            timer?.invalidate()
            timer = nil
        }
        
        private func resetTimer() {
            stopTimer()
            timeRemaining = totalTime
        }
        
        private func switchSession() {
            stopTimer()
            isWorkSession.toggle()
            timeRemaining = totalTime
            startTimer() // Automatically start the next session
        }
        
        private func requestNotificationPermissions() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if let error = error {
                    print("Notification permission error: \(error.localizedDescription)")
                }
            }
        }
        
        private func sendNotification() {
            let content = UNMutableNotificationContent()
            content.title = isWorkSession ? "Work Session Complete" : "Break Session Complete"
            content.body = isWorkSession ? "Time to take a break!" : "Time to get back to work!"
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Notification error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    struct PomodoroTimerView_Previews: PreviewProvider {
        static var previews: some View {
            PomodoroTimerView()
        }
    }
