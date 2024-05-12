//
//  Authentication.swift
//  NapWorks
//
//  Created by STC on 11/05/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
class AuthServices{
    public static let shared = AuthServices()
    private init(){}
    public func registerUser(with userrequest:registerUserRequest,completion:@escaping (Bool,Error?)->Void){
        let username = userrequest.userName
        let email = userrequest.email
        let password = userrequest.password
        Auth.auth().createUser(withEmail: email, password: password){
            result,error in
            if let error = error{
                completion(false,error)
                return
            }
            guard let resultuser = result?.user else{
                completion(false,nil)
                return
            }
            let db = Firestore.firestore()
            db.collection("users")
                .document(resultuser.uid)
                .setData(["username":username,"email":email]) { error in
                    if let error = error{
                        completion(false,error)
                        return
                    }
                    completion(true,nil)
                }
        }
    }
    
    public func signOut(completion:@escaping (Error?)->Void){
        do{
            try Auth.auth().signOut()
            completion(nil)
        }catch let error{
            completion(error)
        }
    }
    public func fetchUser(completion : @escaping(user?,Error?)-> Void){
        guard let userID = Auth.auth().currentUser?.uid else{return}
        let db = Firestore.firestore()
        db.collection("users")
            .document(userID)
            .getDocument { snapshot, error in
                if let error = error{
                    completion(nil,error)
                    return
                }
                if let snapshot = snapshot,
                let snapshotData = snapshot.data(),
                let username = snapshotData["username"] as? String,
                let email = snapshotData["email"] as? String{
                    let user = user(username: username, userEmail: email, userId: userID)
                    completion(user,nil)
                }
                
            }
    }
}
