import SwiftUI
import SwiftData

struct TimerView: View {
    let exampleHabit = Habit(
        name: "Morning Yoga",
        decription: "15-minute daily yoga session to improve flexibility and focus.",
        time: Date(),
        regularity: [true, true, true, true, true, false, false], // Mon-Fri active
        notification: true,
        duration: Calendar.current.date(from: DateComponents(year: 1970, month: 1, day: 1, hour: 1, minute: 1, second: 0))!
    )
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image("clock")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, 20)
                
                NavigationLink(destination: StartTimerView(habit: exampleHabit)) {
                    Text("Start Now")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: StartTimerView(habit: exampleHabit)) { // Another NavigationLink for the second button
                    Text("Dismiss")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Timer")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    TimerView()
}