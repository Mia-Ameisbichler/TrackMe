import SwiftUI

struct StartTimerView: View {
    @State private var remainingTime: TimeInterval
    @State private var isTimerRunning = false
    @State private var isTimerFinished = false
    @State private var timerEndDate: Date?
    @State private var isFinishEnabled = false

    let habit: Habit

    init(habit: Habit) {
        self.habit = habit
        self._remainingTime = State(initialValue: habit.duration.timeIntervalSince1970)
    }

    var body: some View {
        VStack(spacing: 40) {
            // Circular Progress Indicator with Countdown
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text(formatTime(remainingTime))
                    .font(.largeTitle)
                    .bold()
            }
            .frame(width: 200, height: 200)

            // Ready Button
            Button(action: startTimer) {
                Text("Ready")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isTimerRunning || isTimerFinished ? Color.gray.opacity(0.2) : Color.green)
                    .foregroundColor(isTimerRunning || isTimerFinished ? .gray : .white)
                    .cornerRadius(10)
            }
            .disabled(isTimerRunning || isTimerFinished)

            // Finish Button
            Button(action: finishTimer) {
                Text("Finish")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isFinishEnabled ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(isFinishEnabled ? .white : .gray)
                    .cornerRadius(10)
            }
            .disabled(!isFinishEnabled)
        }
        .padding()
        .onAppear {
            // Update remaining time if the timer is already running
            if let endDate = timerEndDate, isTimerRunning {
                remainingTime = max(0, endDate.timeIntervalSinceNow)
                if remainingTime == 0 {
                    isTimerRunning = false
                    isFinishEnabled = true
                }
            }
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            updateTimer()
        }
        .navigationTitle(habit.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var progress: CGFloat {
        guard habit.duration.timeIntervalSince1970 > 0 else { return 1 }
        return CGFloat(habit.duration.timeIntervalSince1970 - remainingTime) / CGFloat(habit.duration.timeIntervalSince1970)
    }

    private func startTimer() {
        guard !isTimerRunning && !isTimerFinished else { return }
        isTimerRunning = true
        isTimerFinished = false
        timerEndDate = Date().addingTimeInterval(remainingTime)
    }


    private func updateTimer() {
        guard isTimerRunning, let endDate = timerEndDate else { return }
        remainingTime = max(0, round(endDate.timeIntervalSinceNow))
        if remainingTime == 0 {
            isTimerFinished = true
            isTimerRunning = false
            isFinishEnabled = true
        }
    }

    private func finishTimer() {
        guard isFinishEnabled else { return }
        print("Timer finished for habit: \(habit.name)")
        // @TODO Go to DetailView
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    let exampleHabit = Habit(
        name: "Morning Yoga",decription: "15-minute daily yoga session to improve flexibility and focus.",
        time: Date(),
        regularity: [true, true, true, true, true, false, false],
        notification: true,
        duration: Calendar.current.date(from: DateComponents(year: 1970, month: 1, day: 1, hour: 1, minute: 0, second: 10))!
    )
    StartTimerView(habit: exampleHabit)
}
