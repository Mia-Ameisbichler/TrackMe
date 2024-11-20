import SwiftUI

struct DismissTimerView: View {
    @State private var selectedOption: String? = nil
    
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

                    Button(action: { handleOption("Dismissed for Today") }) {
                        Text("Today")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(1))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: { handleOption("Remind Me Later") }) {
                        Text("Remind Me Later")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange.opacity(1))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
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
            .edgesIgnoringSafeArea(.all)
            .allowsHitTesting(false)

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
    
    private func handleOption(_ option: String) {
        selectedOption = option
    }
}

struct DismissTimerView_Previews: PreviewProvider {
    static var previews: some View {
        DismissTimerView()
    }
}
