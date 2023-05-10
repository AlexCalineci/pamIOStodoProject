
import UIKit

class TodoDetailViewController: UIViewController {
    
    // curent selected todo
    var todo: Todo?
    //current selected index
    var todoIndex: Int?
    //new todos array wich will be filled with modifications
    var todosNew: [Todo] = []

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var completedSwitch: UISwitch!
    @IBOutlet weak var deleteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let todo = todo {
            titleTextField.text = todo.title
            completedSwitch.isOn = todo.completed
            deleteButton.isHidden = false
        } else {
            deleteButton.isHidden = true
        }
    }

  // MARK: - Actions
  @IBAction func saveTodo() {
      guard let title = titleTextField.text, !title.isEmpty else {
          // Show an alert if the title field is empty
          let alert = UIAlertController(title: "Error", message: "Title field is required", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          present(alert, animated: true, completion: nil)
          return
    }
        todosNew[todoIndex ?? -1].title = title
        todosNew[todoIndex ?? -1].completed = completedSwitch.isOn
    
      if var todo = todo {
          print("Todos title \(title)")
          // Edit existing todo
          todo.title = title
          todo.completed = completedSwitch.isOn
        
      } else {
          // Create new todo
          let completed = completedSwitch.isOn
          let newTodo = Todo(title: title, completed: completed)
        print("Todos alterat \(newTodo.title)")
          todosNew.append(newTodo)
      }
      
      saveTodos(todosNew)
      navigationController?.popViewController(animated: true)
  }
    
    @IBAction func deleteTodo() {
        guard let index = todoIndex else {
            return
        }
        todosNew.remove(at: index)
        saveTodos(todosNew)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Helper methods - save to JSON
    func saveTodos(_ ptodos: [Todo] ){
      do {
          let encoder = JSONEncoder()
          encoder.outputFormatting = .prettyPrinted
          let data = try encoder.encode(ptodos)
        
        if let path = Bundle.main.path(forResource:"todos", ofType:"json") {
            let url = Bundle.main.url(forResource: "todos", withExtension: "json")
            // Check if the file exists and delete it if it does
            if FileManager.default.fileExists(atPath: path) {
                print("File exists and it should be deleted")
                try! FileManager.default.removeItem(atPath: url!.path)
           }
            print("Saving todos to file: \(String(describing: url?.path))")
            try data.write(to: url!)
        }
        
      } catch let error {
          print("Error saving todos to file: \(error.localizedDescription)")
      }    }
}
