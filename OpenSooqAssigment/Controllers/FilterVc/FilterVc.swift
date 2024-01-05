//
//  FilterVc.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 28/12/2023.
//

import UIKit
import RealmSwift

class FilterVc: UIViewController {
    
    private var categoryId: Int = 0
    private var searchFlow: SearchFlow?
    private var attributes: AttributesOptionsData?
    private var cellsType: [String] = []
    private var fieldLabels = List<FieldsLabel>()
    private var feilds =  List<AttributesOptionsData>()
    private var options = List<Option>()
    private var sectionTitle: [String] = []
    private var sectionData: [Item]?
    private var fullModels: [FullModel] = []
    private var categoriesAllowed: Set<String> = ["list_string","list_string_icon","list_numeric"]

    let viewModel = FilterViewModel()
    var isLoading: Bool = false

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomOuterCollectionViewCell.self, forCellWithReuseIdentifier: "CustomOuterCollectionViewCell")
        collectionView.register(NumericCollectionViewCell.self, forCellWithReuseIdentifier: "NumericCollectionViewCell")
        return collectionView
    }()
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(categoryId: Int) {
          super.init(nibName: nil, bundle: nil)
        self.categoryId = categoryId
      }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpSections()
        fetchData()
    }
    
    private func setUpViews() {
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    private func setUpSections() {
        if let unwrappedArray = searchFlow?.order {
            for (index, element) in unwrappedArray.enumerated() {
                let newSectionItems: Item = Item(section: index, sectionName: element)
                sectionData?.append(newSectionItems)
            }
        }
    }
    
    private func fetchData() {
        
        LoadingViewManager.showLoader(in: self)
        
        viewModel.onAttributesUpdate = {[weak self] attr,fields, options in
            guard let strongSelf = self else { return }
            strongSelf.searchFlow = attr
            strongSelf.attributes = options
            strongSelf.fieldLabels = fields
            strongSelf.getFilterByOrder(orders: attr.order)
        }
        
        viewModel.onLoadingStateChanged = {[weak self] isLoading in
            guard let strongSelf = self else { return }
            strongSelf.isLoading = isLoading
            DispatchQueue.main.async {
                if !isLoading {
                    LoadingViewManager.hideLoader(in: strongSelf)
                }
            }
        }
        
        viewModel.onError = { [weak self] error in
            guard let strongSelf = self else { return }
            AlertManager.showAlert(in: strongSelf, title: "Error!", message: "\(error.localizedDescription)")
        }
        viewModel.fetchData(categoryId: categoryId)
    }


    func getFilterByOrder(orders: List<String>) {
        for order in orders {
            guard let field = self.attributes?.fields.first(where:{$0.name == order}) else { return }
            
            let dataType = field.dataType
            let id = field.id 
            
            let label = getFilteredLabel(order: order)
            self.sectionTitle.append(label)

            let options = getFilteredOptions(id: id)
            let model = FullModel(title: label, options: options)
            if categoriesAllowed.contains(dataType)  {
                cellsType.append(dataType)
                fullModels.append(model)
            }
        }
        self.updateUI(for: self.collectionView)
    }
    
    private func getFilteredLabel(order: String)-> String {
        if let label = self.fieldLabels.first(where:{$0.fieldName == order})?.labelEn {
            return label
        } else {
            return ""
        }
    }
    
    private func getFilteredOptions(id: Int)-> List<Option> {
        guard let options = self.attributes?.options.filter({ $0.fieldID == String(id) }) else {
            return List<Option>()
        }
        
        let optionList = List<Option>()
        optionList.append(objectsIn: options)
        return optionList
    }
    
    private func getCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = cellsType[indexPath.section]
        switch cellType {
        case "list_string_icon":
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomOuterCollectionViewCell", for: indexPath) as? CustomOuterCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.setUpCell(fullModel: fullModels[indexPath.section], type: .icons)
            cell.delegate = self
            return cell
            
        case "list_string":
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomOuterCollectionViewCell", for: indexPath) as? CustomOuterCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setUpCell(fullModel: fullModels[indexPath.section], type: .titles)
            cell.delegate = self
            return cell
            
        case "list_numeric":
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomOuterCollectionViewCell", for: indexPath) as? CustomOuterCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setUpCell(fullModel: fullModels[indexPath.section], type: .numeric)
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension FilterVc: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cellsType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.getCell(indexPath)
        
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellType = cellsType[indexPath.row]
        switch cellType {
        case "list_string_icon":
            return CGSize(width: collectionView.bounds.width, height: 120)
        case "list_string":
            return CGSize(width: collectionView.bounds.width, height: 150)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return sectionInset
    }
}

extension FilterVc: SelectOptionProtocol {
    func didSelect(option: Option) {
        viewModel.addToSelectedCategories(option: option)
    }
}
