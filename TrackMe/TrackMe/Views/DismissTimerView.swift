import SwiftUI

struct DismissTimerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedOption: String? = nil
    var habit: Habit
    var notification: Notification {
        Notification(habit: habit)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ForEach(0..<69, id: \.self) { _ in
                    Text(randomSadSmiley())
                        .font(.system(size: CGFloat.random(in: 20...50)))
                        .foregroundColor(Color.gray.opacity(0.5))
                        .position(
                            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                        )
                }

                VStack(spacing: 20) {

                Text("Are you sure you want to dismiss the timer?")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    
                    NavigationLink(destination: HabitListView()){
                        EmptyView()
                        Text("Today")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(1))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                        
                    Button{
                        notification.scheduleReminderNotification()
                    } label: {
                        NavigationLink(destination: HabitListView()){
                            EmptyView()
                            Text("Remind Me Later")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange.opacity(1))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(1))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .edgesIgnoringSafeArea(.all)
        }
        .padding()
        .onChange(of: selectedOption) { newValue in
            if let newValue = newValue {
                print("User selected: \(newValue)")
            }
        }
    }

    private func randomSadSmiley() -> String {
        let smileys = [
            "☹️", "😢", "😭", "😞", "😟", "😔", "😥", "🥺", // Common sad smileys
            "😩", "😫", "😿", "🙁", "😕", "💔", "🫤",       // Additional expressions
            "😣", "😓", "😖", "😨", "😰", "😧", "😬", "😢", // Overwhelmed sadness
            "😵‍💫", "🫠", "🤕", "🤒", "😢", "🥴",           // Unique states
            "🌧️", "⛈️", "💧", "🪦",                       // Sad weather/symbolic
        ]
        return smileys.randomElement()!
    }
}

#Preview {
    let exampleHabit = Habit(
        name: "Morning Yoga",
        info: "15-minute daily yoga session to improve flexibility and focus.",
        time: Date(),
        regularity: [true, true, true, true, true, false, false], // Mon-Fri active
        notification: true,
        duration: Calendar.current.date(from: DateComponents(year: 1970, month: 1, day: 1, hour: 1, minute: 1, second: 0))!,
        streak: 5
    )
    
    DismissTimerView(habit: exampleHabit)
}
