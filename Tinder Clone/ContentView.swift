//
//  ContentView.swift
//  Tinder Clone
//
//  Created by Anthony José on 10/11/21.
//

import SwiftUI

struct User: Hashable, CustomStringConvertible {
    let id: Int
    
    let firstName: String
    let lastName: String
    let age: Int
    let imageName: String
    let occupation: String
    
    var description: String {
        return "\(firstName), id: \(id)"
    }
    
}
struct ContentView: View {
    
    /// List of users
    @State var users: [User] = [
        User(id: 0, firstName: "Cindy", lastName: "Jones", age: 23, imageName: "person_1", occupation: "Coach"),
        User(id: 1, firstName: "Mark", lastName: "Bennett", age: 27, imageName: "person_2", occupation: "Insurance Agent"),
        User(id: 2, firstName: "Clayton", lastName: "Delaney", age: 20, imageName: "person_3", occupation: "Food Scientist"),
        User(id: 3, firstName: "Brittni", lastName: "Watson", age: 19, imageName: "person_4", occupation: "Historian"),
        User(id: 4, firstName: "Archie", lastName: "Prater", age: 22, imageName: "person_5", occupation: "Substance Abu"),
        User(id: 5, firstName: "James", lastName: "Braun", age: 24, imageName: "person_6", occupation: "Marke"),
        User(id: 6, firstName: "Danny", lastName: "Savage", age: 25, imageName: "person_7", occupation: "Dentist"),
        User(id: 7, firstName: "Chi", lastName: "Pollack", age: 29, imageName: "person_8", occupation: "Recreation"),
        User(id: 8, firstName: "Josue", lastName: "Strange", age: 23, imageName: "person_9", occupation: "HR Specialist"),
        User(id: 9, firstName: "Debra", lastName: "Weber", age: 28, imageName: "person_10", occupation: "Judge")
    ]
    
    /// Return the cardVIews with for the given offset in the array
    /// - Parameters:
    /// - geometry: the geometry proxy of the parent
    /// - id: The ID  of the current user
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        let offset: CGFloat = CGFloat(users.count - 1 - id) * 10
        return geometry.size.width - offset
    }
    
    /// Return the cardViews frame offset for the given offset in the array
    /// - Parameters:
    /// - geometry: the geometry proxy of the parent,
    /// - id: The ID  of the current User
    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return CGFloat(users.count - 1 - id) * 10
    }
    
    // Compute what the max ID in the given users array in.
    private var maxID: Int {
        return users.map { $0.id }.max() ?? 0
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    DateView()
                    
                    ZStack {
                        ForEach(self.users, id: \.self) { user in
                            if (maxID - 3) ... self.maxID ~= user.id {
                                CardView()
                                    .frame(width: getCardWidth(geometry, id: user.id), height: 400)
                                    .offset(x: 0, y: getCardOffset(geometry, id: user.id))
                            }
                        }
                    }
                    Spacer()
                }
            }
            
        }.padding()
    }
}

struct DateView: View {
    var body: some View {
        // Container to add background and corner radius
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Friday, 10th January")
                        .font(.title)
                        .bold()
                    Text("Today")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }.padding()
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 2.5)
    }
}

struct CardView: View {
    
    @State private var translation: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Image("person_1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.75)
                    .clipped()
                
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Debra Weber, 28")
                            .font(.title)
                            .bold()
                        Text("Judge")
                            .font(.subheadline)
                            .bold()
                        Text("13 Mutual Friends")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    
                    Image(systemName: "info.circle")
                        .foregroundColor(.gray)
                }.padding(.horizontal)
            }
            // Add padding, corner radius and shadow with blur radius
            // existing view modifier
            .padding(.bottom)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 5)
            .offset(x: translation.width, y: translation.height)
            .rotationEffect(.degrees(Double(translation.width / geometry.size.width) * 25), anchor: .center)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation(.interactiveSpring()) {
                            translation = value.translation
                        }
                    }
                    .onEnded { value in
                        withAnimation(.interactiveSpring()) {
                            translation = .zero
                        }
                    }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

