//
//  AccountDetailScreenViewModel.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 10/08/23.
//

import Foundation
import SwiftUI
import CoreData

struct Note: Identifiable, Codable {
    let id: String
    let creator: String
    let text_preview: String
    let last_modified_time: String
}

struct NotesListStruct: Codable {
    var note_ids: [String]
    var note_map_by_id: [String: Note]
}

// A class that represents the view model of the list
class AccountDetailViewScreenViewModel: ObservableObject {
    @Published var NotesData = NotesListStruct(note_ids: [], note_map_by_id: [:])
    @Published var isLoading = false
    
    // A function that fetches the data for the list
    func fetchNotes(accountId: String){
        guard !self.isLoading else {
            return
        }
        
        //TODO: Remove this dummy data once api is available
        self.NotesData.note_ids = ["1","2","3"]
        
        self.NotesData.note_map_by_id = [
            "1": Note(id: "1", creator: "UserA", text_preview: "This is note 1", last_modified_time: "2019-10-12T07:20:50.52Z"),
            "2": Note(id: "2", creator: "User B", text_preview: "This is note 2.\nThis is very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very long text", last_modified_time: "2019-10-12T07:20:50.52Z"),
            "3": Note(id: "3", creator: "Alex Zu", text_preview: "This is note 3", last_modified_time: "2019-10-12T07:20:50.52Z")
        ]
        
        ApiService().get(type: NotesListStruct.self, endpoint: "/v1/accounts/\(accountId)/notes"){
            [weak self]  result, statusCode in
            switch result {
            case .success(let results):
                DispatchQueue.main.async {
                    self?.NotesData.note_ids = results.note_ids
                    self?.NotesData.note_map_by_id = results.note_map_by_id
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("error loading data: \(error)")
                    self?.isLoading = false
                }
            }
            
        }
    }
    
    // A function that resets the data for the list
    func resetData(){
        self.NotesData = NotesListStruct(note_ids: [], note_map_by_id: [:])
    }
}
