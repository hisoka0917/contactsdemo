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
    var itemSpacing: CGFloat = 0
    var leadingSpacing: CGFloat = 0
    var itemWidth: CGFloat = 0
    var contentSize: CGSize = .zero
    var numberOfItems: Int = 0
    private var cacheAttributes = [UICollectionViewLayoutAttributes]()
    private var currentPage: Int = 0

    // MARK: - Override
    override func prepare() {
        if let collectionView = self.collectionView, let sliderView = collectionView.superview as? AvatarSliderView {
            leadingSpacing = (collectionView.frame.width - itemSize.width) / 2
            itemWidth = itemSize.width + itemSpacing
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

        let targetItem = self.targetItem(for: proposedContentOffset.x)
        let updatedOffset = itemWidth * CGFloat(targetItem)

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

        for item in 0 ..< numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cacheAttributes.append(attributes)
            xOffset += itemWidth
        }
    }

    // MARK: - Methods

    func contentOffset(for index: Int) -> CGPoint {
        let offsetX = CGFloat(index) * itemWidth
        return CGPoint(x: offsetX, y: 0)
    }

    func targetItem(for contentOffset: CGFloat) -> Int {
        currentPage = Int(round(contentOffset / itemWidth))
        currentPage = min(currentPage, numberOfItems - 1)
        currentPage = max(currentPage, 0)
        return currentPage
    }

}
