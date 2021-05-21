//
//  ChatViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 5/20/21.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let db = Firestore.firestore()
    
    var messages : [Message] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.Chat.cellNibName, bundle: nil), forCellReuseIdentifier: K.Chat.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages(){
        db.collection(K.Chat.FStore.collectionName)
            .order(by: K.Chat.FStore.dateField)
            .addSnapshotListener{ (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.Chat.FStore.senderField] as? String, let messageBody = data[K.Chat.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func sendPressed(_ sender: Any) {
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email{
            db.collection(K.Chat.FStore.collectionName).addDocument(data: [
                K.Chat.FStore.senderField: messageSender,
                K.Chat.FStore.bodyField: messageBody,
                K.Chat.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error{
                    print("There was an issue saving data to firestore, \(e)")
                }else{
                    print("Successfully save data")
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
          try Auth.auth().signOut()
            //navigate user to welcome screen
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    //ask us for a UITableViewCell it should display in each row
    //We have to create a cell and return it
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Chat.cellIdentifier, for: indexPath) as! MessageCell
        //customize the cell before return
        //indexPath: cell position in table: session# and row#
        cell.label.text = messages[indexPath.row].body
        return cell
    }
}
