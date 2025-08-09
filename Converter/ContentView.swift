import SwiftUI

struct ContentView: View {
    @State var selectedConversion: Int = 0
    @State var selectedInputvariable: Int = 0
    @State var selectedOutputVariable: Int = 0
    @State var initVariable = 0.0
    
    let conversion = ["Temperature", "Length", "Time", "Volume"]
    
    let units: [String: [String]] = [
        "Temperature": ["Celsius", "Fahrenheit", "Kelvin"],
        "Length": ["Km", "Meters", "Miles"],
        "Time": ["Seconds", "Minutes", "Hours"],
        "Volume": ["Liters", "Milliliters", "Gallons"]
    ]
    
    @FocusState var isFocused: Bool
    
    var currentUnits: [String] {
            units[conversion[selectedConversion]] ?? []
        }
    
    var valueInBase: Double {
        let inputUnitName = currentUnits[selectedInputvariable]
        var baseValue = initVariable

        switch conversion[selectedConversion] {
        case "Length":
            switch inputUnitName {
            case "Km": baseValue *= 1000
            case "Miles": baseValue *= 1609.34
            default: break
            }
        case "Time":
            switch inputUnitName {
            case "Minutes": baseValue *= 60
            case "Hours": baseValue *= 3600
            default: break
            }
        case "Volume":
            switch inputUnitName {
            case "Milliliters": baseValue /= 1000
            case "Gallons": baseValue *= 3.78541
            default: break
            }
        case "Temperature":
            switch inputUnitName {
            case "Fahrenheit": baseValue = (baseValue - 32) * 5/9
            case "Kelvin": baseValue -= 273.15
            default: break
            }
        default:
            break
        }

        return baseValue
    }

    var result: Double {
        let outputUnitName = currentUnits[selectedOutputVariable]
        var finalValue = valueInBase

        switch conversion[selectedConversion] {
        case "Length":
            switch outputUnitName {
            case "Km": return finalValue / 1000
            case "Miles": return finalValue / 1609.34
            default: return finalValue
            }
        case "Time":
            switch outputUnitName {
            case "Minutes": return finalValue / 60
            case "Hours": return finalValue / 3600
            default: return finalValue
            }
        case "Volume":
            switch outputUnitName {
            case "Milliliters": return finalValue * 1000
            case "Gallons": return finalValue / 3.78541
            default: return finalValue
            }
        case "Temperature":
            switch outputUnitName {
            case "Fahrenheit": return finalValue * 9/5 + 32
            case "Kelvin": return finalValue + 273.15
            default: return finalValue
            }
        default:
            return finalValue
        }
    }

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Conversion", selection: $selectedConversion) {
                    ForEach(0..<conversion.count, id: \.self) { index in
                        Text(conversion[index])
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                Form {
                    Section("Input Units") {
                        TextField("Init", value: $initVariable, format: .number)
                            .keyboardType(.decimalPad)
                            .focused($isFocused)
                        
                        Picker("Input Units", selection: $selectedInputvariable) {
                                ForEach(0..<currentUnits.count, id: \.self) {
                                    Text(currentUnits[$0])
                                }
                        }
                    }
                    Section("Output Units"){
                        Picker("Input Units", selection: $selectedOutputVariable) {
                                ForEach(0..<currentUnits.count, id: \.self) {
                                    Text(currentUnits[$0])
                                }
                        }
                        HStack{
                            Spacer()
                            VStack{
                                
                                Text(result.formatted()).font(.largeTitle.bold())
                                Text(currentUnits[selectedOutputVariable]).font(.caption)
                            }
                            Spacer()
                        }
                        
                    }
                }
            }
            .navigationTitle("Converter")
            .toolbar {
                if isFocused {
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
