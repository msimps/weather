
import UIKit
import AsyncDisplayKit

class PhotoCellNode: ASCellNode {

  let photo: Photo
    
  fileprivate let backgroundImageNode: ASImageNode
  fileprivate let photoImageNode: ASNetworkImageNode

  
  init(photo: Photo) {
    self.photo = photo
    
    backgroundImageNode = ASImageNode()
    photoImageNode     = ASNetworkImageNode()
    
    
    super.init()
    
    backgroundColor = UIColor.black
    clipsToBounds = true
    
    guard let image = photo.image,
        let url = URL(string: image)
        else { return }
    photoImageNode.url = url
    photoImageNode.clipsToBounds = true
    photoImageNode.delegate = self
    photoImageNode.placeholderFadeDuration = 0.15
    photoImageNode.contentMode = .scaleAspectFill
    photoImageNode.shouldRenderProgressImages = true

    //addSubnode(backgroundImageNode)
    addSubnode(photoImageNode)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let ratio: CGFloat = constrainedSize.min.height/constrainedSize.max.width;
    
    let imageRatioSpec = ASRatioLayoutSpec(ratio: CGFloat(0.5), child: photoImageNode)
    
    let nameInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0), child: imageRatioSpec)
    return nameInsetSpec
  }
}

// MARK: - ASNetworkImageNodeDelegate

extension PhotoCellNode: ASNetworkImageNodeDelegate {
  func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
    backgroundImageNode.image = image
  }
}

