//
//  ContentView.swift
//  Cupcake Corner
//
//  Created by Luis Rivera Rivera on 3/15/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var client = Client()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $client.order.type) {
                        ForEach(OrderStruct.types.indices) {
                            Text(OrderStruct.types[$0])
                        }
                    }
                    Stepper("Number of cakes: \(client.order.quantity)", value: $client.order.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special request?", isOn: $client.order.specialRequestEnabled.animation())
                    
                    if client.order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $client.order.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $client.order.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(client: client)
                    } label: {
                        Text("Delivery Details")
                    }
                    .isDetailLink(false)
                }
            }
            .navigationTitle("Cupcake corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
