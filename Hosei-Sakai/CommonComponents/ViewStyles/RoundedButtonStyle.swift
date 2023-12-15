//
//  RoundedButton.swift
//  WillItRain
//
//  Created by 孟金羽 on 2021/06/24.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    var buttonColor: Color = .accentColor
    var textColor: Color = Color(uiColor: UIColor.systemBackground)
    var font: Font = .body
    var padding: CGFloat = 10
    var extend = false
    var maxRound = false
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack{
            if maxRound {
                Rectangle()
                    .layoutPriority(-1)
                    .foregroundColor(buttonColor)
                    .opacity(configuration.isPressed ? 0.5 : 1)
                    .clipShape(Capsule())
            } else {
                Rectangle()
                    .layoutPriority(-1)
                    .foregroundColor(buttonColor)
                    .opacity(configuration.isPressed ? 0.5 : 1)
                    .cornerRadius(10)
            }
            HStack {
                if extend {
                    Spacer()
                }
                configuration.label
                    .foregroundColor(textColor)
                    .font(font)
                    .fixedSize()
                    .padding(padding)
                    .padding([.leading, .trailing], 5)
                if extend {
                    Spacer()
                }
            }
        }
        
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        Button("Test", action: {
            
        })
        .buttonStyle(RoundedButtonStyle(buttonColor: .black))
    }
}
