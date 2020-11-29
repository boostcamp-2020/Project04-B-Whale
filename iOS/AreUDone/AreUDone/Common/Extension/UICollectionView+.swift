//
//  UICollectionView+.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/24.
//

import UIKit

extension UICollectionView {

  func register<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
    register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  func register<T: UICollectionViewCell>(_: T.Type) where T: Reusable, T: NibLoadable {
    let bundle = Bundle(for: T.self)
    let nib = UINib(nibName: T.nibName, bundle: bundle)
    
    register(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  func registerHeader<T: UICollectionReusableView>(_: T.Type) where T: Reusable {
    register(
      T.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: T.defaultReuseIdentifier
    )
  }
  
  func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: Reusable {
    guard let cell: T = dequeueReusableCell(
      withReuseIdentifier: T.defaultReuseIdentifier,
      for: indexPath
    ) as? T else {
      return T()
    }
    
    return cell
  }
  
  func dequeueReusableHeader<T: UICollectionReusableView>(forIndexPath indexPath: IndexPath) -> T where T: Reusable {
    guard let header: T = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.defaultReuseIdentifier,
            for: indexPath
    ) as? T else {
      return T()
    }
    
    return header
  }
}
