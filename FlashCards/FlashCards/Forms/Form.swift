//
//  Form.swift
//  FlashCards
//
//  Created by Work on 8/5/22.
//


protocol FormField {
    func configure(label: String?, key: Int, value: Any, delegate: FormFieldDelegate)
}

protocol FormFieldDelegate{
    func formField(_ sender: FormField, key: Int, value: Any)
}
