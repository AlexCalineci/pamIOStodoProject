
import UIKit

class TodoListViewController: UITableViewController {
    
    static var todos: [Todo] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload todos from JSON file
        loadTodos()
        
        // Reload table view data
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTodos()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoListViewController.todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let todo = TodoListViewController.todos[indexPath.row]
        cell.textLabel?.text = todo.title
        cell.accessoryType = todo.completed ? .checkmark : .none
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let destinationVC = segue.destination as! TodoDetailViewController
            destinationVC.todosNew = TodoListViewController.todos
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.todo = TodoListViewController.todos[indexPath.row]
                
                destinationVC.todoIndex = indexPath.row
            }
        }
    }

    @IBAction func addTodo() {
        performSegue(withIdentifier: "showDetail", sender: nil)
    }

    // MARK: - Helper methods
    func loadTodos() {
        guard let url = Bundle.main.url(forResource: "todos", withExtension: "json") else {
            return
        }
        print("Load url \(url.path)")
        do {
            let data = try Data(contentsOf: url)
            TodoListViewController.todos = try JSONDecoder().decode([Todo].self, from: data)
        } catch {
            print(error)
        }
    }

}
