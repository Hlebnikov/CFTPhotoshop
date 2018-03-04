//
//  HistoryView.swift
//  CFTPhotoshop
//
//  Created by Aleksandr X on 26.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit

protocol HistoryViewDelegate: class {
  func historyView(_ hisoryView: HistoryView, didSelectImage image: UIImage)
}


class HistoryView: XibDesignedView {
  @IBOutlet private weak var historyTable: UITableView!
  
  private var cellPresenters: [HistoryTableCellPresenter] = []
  
  override var xibName: String {
    return "HistoryView"
  }
  
  weak var delegate: HistoryViewDelegate?
  
  var hisoryKeeper: HistoryKeeper? {
    didSet {
      do {
        let history = try hisoryKeeper?.getAllObjects()
        cellPresenters = history?.map({ historyRecord in
          let presenter = HistoryTableCellPresenter()
          presenter.state = HistoryTableViewCell.State.show(image: historyRecord.image, filterName: historyRecord.filterName)
          return presenter
        }) ?? []
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
    historyTable.delegate = self
    historyTable.reloadData()
  }
  
  func addRecord(image: Promise<UIImage>, filterName: String) {
    let presenter = HistoryTableCellPresenter()
    cellPresenters += [presenter]
    presenter.update(withPromise: image, filterName: filterName)
    
    historyTable.reloadData()
  }
}

extension HistoryView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellPresenters.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.xibName, for: indexPath) as? HistoryTableViewCell {
      let presenter = cellPresenters[cellPresenters.count - indexPath.row - 1]
      cell.presenter = presenter
      presenter.delegate = self
      return cell
    }
    return UITableViewCell()
  }
}

extension HistoryView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    
    if let cellState = cellPresenters[cellPresenters.count - indexPath.row - 1].state {
      switch cellState {
      case .show(image: let image, filterName: _):
        self.delegate?.historyView(self, didSelectImage: image)
      default:
        break
      }
    }
  }
}

extension HistoryView: HistoryCellPresenterDelegate {
  func historyCellPresenter(_ cellPresenter: HistoryTableCellPresenter, didCompleteLoadImageWithResult result: EditResult) {
    var editResult = result
    do {
      try self.hisoryKeeper?.save(object: &editResult)
    } catch {
      assertionFailure()
      print("Filter result hasn't been saved")
    }
  }
}
