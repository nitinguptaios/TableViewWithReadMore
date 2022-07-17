//
//  UtilityFunctions.swift
//  InPower
//
//  Created by iPHTech25 on 17/03/21.
//  Copyright © 2021 iPHSTech31. All rights reserved.
//

import UIKit

class UtilityFunctions {
    
    static let sharedInstance = UtilityFunctions()
    
    //MARK: Return index path.
    func getIndexPathFrom(object: AnyObject, sender: AnyObject) -> IndexPath?{
        
        if let tableview = object as? UITableView{
            
            let senderPosition:CGPoint = sender.convert(CGPoint.zero, to: tableview)
            let indexPath = tableview.indexPathForRow(at: senderPosition)
            return indexPath
        }
        else if let collectionView = object as? UICollectionView{
            
            let senderPosition:CGPoint = sender.convert(CGPoint.zero, to: collectionView)
            let indexPath = collectionView.indexPathForItem(at: senderPosition)
            return indexPath
        }
        
        return nil
    }
    
}
