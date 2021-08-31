import UIKit

final class ViewController: UIViewController {
    
    //MARK: - Variables
    //Views
    private let headerLabel = UILabel()
    private let timerLabel = UILabel()
    private let nameTextField = UITextField()
    private let timeTextField = UITextField()
    private let addButton = UIButton(type: .roundedRect)
    private let currentTime = Date()
    private let calendar = Calendar(identifier: .gregorian)
    
    
    //TableView
    private var timerTableView = UITableView()
    private let identifier = "Cell"
    
    private var timerArray = [TimerCountDown]()
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createHeader(headerLabel)
        createAddTimerLabel(timerLabel)
        createNameTextField(nameTextField)
        createTimeTextField(timeTextField)
        nameTextField.delegate = self
        timeTextField.delegate = self
        createAddButton(addButton)
        createTableView()

    }
    
    //MARK: - Methods
    private func createHeader(_ header: UILabel) {
        header.text = "Мульти таймер"
        header.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: 100.0)
        header.backgroundColor = .quaternaryLabel
        header.textColor = .black
        header.font = .boldSystemFont(ofSize: 20)
        header.textAlignment = .center
        
        view.addSubview(header)
    }
    
    private func createAddTimerLabel(_ label: UILabel) {
        label.text = "   Добавление таймеров"
        label.frame = CGRect(x: 0.0, y: headerLabel.frame.height + 10.0, width: view.bounds.width, height: 40.0)
        label.backgroundColor = .quaternarySystemFill
        label.textColor = .black
        label.textAlignment = .left
        
        view.addSubview(label)
    }
    
    private func createNameTextField(_ textField: UITextField) {
        textField.frame = CGRect(x: 15.0, y: timerLabel.frame.maxY + 20.0, width: view.bounds.width / 1.5, height: 34.0)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Название таймера"
        
        view.addSubview(textField)
    }
    
    private func createTimeTextField(_ textField: UITextField) {
        textField.frame = CGRect(x: 15.0, y: nameTextField.frame.maxY + 10.0, width: view.bounds.width / 1.5, height: 34.0)
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.placeholder = "Время в секундах"
        
        view.addSubview(textField)
    }
    
    private func createAddButton(_ button: UIButton) {
        button.frame = CGRect(x: 10.0, y: timeTextField.frame.maxY + 20.0, width: view.bounds.width - 20.0, height: 60.0)
        button.setTitle("Добавить", for: .normal)
        button.tintColor = .systemBlue
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = .quaternaryLabel
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(buttonMethod), for: .touchUpInside)
        
        view.addSubview(button)
    }
    
    @objc func buttonMethod() {
        guard let textTime = timeTextField.text else {return}
        guard let textName = nameTextField.text else {return}
        var index = Int()
        
        if  !textName.isEmpty && !textTime.isEmpty {
            let timer = TimerCountDown(name: nameTextField.text, time: Int(timeTextField.text ?? "nil"), currentTime: Int(timeTextField.text ?? "nil"))
            
            if timerArray.isEmpty {
                timerArray.append(timer)
            } else {
                index = insertingNewEl(newEl: timer)
            }
            
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: index, section: 0)
                self.timerTableView.insertRows(at: [indexPath], with: .none)
            }
            timeTextField.resignFirstResponder()
            timeTextField.text = nil
            nameTextField.text = nil
        } else {
            let alert = UIAlertController(title: "Заполните все поля", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func createTableView() {
        timerTableView = UITableView(frame: CGRect(x: 0.0, y: addButton.frame.maxY + 20, width: view.bounds.width, height: view.bounds.maxY), style: .plain)
        timerTableView.register(TimerCell.self, forCellReuseIdentifier: identifier)
        timerTableView.delegate = self
        timerTableView.dataSource = self
        timerTableView.separatorStyle = .none
        view.addSubview(timerTableView)
    }
    
    private func totalSec(sec: Int?) -> Int? {
        let hour = calendar.component(.hour, from: currentTime)
        let minute = calendar.component(.minute, from: currentTime)
        let second = calendar.component(.second, from: currentTime)
        
        guard let sec = sec else {return Int()}
        let sum = hour * 3600 + minute * 60 + second + sec
        return sum
    }
    
    private func insertingNewEl(newEl: TimerCountDown) -> Int {
        
        var finIndex = Int()
        
        if newEl.currentTime ?? 0 >= timerArray[0].currentTime ?? 0 {
            timerArray.insert(newEl, at: 0)
            finIndex = 0
        } else if newEl.currentTime ?? 0 <= timerArray.last?.currentTime ?? 0 {
            finIndex = timerArray.count
            timerArray.append(newEl)
        } else {
            for index in 0..<timerArray.count - 1 {
                if newEl.currentTime ?? 0 < timerArray[index].currentTime ?? 0 &&
                newEl.currentTime ?? 0 >= timerArray[index + 1].currentTime ?? 0 {
                    timerArray.insert(newEl, at: index + 1)
                    finIndex = index + 1
                }
            }

        }
        return finIndex
    }
    
}

//MARK: - Delegate & DataSource
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            timeTextField.becomeFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == timeTextField {
            let invalidCharacters =
              CharacterSet(charactersIn: "0123456789").inverted
            return (string.rangeOfCharacter(from: invalidCharacters) == nil)
        } else {
            return true
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TimerCell else {return UITableViewCell()}
        cell.nameLabel.text = timerArray[indexPath.row].name
        timerArray[indexPath.row].countdown(cell.timerLabel, cell: cell)
        
        cell.callback = { currentCell in
            guard let actualIndexPath = tableView.indexPath(for: currentCell) else {return}
            self.timerArray.remove(at: actualIndexPath.row)
            tableView.deleteRows(at: [actualIndexPath], with: .left)
          }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Таймеры"
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            timerArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    

    
}
