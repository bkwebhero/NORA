//
//  BellyMask.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/7/22.
//

import SwiftUI

struct BellyMask: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)
        path.addPath(Circle()
            .path(in: rect
                .inset(by: UIEdgeInsets(top: -100,
                                        left: -100,
                                        bottom: 0,
                                        right: -100))
                    .offsetBy(dx: 0,
                              dy: -50)))
        return path
    }
}
