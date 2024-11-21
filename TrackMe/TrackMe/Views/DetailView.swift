//
//  DetailView.swift
//  TrackMe
//
//  Created by Jasmin Rechberger on 20.11.24.
//
import SwiftUI
import UIKit

struct DetailView: View {
    var habit: Habit
    let columns = Array(repeating: GridItem(.flexible()), count: 5)
    
    var body: some View {
        VStack (alignment: .leading){
            Image(uiImage: habit.image)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
            Spacer()
                
            
            Text(habit.name)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text(habit.info)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .center)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(0..<habit.streak, id: \.self) { number in
                    Text("\(number + 1)")
                        .frame(width: 50, height: 50)
                        .background(Color.green.opacity(0.4))
                        .cornerRadius(5)
                        .padding(.top, 50)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    
    let user = Habit(name: "running", info: "go for a run", time: Date(), regularity: [false, true], notification: true, image: UIImage(resource: .running), duration: Calendar.current.date(from: DateComponents(year: 1970, month: 1, day: 1, hour: 1, minute: 1, second: 0))!, streak:2)
    
    DetailView(habit: user)
}
    
