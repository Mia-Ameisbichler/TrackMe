//
//  Insert.swift
//  TrackMe
//
//  Created by Jasmin Rechberger on 20.11.24.
//
import SwiftUI
import SwiftData

struct HabitView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable private var habitViewModel: HabitViewModel
    @State private var name: String = ""
    @State private var time: Date = Date()
    @State private var info: String = ""
    @State private var regularity: [Bool] = [false, false, false, false, false, false, false]
    @State private var notification: Bool = false
    @State private var duration: Date = Date()
    @State private var showPhotoOptions = false
    
    let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    //@State private var image = UIImage(resource: .addPhoto)
    //let notficationService: Notification
    
    
    enum PhotoSource: Identifiable {
        case photoLibrary
        case camera
        
        var id: Int {
            hashValue
        }
    }
    @State private var photoSource: PhotoSource?
    
    init() {
        let viewModel = HabitViewModel()
        viewModel.image = UIImage(resource: .addPhoto)
        habitViewModel = viewModel
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("Habit Name")) {
                    TextField("Enter habit name", text: $name)
                }
                
                Section(header: Text("Description")) {
                    TextField("Enter a description", text: $info)
                }
                
                Section(header: Text("Add an image")) {
                    Image(uiImage: habitViewModel.image)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 200)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                        .padding(.bottom)
                        .onTapGesture {
                            self.showPhotoOptions.toggle()
                        }
                }
                
                Section(header: Text("Duration")) {
                    DatePicker(
                        "Select time",
                        selection: $time,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("Notification")) {
                    Toggle(isOn: $notification) {
                        Text("Allow Notifications")
                    }
                }
                if(notification == false){
                    //Text("No Notifications available")
                } else {
                    Section(header: Text("Reminder Time")) {
                        DatePicker(
                            "Select time",
                            selection: $time,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(WheelDatePickerStyle())
                    }
                    
                    Section(header: Text("Regularity")) {
                        VStack {
                            ForEach(weekdays.indices, id: \.self) { index in
                                Button(action: {
                                    habitViewModel.regularity[index].toggle()
                                }) {
                                    Text(weekdays[index])
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(habitViewModel.regularity[index] ? Color.blue : Color.clear)
                                        .foregroundColor(habitViewModel.regularity[index] ? .white : .primary)
                                        .cornerRadius(8)
                                        .bold(habitViewModel.regularity[index])
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }
                }
                
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveHabit()
                        dismiss()
                    }
                }
            }
        }
        .confirmationDialog("Choose your photo source", isPresented: $showPhotoOptions, titleVisibility: .visible) {
            Button("Camera") {
                self.photoSource = .camera
            }
            
            Button("Photo Library") {
                self.photoSource = .photoLibrary
            }
        }
        .fullScreenCover(item: $photoSource) { source in
            switch source {
            case .photoLibrary:
                ImagePicker(sourceType: .photoLibrary, selectedImage: $habitViewModel.image)
                    .ignoresSafeArea()
            case .camera:
                ImagePicker(sourceType: .camera, selectedImage: $habitViewModel.image)
                    .ignoresSafeArea()
            }
        }
        .tint(.primary)
    }
    
    func saveHabit() {
        let newHabit = Habit(
            name: name,
            info: info,
            time: time,
            regularity: regularity,
            notification: notification,
            image: habitViewModel.image,
            duration: duration,
            streak: 0)
        print("Saved Habit: \(newHabit)")
        
        modelContext.insert(newHabit)
    }
}

struct HabitViewPreView: PreviewProvider {
    static var previews: some View {
        HabitView()
    }
}
