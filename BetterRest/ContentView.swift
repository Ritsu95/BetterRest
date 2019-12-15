//
//  ContentView.swift
//  BetterRest
//
//  Created by Ritsu on 14/12/2019.
//  Copyright © 2019 Ritsu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 32
    @State private var coffeeAmount = 1
    @State private var shouldSleepAt = ""
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var calculateBedtime: String {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: desiredSleepAmount[sleepAmount], coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
        } catch {
            return "Vaya, parece que algo no ha salido bien."
        }
    }
    
    let desiredSleepAmount = [0.0, 0.25, 0.50, 0.75, 1.0, 1.25, 1.50, 1.75, 2.0, 2.25, 2.50, 2.75, 3.0, 3.25, 3.50, 3.75, 4.0, 4.25, 4.50, 4.75, 5.0, 5.25, 5.50, 5.75, 6.0, 6.25, 6.50, 6.75, 7.0, 7.25, 7.50, 7.75, 8.0, 8.25, 8.50, 8.75, 9.0, 9.25, 9.50, 9.75, 10.0, 10.25, 10.50, 10.75, 11.0, 11.25, 11.50, 11.75, 12.0]
    
    var body: some View {
        
        NavigationView {
            
            Form {
                Section(header: Text("¿Cuándo te quieres despertar?")) {
                    DatePicker("Elige la hora", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section(header: Text("¿Cuánto quieres dormir?")) {
                    Picker("", selection: $sleepAmount) {
                        ForEach(0 ..< desiredSleepAmount.count) {
                            Text("\(self.desiredSleepAmount[$0], specifier: "%g") horas")
                        }
                    }
                }
                
                Section(header: Text("¿Cuánto café tomas?")) {
                    Stepper(value: $coffeeAmount, in: 0...20) {
                        if coffeeAmount == 1 {
                            Text("1 café")
                        } else {
                            Text("\(coffeeAmount) cafés")
                        }
                    }
                }
                
                Section(header: Text("Deberías irte a dormir a las..")) {
                    Text("\(calculateBedtime)")
                }
            }
            .navigationBarTitle("BetterRest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
