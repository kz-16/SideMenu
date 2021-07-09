//
//  SideMenuViewController.swift
//  SideMenuTest
//
//  Created by KZ on 08.07.2021.
//

import UIKit

protocol SideMenuDelegate {
    func selectCell(row: Int)
}

class SideMenuViewController: UIViewController {
  
  let menuTable = UITableView()
  var delegate: SideMenuDelegate?
  
  let cellID = "sideMenuItem"
  let sideMenuColor = UIColor(named: "Side Menu Color")
  let menuItems = [SideMenuItemModel(name: "First"),
                   SideMenuItemModel(name: "Second"),
                   SideMenuItemModel(name: "Third")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMenuTable()
    }
    
  func setupMenuTable() {
    menuTable.backgroundColor = UIColor(named: "Side Menu Color")
    menuTable.delegate = self
    menuTable.dataSource = self
    menuTable.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
    let footer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1))
    header.backgroundColor = sideMenuColor
    footer.backgroundColor = sideMenuColor
    menuTable.tableHeaderView = header
    menuTable.tableFooterView = footer
    
    view.addSubview(menuTable)
    menuTable.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      menuTable.topAnchor.constraint(equalTo: view.topAnchor),
      menuTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      menuTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      menuTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
    cell.backgroundColor = sideMenuColor
    let cellBGView = UIView()
    
    cellBGView.backgroundColor = .systemBlue
    cell.selectedBackgroundView = cellBGView
    cell.textLabel?.textColor = .white
    cell.textLabel?.text = menuItems[indexPath.row].name

    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
    tableView.deselectRow(at: indexPath, animated: true)
    self.delegate?.selectCell(row: indexPath.row)
          
  }
  
}
