//
//  ViewController-CloudCollection.swift
//  QuotePop
//
//  Created by Alec Charbonneau on 4/10/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import UIKit
import CoreData


class ViewController_CloudCollection: CustomBackgroundViewController{
    
    // MARK: instance properties
    let reuseIdentifier = "Cell"
    var smallCharCount = 25
    var medCharCount = 70
    var largeCharCount = 125
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    lazy var context = container?.viewContext
    var currentCategory: Category?
    
    // MARK: outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        if let layout = collectionView.collectionViewLayout as? Cloud_CollectionViewLayout {
            layout.delegate = self
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard currentCategory != nil else { return }
        quoteObjects = Quote.fetchAllQuotes(from: currentCategory!, with: context!) ?? []
    }
    
    // MARK: custom methods
    func getImageSize(for index:Int) -> Int{
        guard let quote = quoteObjects[index].quote else {return 0}
        if quote.count <= smallCharCount { return 0 }
        else if quote.count < medCharCount { return 1 }
        else { return 2 }
    }
    
    // MARK: UICollectionViewDataSource
    var quoteObjects: [Quote] = []
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Quote" {
            if let vc = segue.destination as? ViewQuoteViewController, let cell = sender as? QuotesCollectionViewCell{
                vc.quote = cell.quoteTextView.text
                vc.title = cell.authorTextField.text ?? "Anonymous"
                vc.currentQuoteObject = cell.currentQuoteObject
                vc.indexPath = cell.indexPath!
                vc.delegate = self
            }
        }
        else if segue.identifier == "Add Quote"{
            if let vc = segue.destination as? AddNewQuote_ViewController{
                vc.delegate = self
                vc.modalTransitionStyle = .coverVertical
            }
        }
    }
}

extension ViewController_CloudCollection: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return quoteObjects.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Basic Quote Cell", for: indexPath) as? QuotesCollectionViewCell {
            
            let quoteString = quoteObjects[indexPath.item].quote ?? ""
            if quoteString.count <= smallCharCount {
                cell.cloudImage.image = UIImage(named:"cloud-S")
            } else if quoteString.count < medCharCount {
                cell.cloudImage.image = UIImage(named:"cloud-M")
            } else {
                cell.cloudImage.image = UIImage(named:"cloud-L")!
            }
            cell.indexPath = indexPath
            cell.quoteTextView.text = quoteString
            cell.authorTextField.text = "- " + (quoteObjects[indexPath.item].author ?? "Anonymous")
            cell.currentQuoteObject = quoteObjects[indexPath.item]
            return cell
        }
        let cell = QuotesCollectionViewCell()
        return cell
    }
}

extension ViewController_CloudCollection: CloudLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        let size = getImageSize(for:indexPath.item)
        if size == 0 { return CGFloat(130) }
        else if size == 1 { return CGFloat(175) }
        return CGFloat(250)
    }
}

extension ViewController_CloudCollection: AddQuoteDelegate{
    func addNewQuote(quote: String, by author: String) {
        if let category = currentCategory, let newQuote = Quote.insertQuote(matching: quote, by: author, within: category, with: context!){
                self.quoteObjects.append(newQuote)
                let destinationIndexPath = IndexPath(item: quoteObjects.count-1, section: 0)
                if let layoutObject = self.collectionView.collectionViewLayout as? Cloud_CollectionViewLayout{
                    layoutObject.cache = [UICollectionViewLayoutAttributes]()
                }
                collectionView?.insertItems(at: [destinationIndexPath])
            }
        }
    }

extension ViewController_CloudCollection: UpdateDeleteQuoteDelegate{
    func delete(quote: Quote, at location: IndexPath){
        if Quote.deleteQuote(quote: quote, with: context!){
            quoteObjects.remove(at: location.item)
            if let layoutObject = self.collectionView.collectionViewLayout as? Cloud_CollectionViewLayout{
                layoutObject.cache = [UICollectionViewLayoutAttributes]()
            }
            collectionView.deleteItems(at: [location])
        }
    }
    func update(quote: Quote, toSay: String, at location: IndexPath) {
        if let _ = Quote.update(quote: quote, toSay: toSay, with: context!){
            quoteObjects[location.item] = quote
            if let layoutObject = self.collectionView.collectionViewLayout as? Cloud_CollectionViewLayout{
                layoutObject.cache = [UICollectionViewLayoutAttributes]()
            }
            collectionView.reloadItems(at: [location])
        }
    }
}



