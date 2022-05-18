//
//  ContentView.swift
//  GymApp
//
//  Created by Jamile Castro on 18/05/22.
//

import SwiftUI

struct DaysList: View {
    var model = Database.shared

    var body: some View {
        NavigationView {
            List(model.days, id: \.self) { day in
                NavigationLink(day.name) {
                    RoutinesList(day: day)
                }
            }
            .navigationTitle("Gym Visualizer")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RoutinesList: View {
    @StateObject var day: Day
    @State var isPresenting = false
    @State var update = false

    var body: some View {
        List {
            ForEach(day.routines, id: \.self) { routine in
                Section(routine.name) {
                    ForEach(routine.exercises, id: \.self) { exercise in
                        HStack(spacing: 20) {
                            Text(exercise.name.capitalized)
                            Spacer()
                            Text("\(exercise.repetitions)")
                            Text("\(exercise.series)")
                                .padding([.trailing], 10)
                        }
                        .background(exercise.done ? Color.green : Color.white)
                        .onTapGesture {
                            exercise.done.toggle()
                            update.toggle()
                        }
                        
                    }
                    .onDelete {
                        routine.exercises.remove(atOffsets: $0)
                        update.toggle()
                    }
                    .onMove(perform: { indices, newOffset in
                        Database.shared.reorganize(routine: routine, offSet: indices, destination: newOffset)
                        update.toggle()
                    })
                }
            }
        }
        .sheet(isPresented: $isPresenting, onDismiss: {
            update.toggle()
        }, content: {
            NewExercise(day: day)
        })
        .listStyle(SidebarListStyle())
        .navigationTitle(day.name)
        .toolbar {
            HStack {
                EditButton()
                Menu("Add"){
                    Button("Add Routine", action: {addRoutine()})
                    Button("Add Exercise", action: {showSheet()})
                }
            }
        }
        .background(Color.clear.disabled(update))
    }

    func showSheet() {
        isPresenting.toggle()
    }

    func addRoutine() {
        let count = day.routines.count
        day.routines.append(Routine(name: "Treino \(count + 1)"))
    }
}

struct NewExercise: View {
    var day: Day

    @State private var routine: Routine = Routine(name: "New")
    @State private var exerciseName = ""
    @State private var repNumber = 0
    @State private var serieNumber = 0

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                TextField("Exercisise", text: $exerciseName)
                Picker("Routine", selection: $routine) {
                    ForEach(day.routines, id: \.self) {
                        Text($0.name)
                    }
                }
                Section("Number of Series") {
                    Stepper("\(serieNumber)", value: $serieNumber)
                }
                Section("Number of Repetitions") {
                    Stepper("\(repNumber)", value: $repNumber)
                }
                Button("Save") {
                    let exercise = Exercise(name: exerciseName, repetitions: repNumber, series: serieNumber)
                    Database.shared.addExercise(routine: routine, exercise: exercise)
                    dismiss()
                }
            }
            .navigationTitle("New Exercise")
        }
    }
}

struct DaysList_Previews: PreviewProvider {
    static var previews: some View {
        DaysList()
    }
}
