//
//  FormCellProtocol.swift
//  FlashCards
//
//  Created by Work on 8/4/22.
//


protocol FormCell {
    func configure(with field: FormField, delegate: FormCellDelegate)
}

protocol FormCellDelegate {
    func formCell(_ sender: FormCell, fieldDidChange field: FormField)
}
