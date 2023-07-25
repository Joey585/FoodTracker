//
//  Database.swift
//  foodTracker
//
//  Created by Joey Lieb on 7/24/23.
//

import Foundation
import SQLite3

class Database {
    var db: OpaquePointer?
    var dbPath = "Tags.sqlite"

    
    init() {
        
        db = openDatabase()
        
       
    }
    
    private func openDatabase() -> OpaquePointer?{
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
        
        var db:OpaquePointer? = nil
    
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return nil
        } else {
            print("Created database")
            return db
        }
    }
    
    private func createTable() {
        let tableString = "CREATE TABLE IF NOT EXISTS Tags(id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT)"
        var tableStatement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, tableString, -1, &tableStatement, nil) == SQLITE_OK {
            if sqlite3_step(tableStatement) == SQLITE_DONE {
                print("table created")
            } else {
                print("failed to make table")
            }
        }
        sqlite3_finalize(tableStatement)
    }
    
    public func createTag(tag:String){
        
        let tags = getAllTags()
        for tagContent in tags {
            if tagContent == tag {
                return
            }
        }
        
        let insertStatement = "INSERT INTO Tags (content) VALUES (?)"
        var stmt: OpaquePointer?
        
        print(tag)
        
        if sqlite3_prepare_v2(db, insertStatement, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, (tag as NSString).utf8String, -1, nil)
            
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Sucessfully inserted row")
            } else {
                print("Failed to insert")
            }
        }
        
        sqlite3_finalize(stmt)
    }
    
    public func getAllTags() -> Array<String> {
        var array:Array<String> = []
        let query = "SELECT * FROM Tags"
        var stmt:OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK{
            while sqlite3_step(stmt) == SQLITE_ROW{
                let content = String(describing: String(cString: sqlite3_column_text(stmt, 1)))
                array.append(content)
                print("Query Result\n\(content)")
            }
        } else {
            print("Could not prepare statement")
        }
        
        sqlite3_finalize(stmt)
        return array
    }
    
    public func clearDatabase(){
        let query = "DELETE FROM Tags WHERE content LIKE ''"
        var stmt:OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Cleared Database")
            }
        }
    }
}
