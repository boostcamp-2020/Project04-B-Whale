//
//  DataSource.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/04.
//

import UIKit

final class SideBarCollectionViewDataSource: NSObject, UICollectionViewDataSource {
  
  private let viewModel: ViewModel
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    <#code#>
  }
}
