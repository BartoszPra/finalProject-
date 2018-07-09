//
//  ScrimmageFinder_AppTests.swift
//  ScrimmageFinder AppTests
//
//  Created by The App Experts on 21/06/2018.
//  Copyright © 2018 The App Experts. All rights reserved.
//

import XCTest
import CoreData
@testable import ScrimmageFinder_App

class ScrimmageFinder_AppTests: XCTestCase {
    
    
    
    func testInisValidDate() {
        
    let VC = addScrimmageViewController()
        
        let exDate  = "09.07.2018 15.00"
        let exDate2 = "cdscnds"
        
        XCTAssertTrue(VC.isValidDate(dateString: exDate))
        XCTAssertFalse(VC.isValidDate(dateString: exDate2))
        
    }
    
    func testFetchingCoreData(){
        
        let VCS = SavedScrimmagesViewController()
        
        XCTAssertTrue(VCS.coreScrimmages.count == 0)
        
        VCS.fetchScrimmages()
        
        XCTAssertTrue(VCS.coreScrimmages.count > 0)
        
    }
    
    func testAddingToDatabase() {
        
        
    }
    
    func testSavingToCoreData(){
        
        let coreDataController = CoreDataController.shared
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ScrimmageD")
        var entitiesCount = 0
        do {
            entitiesCount = try coreDataController.mainContext.count(for: fetchRequest)
            print(entitiesCount)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        let newScrimmage = ScrimmageD(context: coreDataController.mainContext)
        
        newScrimmage.name = "name"
        newScrimmage.venueName = "venueNAme"
        newScrimmage.managersName = "sth"
        newScrimmage.managersNumber = "de"
        newScrimmage.postCode = "de"
        newScrimmage.time = 20.00
        newScrimmage.price = 2.00
        newScrimmage.date = "18.11.2018"
        newScrimmage.participants = 1
        
        coreDataController.saveContext()
        
        var entitiesCount2 = 0
        do {
            entitiesCount2 = try coreDataController.mainContext.count(for: fetchRequest)
            print(entitiesCount2)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        XCTAssertTrue(entitiesCount2 > entitiesCount)
        
        coreDataController.mainContext.delete(newScrimmage)
        coreDataController.saveContext()
        
    }
  
    func testChecking(){
        
    }
    
}
