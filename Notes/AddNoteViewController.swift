//
//  AddNoteViewController.swift
//  Notes
//
//  Created by Daniyar Merekeyev on 02.04.2023.
//

import UIKit

protocol AddNoteViewControllerDelegate: AnyObject {
    func addNoteViewController(_ controller: AddNoteViewController, added newNote: Note)
    func addNoteViewController(_ controller: AddNoteViewController, edited note: Note)
}

class AddNoteViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textTextView: UITextView!
    
    let alert = UIAlertController(title: "Oops...", message: "You didn't changed text!", preferredStyle: .alert)
    
    weak var delegate: AddNoteViewControllerDelegate?
    var noteToEdit: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let note = noteToEdit {
            titleTextField.text = note.title
            textTextView.text = note.text
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default))
    }
    
    @IBAction func done() {
        titleTextField.endEditing(true)
    }
    
    @IBAction func addNote() {
        if let note = noteToEdit {
            note.title = titleTextField.text!
            note.text = textTextView.text
            delegate?.addNoteViewController(self, edited: note)
        } else {
            if titleTextField.text! == "New Title" || textTextView.text == "New note" {
                self.present(alert, animated: true)
            } else {
                let note = Note(title: titleTextField.text!, text: textTextView.text, time: dateFormatter(date: Date.now))
                Notes.addNote(getTitle: note.title, getText: note.text, getTime: dateFormatter(date: Date.now))
                delegate?.addNoteViewController(self, added: note)
            }
        }
    }
}
