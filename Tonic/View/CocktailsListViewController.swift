//
//  CocktailsListViewController.swift
//  Tonic
//

import Foundation
import UIKit

protocol CocktailsListView: Alertable {
    
    /// Reloads cocktails table.
    func reload()
    
    /// Show reload button (no data).
    func showReloadButton()
}

class CocktailsListViewController: UIViewController {
    
    // MARK: - Properties: private
    
    private let interactor: CocktailsListInteractor
    
    private lazy var cocktailsTableView = CocktailsUI.cocktailsTableView
    private lazy var reloadButton = CocktailsUI.reloadButton(target: self, action: #selector(reloadData))
        
    // MARK: - Init
    
    init(interactor: CocktailsListInteractor) {
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Methods: private
    
    private func setupViews() {        
        view.backgroundColor = .systemBackground
        
        title = NSLocalizedString("cocktails.title", comment: "")
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.cocktailMediumWithSize(size: 17)
        ]
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.cocktailBoldWithSize(size: 30)
        ]
                
        navigationController?.navigationBar.prefersLargeTitles = true
        
        cocktailsTableView.dataSource = self
        cocktailsTableView.delegate = self
        
        reloadButton.isHidden = true
        
        interactor.load()
    }
    
    private func setupConstraints() {
        view.addSubview(cocktailsTableView)
        
        cocktailsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cocktailsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cocktailsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cocktailsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            cocktailsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.addSubview(reloadButton)
        
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reloadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            reloadButton.widthAnchor.constraint(equalToConstant: 250),
            reloadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc
    private func reloadData() {
        interactor.load()
    }
}

// MARK: - CocktailsListViewController + UITableViewDataSource

extension CocktailsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        interactor.numberOfCocktails()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CocktailsListCell.reuseIdentifier, for: indexPath) as? CocktailsListCell else {
            fatalError("Unexpected cell")
        }
        
        let cocktail = interactor.cocktail(at: indexPath)
        cell.configure(with: cocktail)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let item = cell as? CocktailsListCell else {
            return
        }
        
        let cocktail = interactor.cocktail(at: indexPath)
        
        item.download(with: cocktail)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}

// MARK: - CocktailsListViewController + UITableViewDelegate

extension CocktailsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.selectCocktail(at: indexPath)
    }
}

// MARK: - CocktailsListViewController + CocktailsListView

extension CocktailsListViewController: CocktailsListView {
    
    func reload() {
        title = NSLocalizedString("cocktails.title", comment: "")
        
        if !reloadButton.isHidden {
            cocktailsTableView.isHidden = false
            reloadButton.isHidden = true
        }
        
        cocktailsTableView.reloadData()
    }
    
    func showReloadButton() {
        title = ""
        
        if !cocktailsTableView.isHidden {
            cocktailsTableView.isHidden = true
        }
        
        reloadButton.isHidden = false
    }
}
