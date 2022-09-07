//
//  ContentView.swift
//  Animations
//
//  Created by Luis Rivera Rivera on 12/18/21.
//

import SwiftUI

struct SimpleAnimationView: View {
    @State private var animationAmount = 1.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                Button("Scale and blur") {
                    animationAmount += 1
                }
                .padding(50)
                .background(.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .scaleEffect(animationAmount)
                .blur(radius: (animationAmount - 1) * 3)
                .animation(.default, value: animationAmount)
                
                Button("Scale and blur\nwith bouncing") {
                    animationAmount += 1
                }
                .padding(50)
                .background(.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .scaleEffect(animationAmount)
                .blur(radius: (animationAmount - 1) * 3)
                .animation(.interpolatingSpring(stiffness: 50, damping: 1), value: animationAmount)
                
                Button("Scale and blur\nin 2sec") {
                    animationAmount += 1
                }
                .padding(50)
                .background(.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .scaleEffect(animationAmount)
                .blur(radius: (animationAmount - 1) * 3)
                .animation(.easeInOut(duration: 2), value: animationAmount)
                
                Button("Scale and blur\nin 2sec\nafter 1 sec") {
                    animationAmount += 1
                }
                .padding(50)
                .background(.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .scaleEffect(animationAmount)
                .blur(radius: (animationAmount - 1) * 3)
                .animation(
                    .easeInOut(duration: 2)
                    .delay(1),
                    value: animationAmount
                )
                
                Button("Scale and blur\nreversing 3 times") {
                    animationAmount += 1
                }
                .padding(50)
                .background(.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .scaleEffect(animationAmount)
                .blur(radius: (animationAmount - 1) * 3)
                .animation(
                    .easeInOut(duration: 1)
                    .repeatCount(3, autoreverses: true), // Make sure the reversing includes the final state
                    value: animationAmount
                )
                
                Button("Scale and blur\nreversing ∞") {
                    animationAmount += 1
                }
                .padding(50)
                .background(.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .scaleEffect(animationAmount)
                .blur(radius: (animationAmount - 1) * 3)
                .animation(
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses: true),
                    value: animationAmount
                )
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom)
        }
    }
}

struct SimpleAnimationWithHint: View {
    @State private var animationAmount2 = 1.0
    
    var body: some View {
        VStack(spacing: 25) {
            Button("Circle with hint") {}
                .padding(50)
                .background(.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.red)
                        .scaleEffect(animationAmount2)
                        .opacity(2 - animationAmount2)
                        .animation(
                            .easeInOut(duration: 1)
                            .repeatForever(autoreverses: false),
                            value: animationAmount2
                        )
                )
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            animationAmount2 = 2.0
        }
    }
}

struct SimpleAnimationBindingView: View {
    @State private var animationAmount3 = 1.0
    
    var body: some View {
        VStack {
            Stepper("Scale amount", value: $animationAmount3.animation(
                .easeInOut(duration: 1)
                .repeatCount(3, autoreverses: true)
            ), in: 1...10)
            
            
            Spacer()
            
            Button("Tap me") {
                animationAmount3 += 1
            }
            .padding(40)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(animationAmount3)
            
            Spacer()
        }
        .padding(.all)
    }
}

struct AdvancedAnimation: View {
    @State private var animationAmount4 = 0.0
    @State private var enabled = false
    
    var body: some View {
        VStack(spacing: 25) {
            Button("Tap me") {
                withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                    animationAmount4 += 360
                }
            }
            .padding(50)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .rotation3DEffect(.degrees(animationAmount4), axis: (x: 0, y: 1, z: 0))
            
            Button("Tap me") {
                enabled.toggle()
            }
            .frame(width: 200, height: 200)
            .background(enabled ? .blue : .red)
            .animation(nil, value: enabled)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
            .animation(.interpolatingSpring(stiffness: 10, damping: 1), value: enabled)
        }
    }
}

struct DraggableAnimation: View {
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(dragAmount)
            .gesture(
                DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            dragAmount = CGSize.zero
                        }
                    }
            )
        //            .animation(.spring(), value: dragAmount)
    }
}
struct DraggableAnimationWithDelay: View {
    let letters = Array("Hello SwiftUI")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.default.delay(Double(num) / 20),  value: dragAmount) // For each letter delay the animation.
            }
        }
        .gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation }
                .onEnded { _ in
                    dragAmount = .zero
                    enabled.toggle()
                }
        )
    }
}

struct DisappearingElementsView: View {
    @State private var isShowingRed = false
    
    var body: some View {
        VStack {
            Button("Tap Me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
        }
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(active: CornerRotateModifier(amount: -90, anchor: .topLeading),
                  identity: CornerRotateModifier(amount: 0, anchor: .topLeading))
    }
}
struct RotatingRectangleView: View {
    @State private var isShowingRed = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            SimpleAnimationView()
                .tabItem {
                    Label("Basic", systemImage: "circle")
                }
            
            SimpleAnimationWithHint()
                .tabItem {
                    Label("Hint", systemImage: "circle")
                }
            
            SimpleAnimationBindingView()
                .tabItem {
                    Label("Binding", systemImage: "circle")
                }
            
            AdvancedAnimation()
                .tabItem {
                    Label("Advanced", systemImage: "circle")
                }
            
            DraggableAnimation()
                .tabItem {
                    Label("Draggable Animation", systemImage: "circle")
                }
            
            DraggableAnimationWithDelay()
                .tabItem {
                    Label("Draggable Animation with Delay", systemImage: "circle")
                }
            
            DisappearingElementsView()
                .tabItem {
                    Label("Transition", systemImage: "circle")
                }
            
            RotatingRectangleView()
                .tabItem {
                    Label("Rotation", systemImage: "circle")
                    
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
