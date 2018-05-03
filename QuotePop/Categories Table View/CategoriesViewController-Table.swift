//
//  CategoriesViewController-Table.swift
//  QuotePop
//
//  Created by Alec Charbonneau on 4/15/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import UIKit
import CoreData


class CategoriesViewController_Table: CustomBackgroundViewController {

    // MARK: Instance Properties
    var currentTextField: UITextField?
    var categoryObjects: [Category?] = []
    private var currentlyEditing: Bool = false

    // MARK: Core Data
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    lazy var context = container?.viewContext
    
    // MARK: IB Outlets and Actions
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBAction func editAction(_ sender: Any) {
        startStopEditing()
    }
    @IBOutlet var cloudsBackground: [UIImageView]!
    @IBAction func addCloudButton(_ sender: Any) {
        guard tableView.visibleCells.count < 4 else {
            let alert = UIAlertController(title: "Max of 4 titles allowed", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
            present(alert,animated: true)
            return
        }
        let destinationAdd = IndexPath(row: self.categoryObjects.count, section:0)
        self.categoryObjects.insert(nil,at: self.categoryObjects.count)
        self.tableView.insertRows(at: [destinationAdd], with: .bottom)
    }
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.dragDelegate = self
        self.tableView.dragInteractionEnabled = true
        self.tableView.dropDelegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)

        self.categoryObjects = Category.fetchAllCategories(with: context!)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var counter = 1.0
        var counter2:Double = 1.0
        for cloud in cloudsBackground{
            let yOffset = 20.0
            let duration: Double = 1.5
            let centerY = cloud.center.y
            UIView.animate(withDuration: duration*counter2, delay: 0, options: [.repeat,.autoreverse], animations: {
                cloud.center.y += CGFloat(yOffset * counter)
            }, completion: { check in
                cloud.center.y = centerY
            })
            counter *= -1
            counter2 *= 1.5
        }
    }
    
    // MARK: Gesture Functions
    @objc func deleteCloud(_ sender: UITapGestureRecognizer){
        
        let alert = UIAlertController(title: "My Alert", message: "Deleting will remove quote data as well. Continue?", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { (action) in
            //delete cloud
            if let cell = (sender.view as? UIImageView)?.superview?.superview as? CloudTableViewCell{
                var location = 0
                for category in self.categoryObjects{
                        if category == cell.currentCategory {
                            let destination = IndexPath(item: location, section: 0)
                            self.tableView.performBatchUpdates({
                                self.categoryObjects.remove(at: destination.item)
                                self.tableView.deleteRows(at: [destination], with: .fade)
                                if let currentCategory = cell.currentCategory{
                                    let _ = Category.delete(category: currentCategory,with: self.context!)
                                }
                                return
                            }, completion: nil)
                            return
                        }
                    location += 1
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer){
        if currentlyEditing, let currentTF = currentTextField {
            currentTF.resignFirstResponder()
            startStopEditing()
        }
    }
    @objc func tapCloud(_ sender: UITapGestureRecognizer){
        if currentlyEditing { return }
        guard sender.state == .ended else{ return }
        if let cell = (sender.view as? UIImageView)?.superview?.superview as? CloudTableViewCell{
            guard cell.currentCategory != nil else { return;}
            performSegue(withIdentifier: "Show Collection Segue", sender: cell)
        }
    }
    @objc func startStopEditing(){
        
        if !currentlyEditing { // start editing
            for i in 0..<categoryObjects.count{
                let indexPath = IndexPath(row: i, section: 0)
                if let cell = tableView.cellForRow(at: indexPath) as? CloudTableViewCell{
                    cell.cloudTitle.isUserInteractionEnabled = true
                    cell.cloudTitle.textDragInteraction?.isEnabled = false
                    cell.shakeCloud(i)
                    cell.xButton.isHidden = false
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .allowUserInteraction, animations: {
                        cell.xButton.alpha = 1.0
                    }, completion:{ check in
                        self.currentlyEditing = true
                    })
                    self.editButton.title = "Done"
                }
            }
        }else { // stop editing
            
            for i in 0..<categoryObjects.count{
                let indexPath = IndexPath(row: i, section: 0)
                if let cell = tableView.cellForRow(at: indexPath) as? CloudTableViewCell{
                    
                    cell.cloudTitle.isUserInteractionEnabled = false
                    
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .allowUserInteraction, animations: {
                        cell.xButton.alpha = 0.0
                        
                    }, completion:{ _ in
                        self.currentlyEditing = false
                        cell.xButton.isHidden = true
                    })
                    cell.stopCloud()
                    self.editButton.title = "Edit"
                }
            }
        }
    }
    
    private func addOrUpdateCategory(for cell: CloudTableViewCell, with text: String){
        guard let newTitle = cell.cloudTitle.text else {return}
        // adding new category when done editing, if new cloud
        if cell.currentCategory == nil {
            let _ = Category.insertCategory(withTitle: newTitle, with: context!)
        }
        else {
            let _ = Category.updateCategoryTitle(with: newTitle, for: cell.currentCategory!, with: context!)
        }
        categoryObjects = Category.fetchAllCategories(with: context!)
        tableView.reloadData()
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Collection Segue"{
            if let cell = sender as? CloudTableViewCell{
                if let cvc = segue.destination as? ViewController_CloudCollection{
                    cvc.title = cell.currentCategory?.title ?? nil
                    cvc.currentCategory = cell.currentCategory ?? nil
                }
            }
        }
    }
}

extension CategoriesViewController_Table: UITableViewDragDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let provider = NSItemProvider()
        let item = UIDragItem(itemProvider: provider)
        item.localObject = categoryObjects[indexPath.item]
        return [item]
    }
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let dragPreview = UIDragPreviewParameters()
        if let cell = tableView.cellForRow(at: indexPath) as? CloudTableViewCell{
            let cloudX = cell.cloudImageView.frame.midX - cell.cloudImageView.frame.size.width/2
            let cloudY = cell.cloudImageView.frame.midY - cell.cloudImageView.frame.size.height/2
            let rect = CGRect(x:cloudX,y:cloudY,width: cell.cloudImageView.frame.size.width ,height:cell.cloudImageView.frame.size.height)
            dragPreview.visiblePath = UIBezierPath(ovalIn: rect)
            return dragPreview
        }
        return dragPreview
    }
}

extension CategoriesViewController_Table: UITableViewDropDelegate{
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil{
            if tableView.hasActiveDrag {
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        }
        return UITableViewDropProposal(operation: .forbidden)
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = categoryObjects[sourceIndexPath.row]
        self.categoryObjects.remove(at: sourceIndexPath.row)
        self.categoryObjects.insert(item,at: destinationIndexPath.item)
    }
    func tableView(_ tableView: UITableView, dropSessionDidEnd session: UIDropSession) {
        return
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        return
    }
}

extension CategoriesViewController_Table:  UITextDropDelegate{
    func textDroppableView(_ textDroppableView: UIView & UITextDroppable, proposalForDrop drop: UITextDropRequest) -> UITextDropProposal {
        return UITextDropProposal(operation: .forbidden)
    }
}

extension CategoriesViewController_Table: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        textField.becomeFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let cell = textField.superview?.superview as? CloudTableViewCell, let text = cell.cloudTitle.text{
            addOrUpdateCategory(for: cell, with: text)
            if text == "" { cell.cloudTitle.placeholder = nil }
        }
        currentTextField = nil
        if currentlyEditing {startStopEditing()}
        return true
    }
}

extension CategoriesViewController_Table: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return categoryObjects.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCloud))
        let deleteTap = UITapGestureRecognizer(target: self, action: #selector(deleteCloud))
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cloudCell", for: indexPath) as? CloudTableViewCell {
            //text field
            cell.currentCategory = categoryObjects[indexPath.row]
            cell.cloudTitle.text = (cell.currentCategory == nil ? nil:cell.currentCategory!.title)
            cell.cloudTitle.font = UIFont(name: "Chewy", size: 30)
            cell.cloudTitle.isUserInteractionEnabled = false
            cell.cloudTitle.delegate = self
            cell.cloudTitle.textDropDelegate = self
            // if new cloud, clicking adds text
            if cell.currentCategory == nil {
                cell.cloudTitle.placeholder = "add text"
                cell.cloudTitle.isUserInteractionEnabled = true
            }
            //cloud image
            cell.cloudImageView.addGestureRecognizer(tap)
            //cell.cloudImageView.addGestureRecognizer(longPress)
            //cloud xbutton
            cell.xButton.addGestureRecognizer(deleteTap)
            cell.xButton.isHidden = !currentlyEditing
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 6
    }
}

class CustomBackgroundViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        let firstColor = #colorLiteral(red: 0.1133431992, green: 0.6134342209, blue: 1, alpha: 1).cgColor
        let secondColor = #colorLiteral(red: 0.9467305226, green: 0.7825827875, blue: 1, alpha: 0.5221800086).cgColor
        gradientLayer.colors = [firstColor,secondColor]
        gradientLayer.locations = [0.1,0.8]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
}



