//
//  MultipleSelectionHandler.swift
//  RSSelectionMenuExample
//
//  Created by Rushi Sangani on 23/07/18.
//  Copyright © 2019 Rushi Sangani. All rights reserved.
//

import Foundation
import RSSelectionMenu

extension RestarantRegisterForm2ViewController {
    
    // MARK: - Multi-Selection
    
    // MARK: - Push or Present
    
    
    // MARK: - Popover - Multi Select & Search with subTitle cell
    
    func showAsMultiSelectPopover(sender: UIView) {
        
        // selection type as multiple with subTitle Cell
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: dataArray, cellType: .subTitle) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name.components(separatedBy: " ").first
//            cell.detailTextLabel?.text = name.components(separatedBy: " ").last
        }
        
        // selected items
        
        selectionMenu.setSelectedItems(items: selectedDataArray) { [weak self] (text, index, selected, selectedList) in
            
            // update list
            self?.selectedDataArray = selectedList
            
            /// do some stuff...
            
            // update value label
            self?.multiSelectPopoverLabel.text = selectedList.joined(separator: ", ")
//            self?.tableView.reloadData()
        }
        
        // search bar
        selectionMenu.showSearchBar { [weak self] (searchText) -> ([String]) in
            return self?.dataArray.filter({ $0.lowercased().starts(with: searchText.lowercased()) }) ?? []
        }
        
        // show empty data label - provide custom text (if needed)
        selectionMenu.showEmptyDataLabel(text: "No Player Found")
        
        // cell selection style
        selectionMenu.cellSelectionStyle = .tickmark
        
        // show as popover
        // specify popover size if needed
        // size = nil (auto adjust size)
        selectionMenu.show(style: .popover(sourceView: sender, size: nil), from: self)
    }
}
