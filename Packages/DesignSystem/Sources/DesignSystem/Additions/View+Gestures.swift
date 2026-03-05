//
//  View+Gestures.swift
//  DesignSystem
//
//  Created by Abdulaziz Albahar on 3/4/26.
//


public extension View {
    func onTouchDownUp(perform action: @escaping () -> ()) -> some View {
        self
            .onLongPressGesture(
                minimumDuration: 0,
                perform: action
            )
    }
}
