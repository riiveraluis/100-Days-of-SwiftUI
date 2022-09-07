//
//  AddressView.swift
//  Cupcake Corner
//
//  Created by Luis Rivera Rivera on 3/16/22.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var client: Client

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $client.order.name)
                TextField("Street address", text: $client.order.streetAddress)
                TextField("City", text: $client.order.city)
                TextField("Zip", text: $client.order.zip)
            }
            
            Section {
                NavigationLink {
                    CheckoutView(client: client)
                } label: {
                    Text("Check out")
                }
                .isDetailLink(false)
            }
            .disabled(client.order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            AddressView(client: Client())
        }
    }
}
