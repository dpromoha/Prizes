//
//  UITableViewExtensions.swift
//  Prizes
//
//  Created by Daria Pr on 21.07.2021.
//

import UIKit

extension UITableView {
    func register(_ cellClass: AnyClass) {
        register(cellClass,
                 forCellReuseIdentifier: String(describing: cellClass))
    }
    
    func dequeue<T: UITableViewCell>(
        _ cellClass: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withIdentifier: String(describing: cellClass),
                            for: indexPath) as? T
    }
    
    func dequeue<T: UITableViewCell>(
        _ cellClass: T.Type, for row: Int) -> T? {
        dequeue(cellClass, for: IndexPath(row: row, section: 0))
    }
    
    func scroll(to item: Int, section: Int = 0,
                at position: ScrollPosition = .top, animated: Bool = true) {
        scrollToRow(at: IndexPath(row: item, section: section), at: position,
                     animated: animated)
    }
    
    func selectRow(at index: Int, animated: Bool = true,
                   scrollPosition: UITableView.ScrollPosition = .top) {
        let indexPath = IndexPath(row: index, section: 0)
        selectRow(at: indexPath, animated: animated,
                  scrollPosition: scrollPosition)
    }
    
    func deselectSelectedRows(animated: Bool) {
        if let indexPathsForSelectedRows = self.indexPathsForSelectedRows {
            indexPathsForSelectedRows.forEach { indexPath in
                self.deselectRow(at: indexPath, animated: animated)
            }
        }
    }
}
