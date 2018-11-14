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
    var contentSize: CGSize = .zero
    var numberOfItems: Int = 0
    private var cacheAttributes = [UICollectionViewLayoutAttributes]()

    // MARK: - Override
    override func prepare() {
        if let collectionView = self.collectionView, let sliderView = collectionView.superview as? AvatarSliderView {
            leadingSpacing = (collectionView.frame.width - itemSize.width) / 2
            self.numberOfItems = sliderView.collectionView(collectionView, numberOfItemsInSection: 0)
            var contentWidth = leadingSpacing * 2
            contentWidth += itemSize.width * CGFloat(numberOfItems)
            contentWidth += itemSpacing * CGFloat(numberOfItems - 1)
            self.contentSize = CGSize(width: contentWidth, height: collectionView.frame.height)
            self.calculateAttributes()
        }

    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard self.collectionView != nil else {
            return CGPoint.zero
        }

        let actualItemWidth = itemSize.width + itemSpacing
        currentPage = Int(round(proposedContentOffset.x / actualItemWidth))
        currentPage = min(currentPage, numberOfItems - 1)
        currentPage = max(currentPage, 0)
        let updatedOffset = actualItemWidth * CGFloat(currentPage)

        return CGPoint(x: updatedOffset, y: proposedContentOffset.y)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in cacheAttributes {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath.item]
    }

    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }

    // MARK: - Private

    private func calculateAttributes() {
        guard let collectionView = self.collectionView else {
            return
        }

        var xOffset = leadingSpacing
        let yOffset = (collectionView.frame.height - itemSize.height) / 2
        let itemWidth = itemSize.width + itemSpacing

        for item in 0 ..< numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cacheAttributes.append(attributes)
            xOffset += itemWidth
        }
    }

}
