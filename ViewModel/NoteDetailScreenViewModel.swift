//
//  NoteDetailScreenViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 11/08/23.
//

import Foundation

// A struct that represents the meta data of the note details API
struct NoteDetailRespStruct: Codable {
    var note_detail: NoteDetailStruct
}

// A struct that represents the meta data of the note details
struct NoteDetailStruct : Codable {
    var id: String
    var creator: String
    var text: String
    var last_modified_time: String
}

// A class that represents the view model of Note details
class NoteDetailScreenViewModel: ObservableObject {
    @Published var noteDetail = NoteDetailStruct(id: "", creator: "", text: "", last_modified_time: "")
    @Published var isFetchNoteDetailInProgress = false
    @Published var errorMessage = ""
    var apiService = DependencyContainer.shared.apiService
    
    // A function to fetch note details using API.
    func fetchNoteDetail(accountId: String, noteId: String){
        let endPoint = "/v1/accounts/\(accountId)/notes/\(noteId)"
        isFetchNoteDetailInProgress = true
        
        apiService.get(type: NoteDetailRespStruct.self, endpoint: endPoint){
            [weak self] result, statusCode in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.errorMessage = ""
                    self?.noteDetail = results.note_detail
                    self?.isFetchNoteDetailInProgress = false
                case .failure(let error):
                    self?.isFetchNoteDetailInProgress = false
                    self?.errorMessage = error.message
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
        }
    }
    
}
