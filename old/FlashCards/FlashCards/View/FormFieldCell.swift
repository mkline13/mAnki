//
//  FormFieldCell.swift
//  FlashCards
//
//  Created by Work on 8/3/22.
//


protocol FormFieldCell {
    static var reuseIdentifier: String { get }
    func configure(fieldIndex index: Int, labelText: String, delegate: FormFieldCellDelegate) -> Void
}


protocol FormFieldCellDelegate {
    func formFieldCell(_ cell: FormFieldCell, valueDidChange newValue: String, fieldIndex index: Int)
}
