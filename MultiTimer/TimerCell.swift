import UIKit

final class TimerCell: UITableViewCell {
    public var nameLabel = UILabel()
    public var timerLabel = UILabel()
    
    public var callback: ((UITableViewCell)->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(nameLabel)
        addSubview(timerLabel)

        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        timerLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
