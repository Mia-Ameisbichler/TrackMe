import SwiftUI
import SwiftData

struct TimerView: View {
    @State var habit: Habit
    var notification: Notification {
        Notification(habit: habit)
    }
    
    var body: some View {
        NavigationStack() {
            VStack(spacing: 20) {
                Image("clock")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, 20)
                
                NavigationLink(destination: StartTimerView(habit: habit)) {
                    Text("Start Now")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: DismissTimerView(habit: habit)){
                    EmptyView()
                    Text("Dismiss")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .openHabitDetail)) { notification in
                if let habit = notification.object as? Habit {
                    self.habit = habit
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true) // Hides the back button.
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
        streak: 16
    )
    
    TimerView(habit: exampleHabit)
}
