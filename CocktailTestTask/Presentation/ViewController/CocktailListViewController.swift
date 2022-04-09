//
//  ViewController.swift
//  CocktailTestTask
//
//  Created by  Егор Шуляк on 29.03.22.
//

import UIKit
import SnapKit

final class CocktailsListViewController: UIViewController {
    private let flowLayout = LeftAlignedCellsCustomFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    private let searchField: UITextField = UITextField().getConfiguredTextFieldForMainScreen()
    private let opacityView: UIView = UIView()
    private let remoteCocktailList: RemoteCocktailsListProtocol?
    
    private var cocktailsList: [Cocktail] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    init(cocktailList: RemoteCocktailsListProtocol) {
        self.remoteCocktailList = cocktailList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let remoteCocktailList = remoteCocktailList else {
            return
        }
        view.backgroundColor = .white
        remoteCocktailList.getCocktailsList(completionHandler: { result in
            self.cocktailsList = result
        })
        
        initializeCollectionView()
        initializeTextField()
        notificationCenterSetup()
    }
    
    private func initializeCollectionView() {
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.minimumLineSpacing = 8
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.register(CocktailCell.self, forCellWithReuseIdentifier: CocktailCell.reuseID)
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func initializeTextField() {
        searchField.delegate = self
        view.addSubview(searchField)
        textFieldOriginalState()
    }
    
    private func textFieldOriginalState() {
        searchField.snp.remakeConstraints { make in
            make.left.equalToSuperview().inset(30)
            make.right.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(100)
            make.height.equalTo(30)
        }
        view.layoutIfNeeded()
        searchField.layer.cornerRadius = searchField.frame.size.height * 0.25
    }
    
    private func notificationCenterSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(sender: NSNotification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            searchField.snp.remakeConstraints { make in
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview().inset(keyboardRectangle.height)
                make.height.equalTo(30)
            }
            view.layoutIfNeeded()
            
            searchField.layer.cornerRadius = 0
            configureOpacityView()
        }
    }
    
    @objc private func keyboardWillHide(sender: NSNotification) {
        opacityView.removeFromSuperview()
        textFieldOriginalState()
    }
    
    private func configureOpacityView() {
        view.addSubview(opacityView)
        opacityView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(searchField.snp.top)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dropKeyboard))
        opacityView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dropKeyboard (_ : Any) {
        searchField.resignFirstResponder()
    }
}

// MARK: - collectionView Delegate and DataSource
extension CocktailsListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cocktailsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CocktailCell.reuseID, for: indexPath) as? CocktailCell
        else { fatalError("worng cell") }
        let strDrink = cocktailsList[indexPath.row].strDrink
        cell.configureCell(cocktailName: strDrink)
        return cell
    }
}

// MARK: - textField delegate
extension CocktailsListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText = textField.text ?? ""
        guard let rangeForReplace = Range(range, in: textFieldText) else { return false }
        let text = textFieldText.replacingCharacters(in: rangeForReplace, with: string).lowercased()
        for (index, item) in cocktailsList.enumerated() {
            let cocktailName = item.strDrink.lowercased()
            let indexPath = IndexPath(row: index, section: 0)
            if cocktailName.contains(text) {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            } else {
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

