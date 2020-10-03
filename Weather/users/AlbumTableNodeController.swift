
import UIKit
import AsyncDisplayKit

class AlbumTableNodeController: ASViewController<ASDisplayNode> {
  var photos: [Photo]!
  let tableNode: ASTableNode!
  
  init(album: [Photo]) {
    let tableNode = ASTableNode(style: .plain)
    self.photos = album
    self.tableNode = tableNode
    
    super.init(node: tableNode)
    
    self.tableNode.delegate = self
    self.tableNode.dataSource = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - ASTableDelegate

extension AlbumTableNodeController: ASTableDelegate {
  func tableView(_ tableView: ASTableView, willBeginBatchFetchWith context: ASBatchContext) {
    nextPageWithCompletion { (results) in
      self.insertNewRows(results)
      context.completeBatchFetching(true)
    }
  }
  
  func shouldBatchFetch(for tableView: ASTableView) -> Bool {
    return true
  }
  
  func tableView(_ tableView: ASTableView, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
    let photo = photos[(indexPath as NSIndexPath).row]
    return ASSizeRangeMake(CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * photo.aspectRatio), CGSize(width: UIScreen.main.bounds.size.width, height: .greatestFiniteMagnitude))
  }
}

// MARK: - ASTableDataSource

extension AlbumTableNodeController: ASTableDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return photos.count
  }
  
  func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    let photo = photos[(indexPath as NSIndexPath).row]
    
    return {
      let node = PhotoCellNode(photo: photo)
      return node
        
    }
  }
}

// MARK: - Helpers

extension AlbumTableNodeController {
  func nextPageWithCompletion(_ block: @escaping (_ results: [Photo]) -> ()) {
    let moreAnimals = Array(self.photos[0 ..< 5])
    
    DispatchQueue.main.async {
      block(moreAnimals)
    }
  }
  
  func insertNewRows(_ newAnimals: [Photo]) {
    let section = 0
    var indexPaths = [IndexPath]()
    
    let newTotalNumberOfPhotos = photos.count + newAnimals.count
    
    for row in photos.count ..< newTotalNumberOfPhotos {
      let path = IndexPath(row: row, section: section)
      indexPaths.append(path)
    }
    
    photos.append(contentsOf: newAnimals)
    if let tableView = node.view as? ASTableView {
      tableView.insertRows(at: indexPaths, with: .none)
    }
  }
}
