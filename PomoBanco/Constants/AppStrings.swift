//
//  AppStrings.swift
//  PomoBanco
//
//  UI copy in one place. Makes it easy to change wording and to add
//  localization later (replace with NSLocalizedString or String(localized:)).
//

import Foundation

enum AppStrings {

    // MARK: - Tag / label

    static let newLabel = "New label"
    static let labelName = "Label name"
    static let addNewLabel = "Add new label"
    static let addTag = "Add a tag"
    static let selectTag = "Select a tag"
    static let createTagMessageNew = "Create a new tag to use for this project."
    static let createTagMessageEdit = "Create a new tag for this project."

    // MARK: - Project

    static let newProject = "New Project"
    static let name = "Name"
    static let description = "Description"
    static let tag = "Tag"
    static let save = "Save"
    static let addTitlePlaceholder = "add a title"
    static let addDetailsPlaceholder = "optional: add details"
    static let addDescriptionPlaceholder = "add description here"

    // MARK: - Delete

    static let delete = "Delete"
    static let deleteProject = "Delete Project"
    static let deleteProjectMessage = "Are you sure you want to delete this project permanently?"
    static let areYouSure = "Are you sure?"

    // MARK: - Timer

    static let skipSession = "Skip Session"
    static let skipSessionMessage = "Skipping will reset the timer and the elapsed time will not be saved."
    static let selectTime = "Select Time"
    static let cancel = "Cancel"
    static let add = "Add"
}
