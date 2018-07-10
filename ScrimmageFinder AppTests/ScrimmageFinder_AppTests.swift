import XCTest
import CoreData


@testable import ScrimmageFinder_App


class ScrimmageFinder_AppTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        
    }
// function to test if the date is valid
    func testInisValidDate() {

    let VC = addScrimmageViewController()
    // date example
        let exDate  = "11.07.2018 15.00"
    //ate example 2
        let exDate2 = "cdscnds"
        
        XCTAssertTrue(VC.isValidDate(dateString: exDate))
        XCTAssertFalse(VC.isValidDate(dateString: exDate2))
        
    }
//test check if fetching is working correctly
    func testFetchingCoreData(){
        
        let VCS = SavedScrimmagesViewController()
        
        
        XCTAssertTrue(VCS.coreScrimmages.count == 0)
        
        VCS.fetchScrimmages()
        
        XCTAssertTrue(VCS.coreScrimmages.count > 0)
        
    }
    
  
    
    
    
    // test to for reading and adding to firebase ---- this test is not completed
    func testAddingToDatabase() {
   // array of scrimmagest the will be pulled from database
       
        let vc = ScrimmagesViewController()
        
  // function for pulling data from database
        FIRFirestoreService.shared.read(from: .scrimmages, returning: Scrimmage.self) { (scrimmages) in
            vc.scrimmages = scrimmages}
  //counting scrimmages
        let counting = vc.scrimmages.count
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
       FIRFirestoreService.shared.read(from: .scrimmages, returning: Scrimmage.self) { (scrimmages) in
            vc.scrimmages = scrimmages }
  //counting the resoults
        let count2 = vc.scrimmages.count
        print("count2 \(count2)")
  //comparing the count
        XCTAssertTrue(counting == count2)
        
    }
    
  // test for saving the scrimmage to coreData
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
  
    func testEntityExistCoreData(){
        
        let vc = DetailOneViewController()
        
        let coreDataController = CoreDataController.shared
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
        
        XCTAssertFalse(vc.entityExists(name: "name"))
        
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
    
    // this test is not completed
    func testReadingFirebase(){
        var scrimmages2 = [Scrimmage]()
        
       FIRFirestoreService.shared.read(from: .scrimmages, returning: Scrimmage.self) { (scrimmages) in
            scrimmages2 = scrimmages}
        print("count \(scrimmages2.count)")
    }
    
    
}
