//
//  CheckoutView.swift
//  Cupcake Corner
//
//  Created by Luis Rivera Rivera on 3/17/22.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var client: Client
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var showingNetworkError = false
    
    @State private var receipt: OrderStruct?
    @State private var isShowingOrderSummary = true

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 233)
                    .accessibilityElement()
                    
                    if isShowingOrderSummary {
                        OrderSummaryCard(client: client)
                            .frame(height: abs(geometry.size.height) * 0.60)
                        Spacer()
                        Button("Place Order") {
                            Task {
                                await placeOrder()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        
                    } else {
                        VStack {
                            ThankYouView()                           
                        }
                    }
                }
            }
            .navigationTitle("Check Out")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Thank you!", isPresented: $showingConfirmation) {
                Button("Ok") {}
            } message: {
                Text(confirmationMessage)
            }
            .alert("Network Error", isPresented: $showingNetworkError) {
                Button("Ok") {}
            } message: {
                Text("Your order could not be processed at this time.")
            }
            .onChange(of: receipt) { _ in
                isShowingOrderSummary.toggle()
            }
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(client.order) else {
            print("Fail to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "Post"
        
        do {
            let (data,_) = try await URLSession.shared.upload(for: request, from: encoded)
            // handle the result
            let decodedOrder = try JSONDecoder().decode(OrderStruct.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
            receipt = decodedOrder
        } catch {
            showingNetworkError = true
            print("Check Out Failed")
        }
    }
    
}

struct ThankYouView: View {
    var body: some View {
        VStack() {
            Image(systemName: "checkmark.circle")
                .resizable()
                .scaledToFit()
                .foregroundColor(.green)
                .frame(width: 100, height: 100)
            
            Text("Thank You!")
                .font(.largeTitle.bold())
        }
    }
}

struct OrderSummaryCard: View {
    var client: Client
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                
                VStack {
                    HStack {
                        Text("Order Summary")
                            .font(.title.bold())
                        Spacer()
                        Image(systemName: "cup.and.saucer")
                            .font(.largeTitle.bold())
                    }
                    .padding([.horizontal, .top])
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("Items")
                                .font(.headline)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        
                        ForEach(0..<client.order.quantity) { index in
                            HStack {
                                Text("\(index + 1). \(OrderStruct.types[client.order.type]) cupcake")
                                    .bold()
                                
                                Spacer()
                                
                                Text("\(client.order.priceForTypeSelected, format: .currency(code: "USD"))")
                            }
                        }
                        
                        if client.order.extraFrosting {
                            HStack {
                                Text("Extra Frosting Add-on")
                                Spacer()
                                Text("$1.00 each")
                            }
                        }
                        
                        if client.order.addSprinkles {
                            HStack {
                                Text("Sprinkles Add-on")
                                Spacer()
                                Text("$0.50 each")
                            }
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
                    
                    Divider()
                    HStack {
                        Spacer()
                        
                        Text("Total: ")
                            .bold()
                        +
                        Text("\(client.order.cost, format: .currency(code: "USD"))")
                    }
                    .padding()
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            CheckoutView(client: Client())
        }
    }
}
