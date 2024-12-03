//
//  HabitListView.swift
//  TrackMe
//
//  Created by Jasmin Rechberger on 20.11.24.
//

import SwiftUI
import _SwiftData_SwiftUI

struct HabitListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query var habits: [Habit]
    
    @State private var showNewHabit = false
    @State private var searchText = ""
    @State private var searchResult: [Habit] = []
    @State private var isSearchActive = false
    
    @State private var isLoading = false
    
    //Notification relevant variables
    @State private var selectedHabit: Habit?
    @State private var showTimerView = false
    
    var body: some View {
        NavigationStack {
            List {
                if habits.count <= 0 {
                    VStack {
                        NavigationLink(destination: HabitView()) {
                            Image(uiImage: UIImage(resource: .running))
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .padding()
                            
                        }
                        Text("No habits yet. Add a new habit to get started!")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding()
                    }
                } else {
                    let listItems = isSearchActive ? searchResult : habits
                                        
                    ForEach(listItems, id: \.self) { habit in
                        NavigationLink(destination: DetailView(habit: habit)) {
                            HabitRowView(habit: habit)
                        }
                    }
                    .onDelete(perform: deleteHabit)
                }
            }
            .navigationTitle("My Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewHabit = true
                    } label: {
                        Label("Add Habit", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        sendTestNotification()
                    } label: {
                        Label("Test Notification", systemImage: "bell")
                    }
                }
            }
            NavigationLink(
                destination: TimerView(habit: selectedHabit ?? Habit.default),
                isActive: $showTimerView
            ) {
                EmptyView() // Placeholder view; this is required for NavigationLink
            }
        }
        .navigationBarBackButtonHidden(true) // Hides the back button.
        .tint(.primary)
        .onReceive(NotificationCenter.default.publisher(for: .openHabitDetail)) { notification in
            if let habit = notification.object as? Habit {
                print("Received openHabitDetail for habit: \(habit.name)")
                selectedHabit = habit
                showTimerView = true
            } else {
                print("Failed to cast notification object to Habit.")
            }
        }

        .sheet(isPresented: $showNewHabit, content: {
            HabitView()
        })
        .searchable(text: $searchText, isPresented: $isSearchActive,
                    placement: .navigationBarDrawer(displayMode: .automatic),
                    prompt: "Search habit")
        .searchSuggestions{
            if searchText.isEmpty {
                
            }
        }
        .onChange(of: searchText) { oldValue, newValue in
            let predicate = #Predicate<Habit> { $0.name.localizedStandardContains(newValue)}
            // Exercise
            /**
             let predicate = #Predicate<Food> { $0.name.localizedStandardContains(newValue) || $0.cuisine.localizedStandardContains(newValue) || $0.type.localizedStandardContains(newValue) || $0.address.localizedStandardContains(newValue) }
             */
            
            let descriptor = FetchDescriptor<Habit>(predicate: predicate)
            
            if let result = try? modelContext.fetch(descriptor) { searchResult = result
            }
        }
        .onAppear {
            if(habits.isEmpty) {
                print("On Appear: No habits found. Loading habits...")
                self.loadHabitsArray()
            }
        }
    }
    
    private func sendTestNotification() {
        let testHabit = Habit.default // Use the default habit or create a dummy one.
        
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a test notification for the habit: \(testHabit.name)"
        content.sound = .default

        // Serialize Habit into JSON
        let encoder = JSONEncoder()
        if let habitData = try? encoder.encode(testHabit) {
            content.userInfo = ["habit": habitData]
        }
        
        // Schedule the notification for one minute from now
        let triggerDate = Date().addingTimeInterval(10) // 60 seconds
        let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: "testNotification", content: content, trigger: trigger)

        // Add the notification request
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling test notification: \(error.localizedDescription)")
            } else {
                print("Test notification scheduled for 10 seconds from now.")
            }
        }
    }

    
    
    private func deleteHabit(indexSet: IndexSet) {
        
        guard indexSet.allSatisfy({ $0 < habits.count }) else {
            print("Error: Attempted to delete an out-of-bounds index.")
            return
        }
        
        for index in indexSet {
            let itemToDelete = habits[index]
            modelContext.delete(itemToDelete)
        }
        
    }
    
    private func loadHabitsArray() {
        isLoading = true
        
        loadHabits { result in
            
            switch result {
            case .success(let habitsArray):
                for habit in habitsArray {
                    save(habit: habit)
                }
                isLoading = false
                print("Loaded Habits")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
            
        }
    }
    
    private func deleteAllRecords() {
        for item in habits {
            modelContext.delete(item)
        }
    }
    
    private func save(habit: HabitJson) {
        guard let time = isoStringToDate(habit.time) else {
            print("Error: Invalid time format")
            return
        }
        
        guard let duration = hhmmStringToDate(habit.duration) else {
            print("Error: Invalid duration format")
            return
        }

        let habit = Habit(name: habit.name,
                          info: habit.info,
                          time: time,
                          regularity: habit.regularity,
                          notification: habit.notification,
                          image: UIImage(named: habit.image) ?? UIImage(),
                          duration: duration,
                          streak: habit.streak)
        
        modelContext.insert(habit)
        print("Saved Habit: \(habit.name)")
    }

}

struct HabitRowView: View {
    let habit: Habit
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(uiImage: habit.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 70)
                .clipShape(Rectangle())
                .padding(.trailing, 5)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(habit.name)
                    .font(.headline)
                    .bold()
                
                Text(habit.info)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack {
                    Text("Time: \(habit.formattedTime)")
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text("Duration: \(habit.formattedDuration)")
                        .font(.caption)
                }
                
                HStack {
                    Text("Repeats on: \(formattedWeekdays(for: habit.regularity))")
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 5)
    }
    
    func formattedWeekdays(for regularity: [Bool]) -> String {
        let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        return regularity.enumerated()
            .compactMap { $1 ? weekdays[$0] : nil }
            .joined(separator: ", ")
    }
}
  

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, configurations: config)
    
        for i in 0..<7 {
            let user = Habit(name: "running", info: "go for a run", time: Date(), regularity: [false, true], notification: true, image: UIImage(resource: .running), duration: Calendar.current.date(from: DateComponents(year: 1970, month: 1, day: 1, hour: 1, minute: 1, second: 0))!, streak: 5)
        container.mainContext.insert(user)
    }
    
    return HabitListView()
        .modelContainer(container)
}
