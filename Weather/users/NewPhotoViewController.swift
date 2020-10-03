//
//  NewPhotoViewController.swift
//  Weather
//
//  Created by Matthew on 02.10.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class NewPhotoViewController: UIViewController {

  var user: User!
  let pagerNode = ASPagerNode()
  var allAlbums: [Album] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    VkApi().getPhotosAllByAlbum(userId: user.id) { [weak self] albums in
        self?.allAlbums = albums

        self?.pagerNode.setDataSource(self)
        self?.view.addSubnode(self!.pagerNode)
    }
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    self.pagerNode.frame = self.view.bounds
  }
  
  override var prefersStatusBarHidden : Bool {
    return true
  }
}

// MARK: - ASPagerDataSource

extension NewPhotoViewController: ASPagerDataSource {
  func pagerNode(_ pagerNode: ASPagerNode, nodeAt index: Int) -> ASCellNode {
    let album = allAlbums[index]
    
    let node = ASCellNode(
        viewControllerBlock: { () -> UIViewController in
            return AlbumTableNodeController(album: album.photos)
      }, didLoad: nil)
    
    node.style.preferredSize = pagerNode.bounds.size
    
    return node
  }
  
  func numberOfPages(in pagerNode: ASPagerNode) -> Int {
    return allAlbums.count
  }
}
