//
//  ViewController.swift
//  Notes
//
//  Created by Daniyar Merekeyev on 16.04.2023.
//

import UIKit

class NotesViewController: UIViewController, AddNoteViewControllerDelegate {
    func addNoteViewController(_ controller: AddNoteViewController, added newNote: Note) {
        let newRowIndex = Note.notes.count
        Note.notes.append(newNote)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        collectionView.insertItems(at: [indexPath])
        
        navigationController?.popViewController(animated: true)
    }
    
    func addNoteViewController(_ controller: AddNoteViewController, edited note: Note) {
        if let index = Note.notes.firstIndex(of: note) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) {
                configureCell(for: cell, with: note)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    let searchController = UISearchController(searchResultsController: nil)
    var filteredNotes: [Note] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getNotes()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search note"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        
        if let layout = collectionView?.collectionViewLayout as? NotesLayout {
            layout.delegate = self
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddNote" {
            let controller = segue.destination as! AddNoteViewController
            controller.delegate = self
        } else if segue.identifier == "ShowEditNote" {
            let controller = segue.destination as! AddNoteViewController
            controller.delegate = self
            
            if let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell) {
                controller.noteToEdit = Note.notes[indexPath.row]
            }
        }
    }
    
    func configureCell(for cell: UICollectionViewCell, with note: Note) {
        let titleLabel = cell.viewWithTag(1000) as! UILabel
        let textLabel = cell.viewWithTag(1001) as! UILabel
        let timeLabel = cell.viewWithTag(1002) as! UILabel
        titleLabel.text = note.title
        textLabel.text = note.text
        timeLabel.text = note.time
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredNotes = Note.notes.filter { (note: Note) -> Bool in
        return note.title.lowercased().contains(searchText.lowercased())
      }
      
      collectionView.reloadData()
    }
}

extension NotesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredNotes.count
        }
        
        return Note.notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCollectionViewCell", for: indexPath) as! NoteCollectionViewCell
        let note: Note
        
        if isFiltering {
            note = filteredNotes[indexPath.row]
        } else {
            note = Note.notes[indexPath.row]
        }
        
        configureCell(for: cell, with: note)
        cell.layer.cornerRadius = 20
    
        return cell
    }
}

extension NotesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider: { suggestedActions in
            return UIMenu(children: [
                UIAction(title: "Remove", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    Note.notes.remove(at: indexPath.item)
                    collectionView.reloadData()
                    deleteNote(index: indexPath.row)
                }
            ])
        })
    }
}

extension NotesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

extension NotesViewController: NotesLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForTextAtIndexPath indexPath: IndexPath) -> CGFloat {
        return heightForView(text: Note.notes[indexPath.item].text, font: UIFont.systemFont(ofSize: 17), width: (UIScreen.main.bounds.width - 20) / 2 - 3 - 16 - 10) + 100
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
}
