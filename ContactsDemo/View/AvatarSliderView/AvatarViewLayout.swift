//
//  AvatarViewLayout.swift
//  ContactsDemo
//
//  Created by Wang Kai on 2018/11/13.
//  Copyright © 2018 github. All rights reserved.
//

import UIKit

class AvatarViewLayout: UICollectionViewFlowLayout {

    var itemSpacing: CGFloat = 0
    var leadingSpacing: CGFloat = 0
    var itemWidth: CGFloat = 0
    var contentSize: CGSize = .zero
    var numberOfItems: Int = 0
    private var cacheAttributes = [UICollectionViewLayoutAttributes]()

    // MARK: - Override
    override func prepare() {
        if let collectionView = self.collectionView, let sliderView = collectionView.superview as? AvatarSliderView {
            self.leadingSpacing = (collectionView.frame.width - itemSize.width) / 2
            self.itemWidth = itemSize.width + self.itemSpacing
            self.numberOfItems = sliderView.collectionView(collectionView, numberOfItemsInSection: 0)

            var contentWidth = self.leadingSpacing * 2                          // Leading & trailing spacing
            contentWidth += itemSize.width * CGFloat(self.numberOfItems)        // Item sizes
            contentWidth += self.itemSpacing * CGFloat(self.numberOfItems - 1)  // Interitem spacing
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
        let updatedOffset = self.itemWidth * CGFloat(targetItem)

        return CGPoint(x: updatedOffset, y: proposedContentOffset.y)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in self.cacheAttributes {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cacheAttributes[indexPath.item]
    }

    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }

    // MARK: - Private

    private func calculateAttributes() {
        guard let collectionView = self.collectionView else {
            return
        }

        var xOffset = self.leadingSpacing
        let yOffset = (collectionView.frame.height - itemSize.height) / 2

        for item in 0 ..< self.numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            self.cacheAttributes.append(attributes)
            xOffset += self.itemWidth
        }
    }

    // MARK: - Methods

    func contentOffset(for index: Int) -> CGPoint {
        let offsetX = CGFloat(index) * self.itemWidth
        return CGPoint(x: offsetX, y: 0)
    }

    func targetItem(for contentOffset: CGFloat) -> Int {
        var currentPage = Int(round(contentOffset / self.itemWidth))
        currentPage = min(currentPage, self.numberOfItems - 1)
        currentPage = max(currentPage, 0)
        return currentPage
    }

}
