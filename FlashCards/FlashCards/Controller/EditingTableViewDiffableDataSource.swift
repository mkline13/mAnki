//
//  EditingTableViewDiffableDataSource.swift
//  FlashCards
//
//  Created by Work on 8/4/22.
//

import UIKit


class EditingTableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        editHandler(tableView, editingStyle, indexPath)
    }

    // MARK: Initialization
    init(tableView: UITableView, cellProvider: @escaping UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider, editHandler: @escaping (UITableView, UITableViewCell.EditingStyle, IndexPath) -> Void) {
        self.editHandler = editHandler

        super.init(tableView: tableView, cellProvider: cellProvider)
    }

    // MARK: Properties
    private let editHandler: (UITableView, UITableViewCell.EditingStyle, IndexPath) -> Void
}
