import UIKit

class DataSourceDelegate : NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let identifier = "identifier"
    
    var deleteCallback: (String, () -> ()) -> () = { _, _ in return }
    
    var data: [(String, String)] = []
    
    func register(tableView: UITableView, deleteCallback: (String, () -> ()) -> ()) {
        self.deleteCallback = deleteCallback
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) ?? UITableViewCell()
        cell.textLabel?.text = data[indexPath.row].1
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let id = self.data[indexPath.row].0
        self.deleteCallback(id) {
            self.data.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

class NoteAdder {
    func addNote(callback: (String) -> ()) -> UIAlertController {
        let alertController = UIAlertController(title: "New note", message: "Please write:", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "note here"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in return }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            guard let text = alertController.textFields?.first?.text else { return }
            callback(text)
        }
        alertController.addAction(OKAction)
        return alertController
    }
}

class ViewController: UITableViewController {
    
    let dataSourceDelegate = DataSourceDelegate()
    let noteAdded = NoteAdder()
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        super.init(nibName: nil, bundle: nil)
        self.refreshControl = {
            let rc = UIRefreshControl()
            rc.addTarget(self, action: #selector(ViewController.refreshData), forControlEvents: .ValueChanged)
            return rc
        }()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("ViewController: not supported") }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Notes"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ViewController.addNote))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: #selector(ViewController.removeNote))
        self.dataSourceDelegate.register(self.tableView) { [weak self] id, callback in
            guard let `self` = self else { return }
            self.apiClient.removeData(id) { [weak self] in
                callback()
                self?.tableView.setEditing(false, animated: true)
                self?.refreshData()
            }
            
        }
        self.refreshData()
    }
    
    func refreshData() {
        self.refreshControl?.beginRefreshing()
        self.apiClient.fetchAllData { [weak self] data in
            self?.refreshControl?.endRefreshing()
            self?.dataSourceDelegate.data = data
            self?.tableView.reloadData()
        }
    }
    
    func addNote() {
        let alert = self.noteAdded.addNote() { [weak self] title in
            guard let `self` = self else { return }
            self.apiClient.postData(title) { [weak self] in
                guard let `self` = self else { return }
                self.refreshData()
            }
        }
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    func removeNote() {
        let editing = !tableView.editing
        self.tableView.setEditing(editing, animated: true)
    }
}

