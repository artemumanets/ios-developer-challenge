//
//  UICollectionView+Extension.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import UIKit
 
extension UICollectionReusableView: ReusableView {}

// MARK: - Register Cells and Suplementary views
public extension UICollectionView {
    
    public func registerNib<T: UICollectionViewCell>(for cellClass: T.Type, in bundle: Bundle? = nil) {
        register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    public func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}

// MARK: - Dequeue cells
public extension UICollectionView {
    
    public func reusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

// MARK: Deque cells for model presenter protocol
public extension UICollectionView {
    
    public func reusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, with model: T.Model) -> T where T: ModelPresenterCell {
        
        var cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
        cell.model = model
        return cell
    }
}

