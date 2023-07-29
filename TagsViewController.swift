//
//  TagsViewController.swift
//  foodTracker
//
//  Created by Joey Lieb on 7/24/23.
//

import UIKit

protocol TagsSubmit {
    func submittedData(selectedTags:Array<String>)
}

class TagsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var foodImageTemp:UIImage!
    let defaults = UserDefaults.standard

    @IBOutlet weak var tagInput: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tagOutput: UITextView!
    var delegate:TagsSubmit!
    
    
    let tagsDB = Database()
    var selectedTags:Array<String> = []
    
    
    override func viewDidLoad() {
        
        print(tagsDB.getAllTags().count)
        tagsDB.clearDatabase()
        tableView.delegate = self
        tableView.dataSource = self
        tagInput.delegate = self
        
        tagOutput.isSelectable = false
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagsDB.getAllTags().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath)
        let tags = tagsDB.getAllTags()
        cell.accessoryType = .none
        
        cell.textLabel?.text = tags[indexPath.row]
        return cell
    }
    
    @IBAction func addTagButton(_ sender: Any) {
        let tagsContent = tagInput.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if tagsContent!.isEmpty {
            return
        }
        
        tagsDB.createTag(tag: tagsContent!)
        tagInput.text = ""
        selectedTags.append(tagsContent!)
        updateTagList()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellClicked = tableView.cellForRow(at: indexPath)
        if cellClicked?.accessoryType == .checkmark {
            cellClicked?.accessoryType = .none
            selectedTags.remove(at: selectedTags.firstIndex(of: tagsDB.getAllTags()[indexPath.row])!)
        } else {
            cellClicked?.accessoryType = .checkmark
            selectedTags.append(tagsDB.getAllTags()[indexPath.row])
        }
        
        updateTagList()
    }
    
    func updateTagList(){
        print(selectedTags)
        let newString = selectedTags.joined(separator: ", ")
        print(newString)
        tagOutput.text = "Tags: " + newString
    }

    @IBAction func completeTagsButton(_ sender: Any) {
        if let foodView = presentingViewController as? FoodSubmittedViewController {
            foodView.tagList = selectedTags
        }
        self.dismiss(animated: true)
    }
}
