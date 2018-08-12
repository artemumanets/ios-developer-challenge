//
//  MainViewController.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import UIKit

class MainViewController: LoadableController {

    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var comics: [Response.Comic] = []
    private var hasMorePages = false
    private var currentPage = 0
        
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    init() {
        super.init(initialState: .loading)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewContent.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.collectionView.indicatorStyle = .white
        self.collectionView.backgroundColor = Theme.Color.none
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.registerNib(for: CellComicPreview.self)
        self.collectionView.registerNib(for: CellLoader.self)
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(UI.Layout.ComicsList.margin, UI.Layout.ComicsList.margin, UI.Layout.ComicsList.margin, UI.Layout.ComicsList.margin)
            layout.minimumInteritemSpacing = UI.Layout.ComicsList.spaceBetweenItens
            layout.minimumLineSpacing = UI.Layout.ComicsList.spaceBetweenItens
            layout.scrollDirection = .horizontal
        }
        
        self.makeRequest()
        
        self.viewError.onRetryCallback = { self.makeRequest() }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        ImageDownloadManager.shared.clear()
    }
    
    func makeRequest() {
        if self.currentPage != 0 && self.state == .loading { return }
        
        if self.currentPage == 0 { self.set(state: .loading, animated: true) }
        else if self.currentPage > 0 && self.state == .error { self.set(state: .content, animated: true) }
        else { self.state = .loading }
        
        let request = Request.Comics.List(pageSize: APIConstant.comicsPageSize, offset: APIConstant.comicsPageSize * self.currentPage)
        DataSource.response(with: request, onSuccess: { (response: Response.Paginated<Response.Comic>) in
            if self.currentPage == 0 { self.set(state: .content, animated: true) }
            else { self.state = .content }
            self.hasMorePages = (response.count == response.limit)
            self.currentPage += 1
            self.comics += response.result
            self.collectionView.reloadData()
        }, onError: self.errorCallback)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.hasMorePages { return self.comics.count + 1 }
        else { return self.comics.count }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == self.comics.count {
            self.makeRequest()
            return collectionView.reusableCell(for: indexPath) as CellLoader
        }
        return collectionView.reusableCell(for: indexPath, with: self.comics[indexPath.row]) as CellComicPreview
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == self.comics.count { return CellLoader.itemSize(in: collectionView) }
        else { return CellComicPreview.itemSize(in: collectionView) }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < self.comics.count {
            let selectedComic = self.comics[indexPath.row]
            let comicPreview = CoverPreviewViewController(comic: selectedComic)
            self.present(comicPreview, animated: true)
        }
    }
}


