//
//  ContactPagerView.swift
//  ContactsDemo
//
//  Created by Wang Kai on 2018/11/16.
//  Copyright © 2018 github. All rights reserved.
//

import UIKit

public protocol ContactPagerViewDataSource: NSObjectProtocol {
    func numberOfPages(in pagerView: ContactPagerView) -> Int
    func pagerView(_ pagerView: ContactPagerView, cellForItemAt index: Int) -> ContactPageCell
}

@objc
public protocol ContactPagerViewDelegate: NSObjectProtocol {
    @objc optional func pagerViewDidScroll(_ pagerView: ContactPagerView)
    @objc optional func pagerViewDidStopped(at index: Int)
}

public class ContactPagerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    public weak var dataSource: ContactPagerViewDataSource?
    public weak var delegate: ContactPagerViewDelegate?

    // The percentage of y position
    public var scrollOffset: CGFloat {
        let contentOffset = self.collectionView.contentOffset.y
        let scrollOffset = Double(contentOffset / self.collectionViewLayout.itemSize.height)
        return fmod(CGFloat(scrollOffset), CGFloat(Double(self.numberOfItems)))
    }

    private var collectionView: UICollectionView!
    private var collectionViewLayout: UICollectionViewFlowLayout!
    private var isScrolling: Bool = false
    private var numberOfItems: Int = 0

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
        self.collectionViewLayout.itemSize = self.bounds.size
    }

    private func commonInit() {
        self.collectionViewLayout = UICollectionViewFlowLayout()

        self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.collectionViewLayout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = true
        self.collectionView.isPagingEnabled = true

        self.collectionViewLayout.scrollDirection = .vertical
        self.collectionViewLayout.minimumInteritemSpacing = 0
        self.collectionViewLayout.minimumLineSpacing = 0

        self.addSubview(self.collectionView)
    }

    // MARK: - Public Methods

    public func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
        self.collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    public func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        self.collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    public func dequeueReusableCell(withReuseIdentifier identifier: String, at index: Int) -> ContactPageCell {
        let indexPath = IndexPath(item: index, section: 0)
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        guard let pagerCell = cell as? ContactPageCell else {
            fatalError("Cell class must be subclass of ContactPageCell")
        }
        return pagerCell
    }

    public func setContentOffset(_ y: CGFloat, animated: Bool) {
        if !self.isScrolling {
            self.collectionView.setContentOffset(CGPoint(x: 0, y: y), animated: animated)
        }
    }

    // MARK: - UICollectionView DataSource

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }

        self.numberOfItems = dataSource.numberOfPages(in: self)
        return self.numberOfItems
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.dataSource?.pagerView(self, cellForItemAt: indexPath.section) else {
            return UICollectionViewCell()
        }

        return cell
    }

    // MARK: - UICollectionView Delegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let function = self.delegate?.pagerViewDidScroll(_:) else {
            return
        }

        function(self)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isScrolling = true
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.isScrolling = false
        self.delegate?.pagerViewDidStopped?(at: Int(self.scrollOffset))
    }
}
