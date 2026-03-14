//
//  AddTagAlert.swift
//  PomoBanco
//
//  Reusable "New label" alert (text field + Cancel/Add) for adding tags.
//

import SwiftUI

struct AddTagAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var tagName: String
    let message: String
    let onAdd: () -> Void

    func body(content: Content) -> some View {
        content
            .alert(AppStrings.newLabel, isPresented: $isPresented) {
                TextField(AppStrings.labelName, text: $tagName)
                Button(AppStrings.cancel, role: .cancel) {
                    tagName = ""
                }
                Button(AppStrings.add) {
                    onAdd()
                    tagName = ""
                }
            } message: {
                Text(message)
            }
    }
}

extension View {
    /// Presents the standard "New label" alert for creating a tag.
    /// - Parameters:
    ///   - isPresented: Binding controlling alert visibility.
    ///   - tagName: Binding to the text field value (caller's state).
    ///   - message: Message shown below the title (e.g. createTagMessageNew / createTagMessageEdit).
    ///   - onAdd: Called when user taps Add; read `tagName` here, create/fetch tag, assign, then modifier clears `tagName`.
    func addTagAlert(
        isPresented: Binding<Bool>,
        tagName: Binding<String>,
        message: String,
        onAdd: @escaping () -> Void
    ) -> some View {
        modifier(AddTagAlertModifier(isPresented: isPresented, tagName: tagName, message: message, onAdd: onAdd))
    }
}
