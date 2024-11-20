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
    @State private var description: String = ""
    @State private var regularity: [Bool] = [false, false, false, false, false, false, false]
    @State private var notification: Bool = false
    @State private var duration: TimeInterval = 0
    
    //@State private var image = UIImage(resource: .addPhoto)
    //let notficationService: Notification
    
    @State private var showPhotoOptions = false
    
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
                    TextField("Enter a description", text: $description)
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
                        .datePickerStyle(WheelDatePickerStyle()) // Scrollable style
                    }
                    Section(header: Text("Regularity")) {
                        
                    }
                }
                
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveHabit()
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
            name: habitViewModel.name,
            decription: habitViewModel.decription,
            time: habitViewModel.time,
            regularity: habitViewModel.regularity,
            notification: habitViewModel.notification,
            image: habitViewModel.image,
            duration: habitViewModel.duration)
        print("Saved Habit: \(newHabit)")
        modelContext.insert(newHabit)
    }
}

struct HabitViewPreView: PreviewProvider {
    static var previews: some View {
        HabitView()
    }
}
