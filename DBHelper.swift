//
//  DBHelper.swift
//  Notes
//
//  Created by Daniyar Merekeyev on 02.04.2023.
//

import Foundation
import SQLite

func addNote(getTitle: String, getText: String, getTime: String) {
    do {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        _ = copyDatabaseIfNeeded(sourcePath: Bundle.main.path(forResource: "Notes", ofType: "db")!)
        let db = try Connection("\(path)/Notes.db")
        let notes = Table("Notes")
        let title = Expression<String>("title")
        let text = Expression<String>("text")
        let time = Expression<String>("time")
        try db.run(notes.insert(title <- getTitle, text <- getText, time <- getTime))
    } catch {
        print(error)
    }
}

func getNotes() {
    do {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        _ = copyDatabaseIfNeeded(sourcePath: Bundle.main.path(forResource: "Notes", ofType: "db")!)
        let db = try Connection("\(path)/Notes.db")
        let notes = Table("Notes")
        let title = Expression<String>("title")
        let text = Expression<String>("text")
        let time = Expression<String>("time")
        
        for note in try db.prepare(notes) {
            Note.notes.append(Note(title: note[title], text: note[text], time: note[time]))
        }
    } catch {
        print(error)
    }
}

func deleteNote(index: Int) {
    do {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        _ = copyDatabaseIfNeeded(sourcePath: Bundle.main.path(forResource: "Notes", ofType: "db")!)
        let db = try Connection("\(path)/Notes.db")
        let notes = Table("Notes")
        let id = Expression<Int>("id")
        let note = notes.filter(id == index + 1)
        print(index)
        try db.run(note.delete())
    } catch {
        print(error)
    }
}

func copyDatabaseIfNeeded(sourcePath: String) -> Bool {
    let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let destinationPath = documents + "/Notes.db"
    let exists = FileManager.default.fileExists(atPath: destinationPath)
    guard !exists else { return false }
    do {
        try FileManager.default.copyItem(atPath: sourcePath, toPath: destinationPath)
        return true
    } catch {
      print("error during file copy: \(error)")
        return false
    }
}
