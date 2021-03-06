//
//  ProgrammeViewController.swift
//  OCS
//
//  Created by aymen braham on 20/01/2022.
//

import UIKit
import Combine
import Kingfisher

class ProgrammeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var programmeCollectionView: UICollectionView!
    
    // MARK: - Variables
    private let cellIdentifier = "ProgrammeCollectionViewCell"
    private let cellPadding: CGFloat = 8
    var presenter: ProgrammesPresenterProtocol?
    var model: ResponseProgrammes?
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.searchBar.becomeFirstResponder()
        }
    }
    
    // MARK: - SetUp UI
    private func setUpUI() {
        setUpCollectionView()
        self.hideKeyboardWhenTappedAround()
        self.programmeCollectionView.keyboardDismissMode = .onDrag
    }
    
    private func setUpCollectionView() {
        registerCell()
    }
    
    private func registerCell() {
        self.programmeCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    // MARK: - Get programmes
    private func getProgrammes(text: String) {
        presenter?.showProgrammes(text: text).receive(on: DispatchQueue.main).sink(receiveCompletion: { (completion) in
            switch completion {
            case let .failure(error):
                print("Couldn't get programmes: \(error)")
            case .finished: break
            }
        }) { programmes in
            self.model = programmes
            self.programmeCollectionView.reloadData()
        }
        .store(in: &subscriptions)
    }
}

// MARK: - Collection DataSource && Delegate
extension ProgrammeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.contents?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ProgrammeCollectionViewCell else {
            fatalError("Unable to dequeue cell.")
        }
        DispatchQueue.main.async {
            if let urlImage = self.model?.contents?[indexPath.item].imageURL {
                let urlString = baseUrlImage + urlImage
                let url = URL(string: urlString)
                cell.programmeImage.kf.indicatorType = .activity
                cell.programmeImage.kf.setImage(with: url)
            }
            cell.programmeTitle.text = self.model?.contents?[indexPath.item].title?[0].value
            cell.programmeSubTitle.text = self.model?.contents?[indexPath.item].subtitle
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let programme = model?.contents?[indexPath.item] {
            presenter?.showProgrammeDetail(for: programme)
        }
    }
}

// MARK: - SearchBar Delegate
extension ProgrammeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            self.model = nil
            self.programmeCollectionView.reloadData()
        }
        if searchText.count >= 2 {
            getProgrammes(text: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        getProgrammes(text: text)
    }
    
}
