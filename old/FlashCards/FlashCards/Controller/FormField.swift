//
//  FormField.swift
//  FlashCards
//
//  Created by Work on 8/4/22.
//

class FormField {
    let label: String
    let type: FormFieldType
    var value: String
    let required: Bool
    
    init (label: String, type: FormFieldType, initialValue: String = "", required: Bool = false) {
        self.label = label
        self.type = type
        self.value = initialValue
        self.required = required
    }
}

enum FormFieldType: CaseIterable {
    case title
    case regular
    case multiline
    case spacer
    case disclosure
}
