//
//  ContentView.swift
//  Drawing
//
//  Created by Luis Rivera Rivera on 7/27/22.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 1
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                
                Group {
                    TrianglePathView()
                        .tabItem {
                            Label("Triangle Path", systemImage: "triangle.fill")
                        }
                        .tag(1)
                    
                    TriangleWithShapeView()
                        .tabItem {
                            Label("Triangle Shape", systemImage: "triangle")
                        }
                        .tag(2)
                    
                    ArcView()
                        .tabItem {
                            Label("Arc Shape", systemImage: "arrowshape.turn.up.left")
                        }
                        .tag(3)
                    
                    InsideBorderView()
                        .tabItem {
                            Label("Inside Border Shape", systemImage: "arrowshape.turn.up.right.circle")
                        }
                        .tag(4)
                    
                    InsettableArcView()
                        .tabItem {
                            Label("Insettable Arc", systemImage: "arrowshape.turn.up.right.circle")
                        }
                        .tag(5)
                }
                
                Group {
                    FlowerView()
                        .tabItem {
                            Text("Flower")
                        }
                        .tag(6)
                    
                    ImagePaintView()
                        .tabItem {
                            Label("Image Paint", systemImage: "photo.artframe")
                        }
                        .tag(7)
                    
                    ColorCyclingView()
                        .tabItem {
                            Label("Color Cycling", systemImage: "bicycle")
                        }
                        .tag(8)
                    
                    ImageBlendedView()
                        .tabItem {
                            Label("Image blended", systemImage: "person.crop.artframe")
                        }
                        .tag(9)
                    
                    ColorMergingCircleView()
                        .tabItem {
                            Label("Color Blending Circles", systemImage: "record.circle.fill")
                        }
                        .tag(10)
                    
                    ImageBlurSaturationView()
                        .tabItem {
                            Label("Image Blur-saturation", systemImage: "paintpalette")
                        }
                        .tag(11)
                }
                
                AnimatedTrapezoidView()
                    .tabItem {
                        Label("Animated Trapezoid", systemImage: "trapezoid.and.line.vertical")
                    }
                    .tag(12)
                
                CheckerBoxView()
                    .tabItem {
                        Label("Checkerboard", systemImage: "checkerboard.rectangle")
                    }
                    .tag(13)
                
                SpirographView()
                    .tabItem {
                        Label("Spirograph", systemImage: "compass.drawing")
                    }
                    .tag(14)
                
                ArrowView()
                    .tabItem {
                        Label("Arrow", systemImage: "line.diagonal.arrow")
                    }
                    .tag(15)
                
                ColorCyclingRectangleView()
                    .tabItem {
                        Label("Rectangle", systemImage: "rectangle.fill")
                    }
                    .tag(16)
            }
        }
    }
}

struct TrianglePathView: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 200, y: 100))
            path.addLine(to: CGPoint(x: 100, y: 300))
            path.addLine(to: CGPoint (x: 300, y: 300))
            path.addLine(to: CGPoint(x: 200, y: 100))
            //            path.closeSubpath()
        }
        .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
    }
}

struct TriangleWithShapeView: View {
    var body: some View {
        Triangle()
            .stroke(.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .frame(width: 300, height: 300)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

struct ArcView: View {
    var body: some View {
        Arc(startAngle: .degrees(0), endAngle: .degrees(110), clockwise: true)
            .stroke(.blue, lineWidth: 10)
            .frame(width: 300, height: 300)
    }
}

struct Arc: InsettableShape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    var insetAmount = 0.0
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

struct InsideBorderView: View {
    var body: some View {
        VStack {
            Circle()
                .stroke(.blue, lineWidth: 40)
            
            Text("Circle with border going out of view")
                .font(.headline)
                .padding(.top)
            
            Circle()
                .strokeBorder(.blue, lineWidth: 40)
            
            Text("Circle with border drawing inside the shape to avoid going out of screen")
                .font(.headline)
                .padding(.top)
        }
    }
}

struct InsettableArcView: View {
    var body: some View {
        VStack {
            Arc(startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
                .strokeBorder(.blue, lineWidth: 40)
            
            Text("Arc with border drawing inside the shape to avoid going out of screen")
                .font(.headline)
                .padding(.top)
        }
    }
}

struct FlowerView: View {
    @State private var petalOffset: Double = -20
    @State private var petalWidth: Double = 100
    var body: some View {
        VStack {
            Flower(petalOffset: petalOffset, petalWidth: petalWidth)
                .fill(.red, style: FillStyle(eoFill: true))
            
            Text("Offset")
            Slider(value: $petalOffset, in: -40...40)
                .padding([.horizontal, .bottom])
            
            Text("Width")
            Slider(value: $petalWidth, in: 0...100)
                .padding(.horizontal)
        }
    }
}

struct Flower: Shape {
    // How much to move this petal away from the center
    var petalOffset: Double = -20
    
    // How wide to make each petal
    var petalWidth: Double = 100
    
    func path(in rect: CGRect) -> Path {
        // The path that will hold all petals
        var path = Path()
        
        // Count from 0 up to pi * 2, moving up pi / 8 each time
        for number in stride(from: 0, to: Double.pi * 2, by: Double.pi / 8) {
            // rotate the petal by the current value of our loop
            let rotation = CGAffineTransform(rotationAngle: number)
            
            // move the petal to be at the center of our view
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            
            // create a path for this petal using our properties plus a fixed Y and height
            let originalPetal = Path(ellipseIn: CGRect(x: petalOffset, y: 0, width: petalWidth, height: rect.width / 2))
            
            // apply our rotation/position transformation to the petal
            let rotatedPetal = originalPetal.applying(position)
            
            // add it to our main path
            path.addPath(rotatedPetal)
        }
        
        // now send the main path back
        return path
    }
}

struct ImagePaintView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                Text("Hello World")
                    .frame(width: 300, height: 300)
                    .background(.red)
                
                Text("Hello World")
                    .frame(width: 300, height: 300)
                    .border(.red, width: 30)
                
                Text("Hello World")
                    .frame(width: 300, height: 300)
                    .background(Image("Example"))
                
                Text("Hello World")
                    .frame(width: 300, height: 300)
                    .border(ImagePaint(image: Image("Example"), scale: 0.2), width: 30)
                
                Text("Hello World")
                    .frame(width: 300, height: 300)
                    .border(ImagePaint(image: Image("Example"), sourceRect: CGRect(x: 0, y: 0.25, width: 1, height: 0.5), scale: 0.1), width: 30)
                
                Capsule()
                    .strokeBorder(ImagePaint(image: Image("Example"), scale: 0.1), lineWidth: 20)
                    .frame(width: 300, height: 200)
            }
        }
    }
}

struct ColorCyclingView: View {
    @State private var colorCycle = 0.0
    @State private var useMetal = false
    var body: some View {
        VStack {
            ColorCyclingCircle(amount: colorCycle, useMetal: useMetal)
                .frame(width: 300, height: 300)
            Group {
                Slider(value: $colorCycle)
                Toggle("Use Metal (Better Performance)", isOn: $useMetal)
            }
            .padding()
        }
    }
}

struct ColorCyclingCircle: View {
    var amount = 0.0
    let steps = 100
    var useMetal: Bool
    
    var body: some View {
        if useMetal {
            ZStack {
                ForEach(0..<steps) { value in
                    Circle()
                        .inset(by: Double(value))
                        .strokeBorder(
                            LinearGradient(gradient: Gradient(colors: [
                                color(for: value, brightness: 1),
                                color(for: value, brightness: 0.5)
                            ]),
                                           startPoint: .top,
                                           endPoint: .bottom)
                        )
                }
            }
            .drawingGroup()
        } else {
            ZStack {
                ForEach(0..<steps) { value in
                    Circle()
                        .inset(by: Double(value))
                        .strokeBorder(
                            LinearGradient(gradient: Gradient(colors: [
                                color(for: value, brightness: 1),
                                color(for: value, brightness: 0.5)
                            ]),
                                           startPoint: .top,
                                           endPoint: .bottom)
                        )
                }
            }
        }
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
        
    }
}

struct ImageBlendedView: View {
    @State private var color = Color.red
    let colors: [Color] = [.red, .blue, .green, .brown, .cyan, .orange, .mint, .pink, .indigo, .purple, .yellow, .gray]
    
    var body: some View {
        VStack {
            ZStack {
                Image("Luis Profile")
                    .colorMultiply(color)
            }
            .frame(width: 400, height: 500)
            .clipped()
            
            Text("Blended Color:")
                .font(.headline)
            
            Picker("Color", selection: $color) {
                ForEach(colors, id: \.self) {
                    Text($0.description)
                }
            }
            .pickerStyle(.automatic)
            .padding(.horizontal)
        }
    }
}

struct ColorMergingCircleView: View {
    @State private var amount = 0.0
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color(red: 1, green: 0, blue: 0))
                    .frame(width: 200 * amount)
                    .offset(x: -50, y: -80)
                    .blendMode(.screen)
                
                Circle()
                    .fill(Color(red: 0, green: 1, blue: 0))
                    .frame(width: 200 * amount)
                    .offset(x: 50, y: -80)
                    .blendMode(.screen)
                
                Circle()
                    .fill(Color(red: 0, green: 0, blue: 1))
                    .frame(width: 200 * amount)
                    .blendMode(.screen)
            }
            .frame(width: 300, height: 300)
            
            Slider(value: $amount)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .ignoresSafeArea()
    }
}

struct ImageBlurSaturationView: View {
    @State private var amount = 0.0
    
    var body: some View {
        VStack {
            Image("Luis Profile")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .saturation(amount)
                .blur(radius: (1 - amount) * 20)
            
            Slider(value: $amount)
                .padding(.horizontal)
        }
    }
}

struct AnimatedTrapezoidView: View {
    @State private var insetAmount = 50.0
    
    var body: some View {
        Trapezoid(insetAmount: insetAmount)
            .frame(width: 200, height: 100)
            .onTapGesture {
                withAnimation {
                    insetAmount = Double.random(in: 10...90)
                }
            }
    }
}

struct Trapezoid: Shape {
    var insetAmount: Double
    
    var animatableData: Double { // Required for animation to work on a shape
        get { insetAmount }
        set { insetAmount = newValue }
    }
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        
        
        
        return path
    }
}

struct CheckerBoxView: View {
    @State private var rows = 4
    @State private var columns = 4
    
    var body: some View {
        Checkerboard(rows: rows, columns: columns)
            .onTapGesture {
                withAnimation(.linear(duration: 3)) {
                    rows += 8
                    columns += 8
                }
            }
        
    }
}

struct Checkerboard: Shape {
    var rows: Int
    var columns: Int
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(Double(rows), Double(columns))
        }
        
        set {
            rows = Int(newValue.first)
            columns = Int(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // figure out how big each row/column needs to be
        let rowSize = rect.height / Double(rows)
        let columnSize = rect.width / Double(columns)
        
        // loop over all rows and columns, making alternating squares colored
        for row in 0..<rows {
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    // this square should be colored; add a rectangle here
                    let startX = columnSize * Double(column)
                    let startY = rowSize * Double(row)
                    
                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }
        
        return path
    }
}

struct SpirographView: View {
    
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount = 1.0
    @State private var hue = 0.6
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Spirograph(innerRadius: Int(innerRadius), outerRadius: Int(outerRadius), distance: Int(distance), amount: amount)
                .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
                .frame(width: 300, height: 300)
            
            Spacer()
            
            Group {
                Text("Inner radius: \(Int(innerRadius))")
                Slider(value: $innerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])
                
                Text("Outer radius: \(Int(outerRadius))")
                Slider(value: $outerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])
                
                Text("Distance: \(Int(distance))")
                Slider(value: $distance, in: 1...150, step: 1)
                    .padding([.horizontal, .bottom])
                
                Text("Amount: \(amount, format: .number.precision(.fractionLength(2)))")
                Slider(value: $amount)
                    .padding([.horizontal, .bottom])
                
                Text("Color")
                Slider(value: $hue)
                    .padding(.horizontal)
            }
        }
    }
}


struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: Double
    
    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        
        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }
        
        return a
    }
    
    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let outerRadius = Double(self.outerRadius)
        let innerRadius = Double(self.innerRadius)
        let distance = Double(self.distance)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(2 * Double.pi * outerRadius / Double(divisor)) * amount
        
        var path = Path()
        
        for theta in stride(from: 0, through: endPoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)
            
            x += rect.width / 2
            y += rect.height / 2
            
            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}

struct Arrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Triangle - Arrow Head
        path.move(to: CGPoint(x: 200, y: 100))
        path.addLine(to: CGPoint(x: 100, y: 300))
        path.addLine(to: CGPoint(x: 300, y: 300))
        path.addLine(to: CGPoint(x: 200, y: 100))
        path.closeSubpath()
        
        // Base - Of Arrow
        path.move(to: CGPoint(x: 160, y: 300))
        path.addLine(to: CGPoint(x: 160, y: 500))
        path.addLine(to: CGPoint(x: 240, y: 500))
        path.addLine(to: CGPoint(x: 240, y: 300))
        path.closeSubpath()
        return path
    }
}

struct ColorCyclingRectangle: View {
    var amount = 0.0
    var steps = 100
    
    var topX: Double
    var topY: Double
    var bottomX: Double
    var bottomY: Double
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: Double(value))
                    .strokeBorder(
                        LinearGradient(gradient: Gradient(colors: [
                            color(for: value, brightness: 1),
                            color(for: value, brightness: 0.5)
                        ]),
                                       startPoint: UnitPoint(x: topX, y: topY),
                                       endPoint: UnitPoint(x: bottomX, y: bottomY)),
                        lineWidth: 2
                    )
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ArrowView: View {
    @State private var lineWidth = 0.5
    
    var body: some View {
        VStack {
            Arrow()
                .stroke(.blue,
                        style: StrokeStyle(
                            lineWidth: lineWidth * 10 + 1, lineCap: .round, lineJoin: .round
                        )
                )
            
            HStack {
                Text("Line Width:")
                Slider(value: $lineWidth.animation(.default))
            }
            .padding(.horizontal)
        }
    }
}

struct ColorCyclingRectangleView: View {
    @State private var colorCycle = 0.0
    @State private var steps = 100
    @State private var topX = 1.0
    @State private var topY = 1.0
    @State private var bottomX = 1.0
    @State private var bottomY = 1.0
    
    var body: some View {
        VStack {
            Spacer()
            
            ColorCyclingRectangle(amount: colorCycle, steps: steps, topX: topX, topY: topY, bottomX: bottomX, bottomY: bottomY)
                .frame(width: 250, height: 250)
            
            Spacer()
            
            VStack {
                Stepper(value: $steps, in: 1...1000) {
                    Text("Steps: \(steps)")
                }
                
                HStack {
                    Text("Top horizontal offset")
                    Slider(value: $topX)
                }
                
                HStack {
                    Text("Top vertical offset")
                    Slider(value: $topY)
                }
                
                HStack {
                    Text("Bottom horizontal offset")
                    Slider(value: $bottomX)
                }
                
                HStack {
                    Text("Bottom vertical offset")
                    Slider(value: $bottomY)
                }
                HStack {
                    Text("Color Cycle:")
                    Slider(value: $colorCycle)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
