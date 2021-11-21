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
                            
                            /// Using the pattern-match operator ~=, we can determine if our
                            /// user.id falls within the range of 6...9
                            if (maxID - 3) ... self.maxID ~= user.id {
                                CardView(user: user, onRemove: { removedUser in
                                    // Remove that user from our array
                                    withAnimation(.interactiveSpring()) {
                                        users.removeAll { $0.id == removedUser.id }
                                    }
                                })
                                .frame(width: getCardWidth(geometry, id: user.id), height: 500)
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
    
    //1
    private var user: User
    private var onRemove: (_ user: User) -> Void
    
    //2
    private var thresholdPercentage: CGFloat = 0.5  // when the user has draged 50% the width of the screen in either direction
    
    //3
    init(user: User, onRemove: @escaping (_ user: User) -> Void) {
        self.user = user
        self.onRemove = onRemove
    }
    
    //4
    /// What percentage of our own witdth have we swipped
    /// - Parameters:
    /// - geometry: The geometry
    /// - gesture: The current gesture translation value 
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                
                //5
                ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
                    Image(user.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height * 1.10)
                        .ignoresSafeArea()
            
        
                    HStack {
                        //6
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(user.firstName) \(user.lastName), \(user.age)")
                                .font(.title)
                                .bold()
                            Text(user.occupation)
                                .font(.subheadline)
                                .bold()
                            Text("13 Mutual Friends")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        Image(systemName: "info.circle")
                            .foregroundColor(.secondary)
                    }.padding(.horizontal)
                        .padding(.vertical)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                }
            }
            // Add padding, corner radius and shadow with blur radius
            // existing view modifier
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
                        
                            if abs(getGesturePercentage(geometry, from: value)) > thresholdPercentage {
                                withAnimation(.interactiveSpring()) {
                                    onRemove(user)
                                }
                            } else {
                                withAnimation(.interactiveSpring()) {
                                    translation = .zero
                                }
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

