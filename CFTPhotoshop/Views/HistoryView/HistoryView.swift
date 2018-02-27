//
//  HistoryView.swift
//  CFTPhotoshop
//
//  Created by Aleksandr X on 26.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit

class HistoryView: XibDesignedView {
  @IBOutlet private weak var historyTable: UITableView!
  
  private var cellStates: [HistoryTableViewCell.State] = []
  
  override var xibName: String {
    return "HistoryView"
  }
  
  var hisoryKeeper: HistoryKeeper? {
    didSet {
      do {
        let history = try hisoryKeeper?.getAllObjects()
        cellStates = history?.map({ HistoryTableViewCell.State.show(image: $0.image, filterName: $0.filterName) }) ?? []
      } catch {
        assertionFailure()
        return
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    historyTable.register(UINib(nibName: HistoryTableViewCell.xibName, bundle: nil), forCellReuseIdentifier: HistoryTableViewCell.xibName)
    historyTable.dataSource = self
    historyTable.reloadData()
  }
  
  func addRecord(image: Promise<UIImage>, filterName: String) {
    cellStates += [.loading(progress: 0)]
    let index = cellStates.count - 1
    image.onComplete {[unowned self] (image) in
      var editResult = EditResult(id: nil, image: image, filterName: filterName)
      do {
        try self.hisoryKeeper?.save(object: &editResult)
      } catch {
        assertionFailure()
        print("Result hasn't been saved")
      }
      self.cellStates[index] = .show(image: image, filterName: filterName)
      DispatchQueue.main.async {
        self.historyTable.reloadData()
      }
    }
    historyTable.reloadData()
  }
}

extension HistoryView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellStates.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.xibName, for: indexPath) as? HistoryTableViewCell
    cell?.set(state: cellStates[cellStates.count - indexPath.row - 1])
    return cell ?? UITableViewCell()
  }
}
