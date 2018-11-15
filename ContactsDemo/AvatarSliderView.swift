//
//  AvatarSliderView.swift
//  ContactsDemo
//
//  Created by Wang Kai on 2018/11/13.
//  Copyright © 2018 github. All rights reserved.
//

import UIKit

@objc
public protocol AvatarSliderViewDataSource: NSObjectProtocol {
    func numberOfItems(in pagerView: AvatarSliderView) -> Int
    func sliderView(_ sliderView: AvatarSliderView, cellForItemAt index: Int) -> AvatarViewCell
}

@objc
public protocol AvatarSliderViewDelegate: NSObjectProtocol {
    @objc optional func sliderView(_ sliderView: AvatarSliderView, didSelectItemAt index: Int)
    @objc optional func sliderViewDidScroll(_ sliderView: AvatarSliderView)
}

public class AvatarSliderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    public weak var dataSource: AvatarSliderViewDataSource?
    public weak var delegate: AvatarSliderViewDelegate?

    private var collectionView: UICollectionView!
    private var collectionViewLayout: AvatarViewLayout!
    private var numberOfItems: Int = 0
    private var previousItem: Int = 0
    private var targetItem: Int = 0
    private let cellWidth: CGFloat = 72
    private let interitemSpacing: CGFloat = 16

    // MARK: - Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
    }

    private func commonInit() {
        self.collectionViewLayout = AvatarViewLayout()

        self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.collectionViewLayout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.showsHorizontalScrollIndicator = false

        self.collectionViewLayout.scrollDirection = .horizontal
        self.collectionViewLayout.itemSize = CGSize(width: self.cellWidth, height: self.cellWidth)
        self.collectionViewLayout.itemSpacing = self.interitemSpacing

        self.addSubview(self.collectionView)
    }

    // MARK: - Public Methods

    public func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
        self.collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    public func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        self.collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    public func dequeueReusableCell(withReuseIdentifier identifier: String, at index: Int) -> AvatarViewCell {
        let indexPath = IndexPath(item: index, section: 0)
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        guard let sliderCell = cell as? AvatarViewCell else {
            fatalError("Cell class must be subclass of AvatarViewCell")
        }
        return sliderCell
    }

    public func scrollToItem(at index: Int, animated: Bool) {
        guard index < self.numberOfItems else {
            return
        }

        let contentOffset = self.collectionViewLayout.contentOffset(for: index)
        self.collectionView.setContentOffset(contentOffset, animated: animated)
    }

    public func deselectItem(at index: Int, animated: Bool) {
        guard index < self.numberOfItems else {
            return
        }
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView.deselectItem(at: indexPath, animated: animated)
    }

    // MARK: - UICollectionView Datasource

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = self.dataSource else {
            return 1
        }
        self.numberOfItems = dataSource.numberOfItems(in: self)
        return self.numberOfItems
    }


    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.dataSource?.sliderView(self, cellForItemAt: indexPath.item) else {
            return UICollectionViewCell()
        }

        if indexPath.row == 0 && self.previousItem == 0 && self.targetItem == 0 {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }

        return cell
    }

    // MARK: - UICollectionView Delegate

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let function = self.delegate?.sliderView(_:didSelectItemAt:) else {
            return
        }

        let index = indexPath.item % self.numberOfItems
        function(self, index)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scroll view did end scroll")
        let contentOffset = scrollView.contentOffset
        self.targetItem = self.collectionViewLayout.targetItem(for: contentOffset.x)
        self.selectItem(for: self.previousItem, selected: false)
        self.selectItem(for: targetItem, selected: true)
        self.previousItem = self.targetItem
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                          withVelocity velocity: CGPoint,
                                          targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("scroll view will end dragging")
        let offsetX = targetContentOffset.pointee.x
        self.targetItem = self.collectionViewLayout.targetItem(for: offsetX)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scroll view did end dragging")
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scroll view will begin dragging")
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scroll view did end decelerating")
        self.selectItem(for: self.previousItem, selected: false)
        self.selectItem(for: self.targetItem, selected: true)
        self.previousItem = self.targetItem
    }

    // MARK: - Private Methods

    private func selectItem(for index: Int, selected: Bool) {
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
}
