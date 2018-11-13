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
    func sliderView(_ sliderView: AvatarSliderView, cellForItemAt index: Int) -> SliderViewCell
}

@objc
public protocol AvatarSliderViewDelegate: NSObjectProtocol {
    @objc optional func sliderView(_ sliderView: AvatarSliderView, didSelectItemAt index: Int)
    @objc optional func sliderViewDidScroll(_ sliderView: AvatarSliderView)
}

public class AvatarSliderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public weak var dataSource: AvatarSliderViewDataSource?
    public weak var delegate: AvatarSliderViewDelegate?

    private var collectionView: UICollectionView!
    private var collectionViewLayout: AvatarViewLayout!
    private var numberOfItems: Int = 0
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
        self.collectionViewLayout.minimumInteritemSpacing = 0

        self.addSubview(self.collectionView)
    }

    // MARK: - Public Methods

    public func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
        self.collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    public func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        self.collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    open func dequeueReusableCell(withReuseIdentifier identifier: String, at index: Int) -> SliderViewCell {
        let indexPath = IndexPath(item: index, section: 0)
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        guard let sliderCell = cell as? SliderViewCell else {
            fatalError("Cell class must be subclass of FSPagerViewCell")
        }
        return sliderCell
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

        return cell
    }

    // MARK: - UICollectionView Delegate

    // MARK: - UICollectionViewDelegateFlowLayout

    public func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }

    public func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                insetForSectionAt section: Int) -> UIEdgeInsets {
        let leadingSpacing = (collectionView.frame.width - cellWidth) / 2
        return UIEdgeInsets(top: 0, left: leadingSpacing, bottom: 0, right: leadingSpacing)
    }

    public func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpacing
    }
}
