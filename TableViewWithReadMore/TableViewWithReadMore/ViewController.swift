//
//  ViewController.swift
//  TableViewWithReadMore
//
//  Created by iPHTech36 on 23/01/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var stringValue = "Info Health Can Help You Find Relevant Information On What Your Are Looking For. Search Online Exam Mock Test. Visit & Lookup Immediate Results Now. Reproductive System Info. Health Resources. Explore More Now. Find Information Online."
    
    var string1Array = [String]()
    var string2Array = [String]()
    
    var readMore1StatusArray = [Bool]()
    var readMore2StatusArray = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for index in 0...29 {
            
            if index == 0 {
                string1Array.append(stringValue)
                readMore1StatusArray.append(false)
            }
            else {
                string2Array.append(stringValue)
                readMore2StatusArray.append(false)
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return string1Array.count+string2Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabellTableViewCell", for: indexPath) as! LabellTableViewCell
            cell.readMoreLabel.text = string1Array[indexPath.row]
            if readMore1StatusArray[indexPath.row] {
                let lessText = "\(string1Array[indexPath.row]) ...\("less")"
                let formattedText = get2FontSpacingString(spacing: 0.0, messageString: lessText, lightFont: cell.readMoreLabel.font, lightFontColor: cell.readMoreLabel.textColor, boldFont: UIFont.italicSystemFont(ofSize: 16), boldFontColor: UIColor.red, strings: ["less"])
                cell.readMoreLabel.attributedText = formattedText
                cell.readMoreLabel.numberOfLines = 0
            }
            else {
                cell.readMoreLabel.numberOfLines = 2
                let readmoreFont = UIFont.boldSystemFont(ofSize: 16)
                let readmoreFontColor = cell.readMoreLabel.tintColor ?? UIColor.blue
                DispatchQueue.main.async {
                    cell.readMoreLabel.addTrailing(with: " ...", moreText: "more", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
                }
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabellTableViewCell2", for: indexPath) as! LabellTableViewCell2
            cell.readMoreLabe2.text = string2Array[indexPath.row-1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func get2FontSpacingString(spacing: CGFloat = 5.0, messageString: String, lightFont: UIFont, lightFontColor: UIColor, boldFont: UIFont, boldFontColor: UIColor, strings: [String]) -> NSMutableAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        let attributedString =
        NSMutableAttributedString(string: messageString,
                                  attributes: [
                                    NSAttributedString.Key.font: lightFont,
                                    NSAttributedString.Key.foregroundColor: lightFontColor, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: boldFontColor, NSAttributedString.Key.paragraphStyle: paragraphStyle] as [NSAttributedString.Key : Any]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (messageString as NSString).range(of: bold))
        }
        return attributedString
    }
}

extension ViewController {
    
    @IBAction func readMoreButtonTap(_ sender: UIButton) {
        
        if let indexPath = UtilityFunctions.sharedInstance.getIndexPathFrom(object: tableView, sender: sender) {
            if indexPath.row == 0 {
                readMore1StatusArray[indexPath.row] = !readMore1StatusArray[indexPath.row]
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

extension UILabel {
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        
        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }
    
    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}
