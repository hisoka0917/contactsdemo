//
//  ContactsViewController.swift
//  ContactsDemo
//
//  Created by Wang Kai on 2018/11/12.
//  Copyright © 2018 github. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var contactList = [Contact]()
    private let cellReuseIdentifier = "AvatarCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts"

        self.loadData()

        self.setupCollectionView()
    }

    private func loadData() {
        if let path = Bundle.main.path(forResource: "contacts", ofType: "json") {
            if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                if let list = try? JSONDecoder().decode([Contact].self, from: jsonData) {
                    self.contactList = list
                }
            }
        }
    }

    private func setupCollectionView() {
        self.collectionView.register(AvatarViewCell.self, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100)
        self.collectionView.showsHorizontalScrollIndicator = false

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 72, height: 72)
        self.collectionView.setCollectionViewLayout(layout, animated: false)

        self.view.addSubview(self.collectionView)
    }

    // MARK: - UICollectionView Datasource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contactList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)

        if let avatarCell = cell as? AvatarViewCell {
            avatarCell.imageName = self.contactList[indexPath.row].avatar_filename
        }

        return cell
    }

    // MARK: - UICollectionView Delegate

    // MARK: - UICollectionView Delegate Flow Layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 72, height: 72)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leadingSpacing = (collectionView.frame.width - 72) / 2
        return UIEdgeInsets(top: 0, left: leadingSpacing, bottom: 0, right: leadingSpacing)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
