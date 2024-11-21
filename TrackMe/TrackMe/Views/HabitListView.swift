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
    
    
    var body: some View {
        NavigationStack {
            List {
                if habits.isEmpty {
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
                        NavigationLink(destination: DetailView()) {
                            HabitRowView(habit: habit)
                        }
                    }
                    .onDelete(perform: deleteHabit) // Add swipe-to-delete functionality
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
            }
            .sheet(isPresented: $showNewHabit) {
                HabitView()
            }
        }
        .navigationBarBackButtonHidden(true) // Hides the back button.
    }
    
    func deleteHabit(at offsets: IndexSet) {
        for index in offsets {
            let habit = habits[index]
            modelContext.delete(habit)
        }
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
        let user = Habit(name: "running", decription: "go for a run", time: Date(), regularity: [false, true], notification: true, image: UIImage(resource: .running), duration: Calendar.current.date(from: DateComponents(year: 1970, month: 1, day: 1, hour: 1, minute: 1, second: 0))!)
        container.mainContext.insert(user)
    }
    
    return HabitListView()
        .modelContainer(container)
}
