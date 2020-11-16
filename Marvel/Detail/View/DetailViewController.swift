//
//  DetailViewController.swift
//  Marvel
//
//  Created by Albert on 16/11/20.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    
    // MARK: - PROPERTIES
    private var viewModel = DetailViewModel()
    private var router = DetailRouter()
    private var disposeBag = DisposeBag()
    
    var characterId: Int?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - OUTLETS
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!{
        didSet {
            activityIndicatorView.color = Color.blue
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
        }
    }
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.text = nil
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = nil
        }
    }
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientBackground(from: Color.darkBlue, to: Color.blue)
        
        viewModel.bind(viewController: self, router: router)
        
        getCharacterDetail()
    }
    
    private func getCharacterDetail() {
        self.activityIndicatorView.isHidden = false
        self.activityIndicatorView.startAnimating()
        
        guard let id = characterId else { return }
        
        
        return viewModel.getCharacterData(id: id)
            .subscribe { character in
                self.showCharacterDetail(character: character[0])
            } onError: { error in
                print(error)
            }.disposed(by: disposeBag)
    }
    
    private func showCharacterDetail(character: CharacterDetail) {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
            self.nameLabel.text = character.name.uppercased()
            self.descriptionLabel.text = !character.description.isEmpty ? character.description : "No description found."
            if let url = URL(string: character.image.fullPath) {
                self.characterImageView.load(url: url)
                if character.image.fullPath.contains("image_not_available") {
                    self.characterImageView.contentMode = .scaleToFill
                }
            }
        }
    }
    
    private func setGradientBackground(from: UIColor, to: UIColor) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [from.cgColor, to.cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
}
