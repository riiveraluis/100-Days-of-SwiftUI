//
//  DiceView.swift
//  Dicee Milestone
//
//  Created by Luis Rivera Rivera on 6/29/22.
//

import SwiftUI

struct DiceView: View {
    var diceValue: Int
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
            
            DiceDots(side: diceValue)
                .animation(.default, value: diceValue)
        }
        .overlay(
        RoundedRectangle(cornerRadius: 10)
            .stroke(.primary)
        )
        .frame(width: 75, height: 75)
    }
        
    
    struct DiceDots: View {
        var side: Int
        
        var body: some View {
            switch side {
            case 1:
                Circle()
                    .foregroundColor(.primary)
                    .frame(width: 15, height: 15)
            case 2:
                VStack {
                    HStack {
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 15, height: 15)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 15, height: 15)
                    }
                }
                .padding()
                
            case 3:
                VStack {
                    HStack {
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 10, height: 10)
                        Spacer()
                    }
                    
                    Circle()
                        .foregroundColor(.primary)
                        .frame(width: 10, height: 10)
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 10, height: 10)
                    }
                }
                .padding()
                
            case 4:
                VStack {
                    HStack {
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 15, height: 15)
                        Spacer()
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 15, height: 15)
                            
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 15, height: 15)
                        Spacer()
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 15, height: 15)
                    }
                    .padding(.horizontal)
                }
                
                
            case 5:
                VStack {
                    HStack {
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 15, height: 15)
                        Spacer()
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 15, height: 15)
                            
                    }
                    .padding(.horizontal)
                    
                    Circle()
                        .foregroundColor(.primary)
                        .frame(width: 15, height: 15)
                    
                    HStack {
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 15, height: 15)
                        Spacer()
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 15, height: 15)
                    }
                    .padding(.horizontal)
                }
                
            case 6:
                VStack {
                    HStack {
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 15, height: 15)
                        Spacer()
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 15, height: 15)
                            
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 15, height: 15)
                        Spacer()
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 15, height: 15)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 15, height: 15)
                        Spacer()
                        Circle()
                            .foregroundColor(.primary)
                            .frame(width: 15, height: 15)
                    }
                    .padding(.horizontal)
                }
                
            case 7..<101:
                Text(String(side))
                    .foregroundColor(.primary)
                    .font(.title)
                    .fontWeight(.bold)
                
            default:
                Text("Error")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.primary)
            }
        }
    }
}


struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView(diceValue: 1)
    }
}
