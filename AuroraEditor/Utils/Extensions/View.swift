//
//  View.swift
//  Aurora Editor
//
//  Created by Lukas Pistrol on 22.03.22.
//  Copyright © 2023 Aurora Company. All rights reserved.
//

import SwiftUI

internal extension View {

    /// Changes the cursor appearance when hovering attached View
    /// - Parameters:
    ///   - active: onHover() value
    ///   - isDragging: indicate that dragging is happening. If true this will not change the cursor.
    ///   - cursor: the cursor to display on hover
    func isHovering(_ active: Bool, isDragging: Bool = false, cursor: NSCursor = .arrow) {
        if isDragging { return }
        if active {
            cursor.push()
        } else {
            NSCursor.pop()
        }
    }

    /// Change View according to `condition` parameter.
    ///
    /// We can use this like the below.
    ///
    ///     @State private var message = "Example"
    ///     Text(message)
    ///         .foregroundColor(Color.blue)
    ///         .if(message.isEmpty) {
    ///             $0.foregroundColor(Color.red)
    ///         }
    ///
    /// - Parameters:
    ///     - `condition`: the flag if we modify self with `whenTrue` closure.
    ///     - `whenTrue`: return new View for `true`
    func `if`(_ condition: @autoclosure () -> Bool, whenTrue: (Self) -> any View) -> AnyView {
        if condition() {
            return AnyView(whenTrue(self))
        }
        return AnyView(self)
    }
}
