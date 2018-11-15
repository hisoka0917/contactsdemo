//
//  ContactsView.swift
//  ContactsDemo
//
//  Created by Wang Kai on 2018/11/15.
//  Copyright © 2018 github. All rights reserved.
//

import UIKit

protocol ContactsViewDataSource: NSObjectProtocol {
    func numberOfItems(in contactsView: ContactsView) -> Int
    func contactsView(_ contactsView: ContactsView, contactDataAt index: Int) -> Contact
}

class ContactsView: UIView {
    public weak var dataSource: ContactsViewDataSource?

    private var collectionView: UICollectionView!
    private var collectionViewLayout: UICollectionViewFlowLayout!
    private let pageReuseIdentifier = "ContactPageCell"

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
        self.collectionView.reloadData()
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
        self.collectionView.register(ContactPageCell.self, forCellWithReuseIdentifier: self.pageReuseIdentifier)

        self.collectionViewLayout.scrollDirection = .vertical
        self.collectionViewLayout.itemSize = self.bounds.size
        self.collectionViewLayout.minimumInteritemSpacing = 0
        self.collectionViewLayout.minimumLineSpacing = 0

        self.addSubview(self.collectionView)
    }

}

extension ContactsView: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        return dataSource.numberOfItems(in: self)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.pageReuseIdentifier, for: indexPath)

        if let contactPageCell = cell as? ContactPageCell, let dataSource = self.dataSource {
            let contact = dataSource.contactsView(self, contactDataAt: indexPath.section)
            contactPageCell.contactData = contact
        }

        return cell
    }

}
