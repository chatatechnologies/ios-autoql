//
//  File.swift
//  
//
//  Created by Vicente Rincon on 23/03/22.
//

import Foundation
import SwiftUI
struct ProgressCircleQL: View{
    let delay: CGFloat = 0
    let diff: CGFloat = 0.1
    var body: some View{
        HStack{
            CircleAnimation(delay: delay)
            CircleAnimation(delay: delay + diff)
            CircleAnimation(delay: delay + diff * 2)
            Spacer()
        }
        .padding(8)
    }
}
struct CircleAnimation: View{
    @State var delay: Double
    @State var scale: CGFloat = 1
    var duration: CGFloat = 0.6
    var maxScale: CGFloat = 2
    var size = 2
    var body: some View{
        Circle()
            .frame(width: 6, height: 6)
            .foregroundColor(qlTextColorPrimary)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeIn(duration: duration).repeatForever().delay(delay)) {
                    self.scale = self.maxScale
                }
            }
    }
}
