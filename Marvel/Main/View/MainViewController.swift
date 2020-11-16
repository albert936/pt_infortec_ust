//
//  MainViewController.swift
//  Marvel
//
//  Created by Albert on 15/11/20.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    // MARK: - PROPERTIES
    private var viewModel = MainViewModel()
    private var router = MainRouter()
    private var disposeBag = DisposeBag()
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var characters = [Character]()
    private var filteredCharacters = [Character]()
    
    lazy var filterView: UISearchController = ({
        let controller = UISearchController(searchResultsController: nil)
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.sizeToFit()
        controller.searchBar.barStyle = .black
        controller.searchBar.barTintColor = Color.darkBlue
        controller.searchBar.tintColor = .lightGray
        controller.searchBar.placeholder = "Filtrar..."
        controller.obscuresBackgroundDuringPresentation = false
        
        return controller
    })()
    
    // MARK: - OUTLETS
    @IBOutlet weak var charactersTableView: UITableView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            activityIndicatorView.color = .white
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
        }
    }
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.darkBlue
        
        viewModel.bind(viewController: self, router: router)
        
        configureTableView()
        
        setFilterview()
        
        getCharacters()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setFilterview() {
        let searchBar = filterView.searchBar
        charactersTableView.tableHeaderView = searchBar
        charactersTableView.contentOffset = CGPoint(x: 0, y: searchBar.frame.size.height)
        filterView.delegate = self
        
        searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { result in
                self.filteredCharacters = self.characters.filter({ character in
                    return character.name.lowercased().contains(result.lowercased())
                })
                DispatchQueue.main.async {
                    self.charactersTableView.reloadData()
                }
            })
            .disposed(by: disposeBag)

    }
        
    private func configureTableView() {
        charactersTableView.dataSource = self
        charactersTableView.delegate = self
        charactersTableView.register(UINib(nibName: "CharacterCell", bundle: Bundle.main), forCellReuseIdentifier: "CharacterCell")
        charactersTableView.separatorStyle = .none
        charactersTableView.backgroundColor = .clear
        charactersTableView.showsVerticalScrollIndicator = false
    }
    
    private func getCharacters() {
        self.activityIndicatorView.isHidden = false
        self.activityIndicatorView.startAnimating()
        return viewModel.getCharacters()
            .subscribeOn(MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe { characters in
                self.characters = characters
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.activityIndicatorView.isHidden = true
                    self.charactersTableView.reloadData()
                }
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - EXTENSIONS
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let array = self.filterView.isActive && self.filterView.searchBar.text != "" ? filteredCharacters : characters
        viewModel.showCharacterDetail(characterId: array[indexPath.row].id)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterView.isActive && self.filterView.searchBar.text != "" ? filteredCharacters.count : characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let characterCell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
            
        let character = self.filterView.isActive && self.filterView.searchBar.text != "" ? filteredCharacters[indexPath.row] : characters[indexPath.row]
        
        characterCell.nameLabel.text = character.name
        
        characterCell.backgroundColor = indexPath.row.isMultiple(of: 2) ? Color.darkBlue : Color.blue
        
        return characterCell
    }
}

extension MainViewController: UISearchControllerDelegate {
    func searchBarCancelButtonClicked(_ searchbar: UISearchBar) {
        filterView.isActive = false
        charactersTableView.reloadData()
    }
}
