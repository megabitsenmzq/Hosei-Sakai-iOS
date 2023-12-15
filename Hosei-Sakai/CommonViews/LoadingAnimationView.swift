//
//  FullScreenLoadingView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/24.
//

import SwiftUI

struct LoadingAnimationView: View {
    private struct DotView: View {
        @State var delay: Double = 0
        @State var scale: CGFloat = 0.5
        var body: some View {
            Circle()
                .foregroundColor(.accentColor)
                .frame(width: 70, height: 70)
                .scaleEffect(scale)
                .animation(Animation.easeInOut(duration: 0.6).repeatForever().delay(delay), value: UUID())
                .onAppear {
                    withAnimation {
                        self.scale = 1
                    }
                }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                DotView()
                DotView(delay: 0.2)
                DotView(delay: 0.4)
            }
            .padding(.bottom, 16)
            Text("読み込み中")
                .font(.callout)
                .foregroundColor(.gray)
        }
    }
}

struct LoadingAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingAnimationView()
    }
}
