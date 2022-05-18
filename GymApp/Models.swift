//
//  Models.swift
//  GymApp
//
//  Created by Jamile Castro on 18/05/22.
//

import Combine
import Foundation

class Database {
    static var shared = Database()

    private init() {
        mockData()
    }

    var days = [
        Day(name: "Segunda"),
        Day(name: "Terça"),
        Day(name: "Quarta"),
        Day(name: "Quinta"),
        Day(name: "Sexta"),
        Day(name: "Sábado"),
        Day(name: "Domingo"),
    ]

    func addRoutine(day: String, routine: Routine) {
        guard let day = days.first(where: { $0.name == day}) else { return }
        day.routines.append(routine)
    }

    func addExercise(routine: Routine, exercise: Exercise) {
        routine.exercises.append(exercise)
    }

    func reorganize(routine: Routine, offSet: IndexSet, destination: Int) {
        routine.exercises.move(fromOffsets: offSet, toOffset: destination)
    }

    func mockData() {
        days.forEach {
            let routine = Routine(name: "Treino 1")
            routine.exercises = [
                Exercise(name: "Leg 45", repetitions: 12, series: 3),
                Exercise(name: "Supino", repetitions: 12, series: 3),
                Exercise(name: "Squat", repetitions: 12, series: 3),
                Exercise(name: "Cross", repetitions: 12, series: 3),
                Exercise(name: "Passada", repetitions: 12, series: 3),
            ]
            $0.routines.append(routine)
        }

        days.forEach {
            let routine = Routine(name: "Treino 2")
            routine.exercises = [
                Exercise(name: "Leg 45", repetitions: 12, series: 3),
                Exercise(name: "Supino", repetitions: 12, series: 3),
                Exercise(name: "Squat", repetitions: 12, series: 3),
                Exercise(name: "Cross", repetitions: 12, series: 3),
                Exercise(name: "Passada", repetitions: 12, series: 3),
            ]
            $0.routines.append(routine)
        }
    }
}

class Day: Hashable, ObservableObject {
    var id = UUID()
    var name: String
    @Published var routines: [Routine] = []

    init(name: String) {
        self.name = name
    }


    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Day, rhs: Day) -> Bool {
        lhs.id == rhs.id
    }
}

class Routine: Identifiable, Hashable, ObservableObject {
    var id = UUID()
    var name: String
    @Published var exercises: [Exercise] = []

    init(name: String) {
        self.name = name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Routine, rhs: Routine) -> Bool {
        lhs.id == rhs.id
    }
}

class Exercise: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var repetitions: Int
    var series: Int
    var done = false
    
    init(name: String, repetitions: Int, series: Int) {
        self.name = name
        self.repetitions = repetitions
        self.series = series
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.id == rhs.id
    }
}
