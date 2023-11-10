//
//  CreateAccountScreenViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 26/10/23.
//

import Foundation

struct AccountDescriptionStruct: Codable {
    var fields: [String:AccountField]
}

struct AccountField: Codable {
    var label: String
    var name: String
    var length: Int
    var type: String
    var defaultValue: String? = "default"
    var precision: Int
    var scale: Int
    var picklistValues: [PicklistValue?] = []
}

struct PicklistValue: Codable {
    var label: String?
    var value: String?
    var active: Bool
}

struct CreateAccountStruct: Codable {
    var account_id: String
}

struct EditAccountRespStruct: Codable {
}

class CreateAccountScreenViewModel: ObservableObject {
    @Published var accountFields = AccountDescriptionStruct(fields: [:])
    @Published var isCreateAccountInProgress = false
    
    var apiService = DependencyContainer.shared.apiService
    
    func fetchAccountFields(onSuccess: @escaping() -> Void) {
        guard accountFields.fields.count == 0 else {
            onSuccess()
            return
        }
        
        apiService.get(type: AccountDescriptionStruct.self, endpoint: "/v1/accounts/describe") {
            [weak self] result, _ in
            print(result)
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.accountFields.fields = results.fields
                    onSuccess()
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func createAccount(selectedValuesMap: [String: String], onSuccess: @escaping(String) -> Void, onFailure: (() -> Void)?){
        
        guard !self.isCreateAccountInProgress else {
            return
        }
        self.isCreateAccountInProgress = true
        
        apiService.post(type: CreateAccountStruct.self, endpoint: "/v1/accounts", params: selectedValuesMap) {
            [weak self]  result, _ in
            switch result {
            case .success(let results):
                DispatchQueue.main.async {
                    onSuccess(results.account_id)
                    self?.isCreateAccountInProgress = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .success, message: "Account Saved"))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    onFailure?()
                    print("error loading data: \(error)")
                    self?.isCreateAccountInProgress = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
        }
    }
    
    func editAccount(accountId: String, selectedValuesMap: [String: String], onSuccess: (() -> Void)?, onFailure: (() -> Void)?){
        
        guard !self.isCreateAccountInProgress else {
            return
        }
        self.isCreateAccountInProgress = true
        

        apiService.put(type: EditAccountRespStruct.self, endpoint: "/v1/accounts/\(accountId)", params: selectedValuesMap) {
            [weak self]  result, _ in
            switch result {
            case .success(let results):
                DispatchQueue.main.async {
                    onSuccess?()
                    self?.isCreateAccountInProgress = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .success, message: "Account Updated"))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    onFailure?()
                    print("error loading data: \(error)")
                    self?.isCreateAccountInProgress = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
        }
    }
}
