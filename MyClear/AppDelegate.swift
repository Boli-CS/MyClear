//
//  AppDelegate.swift
//  MyClear
//
//  Created by boli on 1/19/15.
//  Copyright (c) 2015 boli. All rights reserved.
//

import UIKit
import SQLite

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.initializeDB()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func initializeDB(){
        if(!NSFileManager.defaultManager().fileExistsAtPath(GlobalVariables.dbPath)) {
            print("begin to create database: " + GlobalVariables.dbPath)
            let db = try! Connection(GlobalVariables.dbPath)
            do {
                try db.run(GlobalVariables.listTable.create{t in
                    t.column(GlobalVariables.List.id, primaryKey : true)
                    t.column(GlobalVariables.List.listName, unique : true)
                })
                try db.run(GlobalVariables.themeTable.create{t in
                    t.column(GlobalVariables.Theme.themeID, primaryKey : true)
                })
                try db.run(GlobalVariables.todoThingTable.create{t in
                    t.column(GlobalVariables.TodoThing.id, primaryKey : true)
                    t.column(GlobalVariables.TodoThing.listID)
                    t.column(GlobalVariables.TodoThing.thing, unique : true)
                    t.column(GlobalVariables.TodoThing.deadLine)
                    t.column(GlobalVariables.TodoThing.isComplete)
                })
            } catch let error {
                print(error)
            }
            print("finish to create database: " + GlobalVariables.dbPath)
        }
    }
    
}

