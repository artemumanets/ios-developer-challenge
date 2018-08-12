//
//  ViewController.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import UIKit

class MainViewController: LoadableDynamicViewController {

    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var comics: [Response.Comic] = []
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    init() {
        super.init(initialState: .loading)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewContent.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.viewContent.layoutIfNeeded()
        self.collectionView.backgroundColor = Theme.Color.none
        self.viewContent.backgroundColor = UIColor.red
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerNib(for: CellComicPreview.self)
        
        self.makeRequest()
    }
    
    func makeRequest() {
        self.set(state: .loading, animated: true)
        DataSource.response(with: Request.Comics.List(), onSuccess: { (response: Response.Paginated<Response.Comic>) in
            
            self.comics += response.result
            self.collectionView.reloadData()
            self.set(state: .content, animated: true)
        }, onError: self.errorCallback)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let baseHeight = self.collectionView.bounds.height
        let marginOffset = UI.Layout.ComicsList.margin * 2.0
        let availableHeight = (baseHeight - marginOffset) - UI.Layout.ComicsList.spaceBetweenItens * CGFloat((UI.Layout.ComicsList.numberOfRows - 1))
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(UI.Layout.ComicsList.margin, UI.Layout.ComicsList.margin, UI.Layout.ComicsList.margin, UI.Layout.ComicsList.margin)
            layout.minimumInteritemSpacing = UI.Layout.ComicsList.spaceBetweenItens
            layout.minimumLineSpacing = UI.Layout.ComicsList.spaceBetweenItens
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 100, height: availableHeight / CGFloat(UI.Layout.ComicsList.numberOfRows))
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return self.comics.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.reusableCell(for: indexPath, with: self.comics[indexPath.row]) as CellComicPreview
    }
}


