//
//  DatabaseManager.swift
//  Sihaty Task
//
//  Created by Admin on 14/08/2021.
//

import Foundation
import CoreData
import SwiftUI

struct DatabaseManager {
    static let shared = DatabaseManager()
    
    private var viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    private init() {
    }
    
    // Store all Repo items fetched from network
    func addRepoListItems(_ items: [Repository]) {
        // Clear all item before storing new
        deleteAllRepositoryItems()
        
        let _:[RepositoryLocal] = items.compactMap { (repo) -> RepositoryLocal in
            let repoItem = RepositoryLocal(context: self.viewContext)
            repoItem.fullName    = repo.fullName
            repoItem.details      = repo.description
            repoItem.fullName    = repo.fullName
            repoItem.language  = repo.language
            
            return repoItem
        }
        
        saveContext()
    }
    
    // Fetch all stored Repo items
    func fetchAllReposItems()->[RepositoryLocal] {
        var result = [RepositoryLocal]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RepositoryLocal")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \RepositoryLocal.fullName, ascending: true)]
        do {
            if let all = try viewContext.fetch(request) as? [RepositoryLocal] {
                result = all
            }
        } catch {
            
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }
    
    // Delete all stored Repo items
    func deleteAllRepositoryItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RepositoryLocal")
        do {
            if let all = try viewContext.fetch(request) as? [RepositoryLocal] {
                for item in all {
                    viewContext.delete(item)
                }
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        saveContext()
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
