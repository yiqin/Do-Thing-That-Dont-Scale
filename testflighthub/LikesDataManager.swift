//
//  LikesDataManager.swift
//  testflighthub
//
//  Created by Yi Qin on 12/28/14.
//  Copyright (c) 2014 Yi Qin. All rights reserved.
//

import UIKit

class LikesDataManager: NSObject {
    
    // var likesCollection : NSMutableSet = NSMutableSet()
    var updatedLikesList : NSMutableSet = NSMutableSet()
    var localLikedList : NSMutableSet = NSMutableSet()
    
    class var sharedInstance : LikesDataManager {
        struct Static {
            static let instance = LikesDataManager()
        }
        return Static.instance
    }
    
    func addLike(product:Product){
        localLikedList.addObject(product)
    }
    
    func removeLike(product:Product){
        localLikedList.removeObject(product)
    }
    
    func checkLike(product:Product)->Bool{
        return localLikedList.containsObject(product)
    }
    
    /*
    func checkLike(product:Product)->Bool{
        return likesCollection.containsObject(product)
    }
    */
    
    func addUpdate(product:Product){
        updatedLikesList.addObject(product)
    }
    
    func checkUpdate(product:Product)->Bool{
        return updatedLikesList.containsObject(product)
    }
}
