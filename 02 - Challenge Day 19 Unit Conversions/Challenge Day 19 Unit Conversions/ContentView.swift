//
//  ContentView.swift
//  Challenge Day 19 Unit Conversions
//
//  Created by Luis Rivera Rivera on 12/7/21.
//

import SwiftUI
import Foundation

enum Converters: String, CaseIterable {
    case temperature = "Temperature"
    case length = "Length"
    case time = "Time"
    case volume = "Volume"
}

struct Temperature {
    static let units = ["Fahrenheit", "Celsius", "Kelvin"]
}

struct Length {
    static let units = ["Kilometers", "Feet", "Yards", "Miles"]
}

struct Time {
    static let units = ["Seconds", "Minutes", "Hours", "Days"]
}

struct Volume {
    static let units = ["Milliliters", "Liters", "Cups", "Pints", "Gallons"]
}


struct ContentView: View {
    @State private var converter: Converters = .temperature
    @State private var firstUnitSelection = Temperature.units[0]
    @State private var secondUnitSelection = Temperature.units[0]
    @State private var numberToBeConverted = 0.0
    @FocusState private var isNumberFocused: Bool
    
    var options: [String] {
        switch converter {
        case .temperature:
            return Temperature.units
        case .length:
            return Length.units
        case .time:
            return Time.units
        case .volume:
            return Volume.units
        }
    }
    
    var result: String {
        
        var input: Measurement<Dimension>
        var output: Measurement<Dimension>
       
        
        switch firstUnitSelection {
            
        case "Fahrenheit":
            input = Measurement(value: numberToBeConverted, unit: UnitTemperature.fahrenheit)
        case "Celsius":
            input = Measurement(value: numberToBeConverted, unit: UnitTemperature.celsius)
            
        case "Kelvin":
            input = Measurement(value: numberToBeConverted, unit: UnitTemperature.kelvin)
            
        case "Kilometers":
            input = Measurement(value: numberToBeConverted, unit: UnitLength.kilometers)
            
        case "Feet":
            input = Measurement(value: numberToBeConverted, unit: UnitLength.feet)
            
        case "Yards":
            input = Measurement(value: numberToBeConverted, unit: UnitLength.yards)
            
        case "Miles":
            input = Measurement(value: numberToBeConverted, unit: UnitLength.miles)
            
        case "Seconds":
            input = Measurement(value: numberToBeConverted, unit: UnitDuration.seconds)
            
        case "Minutes":
            input = Measurement(value: numberToBeConverted, unit: UnitDuration.minutes)
            
        case "Hours", "Days":
            input = Measurement(value: numberToBeConverted, unit: UnitDuration.hours)
            
        case "Milliliters":
            input = Measurement(value: numberToBeConverted, unit: UnitVolume.milliliters)
            
        case "Liters":
            input = Measurement(value: numberToBeConverted, unit: UnitVolume.liters)
            
        case "Cups":
            input = Measurement(value: numberToBeConverted, unit: UnitVolume.cups)
            
        case "Pints":
            input = Measurement(value: numberToBeConverted, unit: UnitVolume.pints)
            
        case "Gallons":
            input = Measurement(value: numberToBeConverted, unit: UnitVolume.gallons)
            
        default:
            print("Unexpected conversion")
            fatalError()
        }
                
        switch secondUnitSelection {
            
        case "Fahrenheit":
            output = input.converted(to: UnitTemperature.fahrenheit)
            return output.formatted()
        case "Celsius":
            output = input.converted(to: UnitTemperature.celsius)
            return output.formatted()

        case "Kelvin":
            output = input.converted(to: UnitTemperature.kelvin)
            return output.formatted()

        case "Kilometers":
            output = input.converted(to: UnitLength.kilometers)
            return output.formatted()

        case "Feet":
            output = input.converted(to: UnitLength.feet)
            return output.formatted()

        case "Yards":
            output = input.converted(to: UnitLength.yards)
            return output.formatted()

        case "Miles":
            output = input.converted(to: UnitLength.miles)
            return output.formatted()

        case "Seconds":
            output = input.converted(to: UnitDuration.seconds)
            return output.formatted()

        case "Minutes":
            output = input.converted(to: UnitDuration.minutes)
            return output.formatted()

        case "Hours":
            output = input.converted(to: UnitDuration.hours)
            return output.formatted()

        case "Days":
            output = input.converted(to: UnitDuration.hours)
            let modifiedValue = output.value / 24
            return "\(modifiedValue) days"

        case "Milliliters":
            output = input.converted(to: UnitVolume.milliliters)
            return output.formatted()

        case "Liters":
            output = input.converted(to: UnitVolume.liters)
            return output.formatted()

        case "Cups":
            output = input.converted(to: UnitVolume.cups)
            return output.formatted()

        case "Pints":
            output = input.converted(to: UnitVolume.pints)
            return output.formatted()

        case "Gallons":
            output = input.converted(to: UnitVolume.gallons)
            return output.formatted()

        default:
            print("Unexpected conversion")
            fatalError()
        }
        
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Mode:", selection: $converter) {
                        ForEach(Converters.allCases, id: \.self) { unit in
                            Text("\(unit.rawValue)")
                        }
                    }
                    .pickerStyle(.automatic)
                }
                
                Section {
                    Picker("From", selection: $firstUnitSelection) {
                        ForEach(options, id: \.self) {
                            Text($0)
                }
                    }
                    .pickerStyle(.segmented)
              
                    TextField("Enter the unit to be converted", value: $numberToBeConverted, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isNumberFocused)
                    
                    Picker("To", selection: $secondUnitSelection) {
                        ForEach(options, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Text(result)
                }
            }.navigationTitle("Unit Converter")
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            isNumberFocused = false
                        }
                    }
                }
                .onChange(of: converter) { _ in
                    resetSegmentedControls()
                }
        }
    }
    
    func resetSegmentedControls() {
        switch converter {
        case .temperature:
            firstUnitSelection = Temperature.units[0]
            secondUnitSelection = Temperature.units[0]
        case .length:
            firstUnitSelection = Length.units[0]
            secondUnitSelection = Length.units[0]
        case .time:
            firstUnitSelection = Time.units[0]
            secondUnitSelection = Time.units[0]
        case .volume:
            firstUnitSelection = Volume.units[0]
            secondUnitSelection = Volume.units[0]
        }
        numberToBeConverted = 0
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
