//
//  AvatarViewLayout.swift
//  ContactsDemo
//
//  Created by Wang Kai on 2018/11/13.
//  Copyright © 2018 github. All rights reserved.
//

import UIKit

class AvatarViewLayout: UICollectionViewFlowLayout {

    var previousOffset: CGFloat = 0
    var currentPage: Int = 0
    var itemSpacing: CGFloat = 0
    var leadingSpacing: CGFloat = 0

    override func prepare() {
        print("prepare layout")
        if let width = self.collectionView?.frame.width {
            let itemWidth = itemSize.width + itemSpacing
            leadingSpacing = (width - itemWidth) / 2
            let insets = UIEdgeInsets(top: 0, left: leadingSpacing, bottom: 0, right: leadingSpacing)
            self.sectionInset = insets
            print("")
        }
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return CGPoint.zero
        }

        let actualItemWidth = itemSize.width + itemSpacing
        currentPage = Int(round(proposedContentOffset.x / actualItemWidth))
//        let itemEdgeOffset:CGFloat = (collectionView.frame.width - itemSize.width -  minimumLineSpacing * 2) / 2
        let updatedOffset = actualItemWidth * CGFloat(currentPage) //- (itemEdgeOffset + minimumLineSpacing)

        return CGPoint(x: updatedOffset, y: proposedContentOffset.y)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let originals = super.layoutAttributesForElements(in: rect) {
            let attributes = originals.map({ $0.copy() as! UICollectionViewLayoutAttributes })
            for (index, attribute) in attributes.enumerated() {
                if index == 0 { continue }
                let prevLayoutAttributes = attributes[index - 1]
                let origin = prevLayoutAttributes.frame.maxX
                if origin + itemSpacing + attribute.frame.size.width < self.collectionViewContentSize.width
                    && attribute.frame.origin.x > prevLayoutAttributes.frame.origin.x {
                    attribute.frame.origin.x = origin + itemSpacing
                }
            }
            return attributes

        }
        return nil
    }

//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let collectionView = self.collectionView else {
//            return nil
//        }
//        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//        let actualItemWidth = itemSize.width + itemSpacing
//        let originX = leadingSpacing + CGFloat(indexPath.item) * actualItemWidth
//        let originY = (collectionView.frame.height - itemSize.height) / 2
//        let origin = CGPoint(x: originX, y: originY)
//        let frame = CGRect(origin: origin, size: itemSize)
//        attributes.frame = frame
//        attributes.center = CGPoint(x: frame.midX, y: frame.midY)
//        attributes.size = itemSize
//        return attributes
//    }

}
