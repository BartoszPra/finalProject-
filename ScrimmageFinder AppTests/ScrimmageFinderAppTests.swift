import XCTest
import CoreData
@testable import ScrimmageFinder_App

class ScrimmageFinderAppTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
    }
// function to test if the date is valid
    func testInisValidDate() {

    let VContr = AddScrimmageViewController()
    // date example
        let exDate  = "30.07.2020 15.00"
    //ate example 2
        let exDate2 = "cdscnds"
        
        XCTAssertTrue(VContr.isValidDate(dateString: exDate))
        XCTAssertFalse(VContr.isValidDate(dateString: exDate2))
        
    }
//test check if fetching is working correctly
    func testFetchingCoreData() {
        
        let VCS = SavedScrimmagesViewController()
        XCTAssertTrue(VCS.coreScrimmages.isEmpty)
        VCS.fetchScrimmages()
     //   XCTAssertTrue(VCS.coreScrimmages.count > 0)
        
    }
    
    // test to for reading and adding to firebase
    func testAddingToDatabase() {
   // array of scrimmagest the will be pulled from database
       
        let VContr = ScrimmagesViewController()
        
  // function for pulling data from database
        FIRFirestoreService.shared.readAll(from: .scrimmages, returning: Scrimmage.self) { (scrimmages) in
            VContr.scrimmages = scrimmages}
  //counting scrimmages
        let counting = VContr.scrimmages.count
        print("count \(counting)")
    // creating example scrimmage
        let scrimmage = Scrimmage(name: "nametesssts",
                                  vanueName: "VenueName",
                                  postCode: "postCode",
                                  time: 20.00, managerName: "Josh",
                                  managerNumber: "099922929",
                                  price: 2.00,
                                  date: "20.10.2018")
   // adding the created scrimmage
        FIRFirestoreService.shared.create(for: scrimmage, in: .scrimmages)
  //reading from database
       FIRFirestoreService.shared.readAll(from: .scrimmages, returning: Scrimmage.self) { (scrimmages) in
            VContr.scrimmages = scrimmages }
  //counting the resoults
        let count2 = VContr.scrimmages.count
        print("count2 \(count2)")
  //comparing the count
        XCTAssertTrue(counting == count2)
        
    }
    
  // test for saving the scrimmage to coreData
    func testSavingToCoreData() {
        
        let coreDataController = CoreDataController.shared
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ScrimmageSaved")
        var entitiesCount = 0
        do {
            entitiesCount = try coreDataController.mainContext.count(for: fetchRequest)
            print(entitiesCount)
        } catch {
            print("error executing fetch request: \(error)")
        }
        
        let newScrimmage = ScrimmageSaved(context: coreDataController.mainContext)
        
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
        } catch {
            print("error executing fetch request: \(error)")
        }
        XCTAssertTrue(entitiesCount2 > entitiesCount)
        
        coreDataController.mainContext.delete(newScrimmage)
        coreDataController.saveContext()
        
    }
  
    func testEntityExistCoreData() {
        
        let viewController = SFdetailViewController()
        let coreDataController = CoreDataController.shared
        let newScrimmage = ScrimmageSaved(context: coreDataController.mainContext)
        
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
        
        XCTAssertFalse(viewController.entityExists(name: "name"))
        
        coreDataController.mainContext.delete(newScrimmage)
        coreDataController.saveContext()
        
    }
    
 //   func testIsSeachring(){
        
//        let vc = ScrimmagesViewController()
//
//        let searchBar = UISearchBar()
//
//        vc.searchBar(searchBar, textDidChange: "vvsdvs")
//
//        XCTAssertTrue(vc.isSearching)
        
//    }
    func testReadingFirebase() {
        var scrimmages2 = [Scrimmage]()
        
       FIRFirestoreService.shared.readAll(from: .scrimmages, returning: Scrimmage.self) { (scrimmages) in
            scrimmages2 = scrimmages}
        print("count \(scrimmages2.count)")
    }
}
