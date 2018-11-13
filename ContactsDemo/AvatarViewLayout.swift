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

    override func prepare() {
        print("prepare layout")
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard self.collectionView != nil else {
            return CGPoint.zero
        }

//        guard let itemsCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0) else {
//            return CGPoint.zero
//        }

        let actualItemWidth = itemSize.width + minimumInteritemSpacing
        currentPage = Int(round(proposedContentOffset.x / actualItemWidth))
        let updatedOffset = actualItemWidth * CGFloat(currentPage)

        return CGPoint(x: updatedOffset, y: proposedContentOffset.y)
    }

}
