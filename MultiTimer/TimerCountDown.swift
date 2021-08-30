import UIKit

struct TimerCountDown {
    var name: String?
    var time: Int?
    var currentTime: Int?
    
    func countdown(_ label: UILabel, cell: TimerCell) {
        guard var time = time else {return}
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if time == 0 {
                timer.invalidate()
                guard let callback = cell.callback else {return}
                callback(cell)
            }
            let tm = secondsToMinutes(seconds: time)
            let timeString = makeTimeString(minutes: tm.0, seconds: tm.1)
            label.text = "\(timeString)"
            time -= 1
        }
    }
    
    private func secondsToMinutes(seconds: Int) -> (Int, Int) {
        return ((seconds / 60), (seconds % 60))
    }

    private func makeTimeString(minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
}





