//
//  NoteCollectionViewCell.swift
//  Notes
//
//  Created by Daniyar Merekeyev on 16.04.2023.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var time: UILabel!
    
    func configureCell(with note: Note) {
        title.text = note.title
        text.text = note.text
        time.text = note.time
    }
}
