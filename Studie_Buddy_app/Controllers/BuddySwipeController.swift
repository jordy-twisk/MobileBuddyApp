//
//  BuddySwipeController.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 29/04/2020.
//  Copyright © 2020 ProjectGroep5. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class CoachesToChoose: Equatable, Hashable{
    static func == (lhs: CoachesToChoose, rhs: CoachesToChoose) -> Bool {
        return lhs.name == rhs.name && lhs.bio == rhs.bio && lhs.study == rhs.study && lhs.degree == rhs.degree && lhs.interests == rhs.interests && lhs.photo == rhs.photo && lhs.studyyear == rhs.studyyear && lhs.studentid == rhs.studentid
    }
    var name: String
    var bio: String
    var study: String
    var degree: String
    var interests: String
    var photo: String
    var studyyear: String
    var studentid: String
    
    init(name: String, bio: String, study: String, degree: String, interests: String, photo: String, studyyear: String, studentid: String) {
            self.name = name
            self.bio = bio
            self.study = study
            self.degree = degree
            self.interests = interests
            self.photo = photo
            self.studyyear = studyyear
            self.studentid = studentid
        }

    var hashValue: Int {
            get {
                return name.hashValue + bio.hashValue + study.hashValue + degree.hashValue + degree.hashValue + interests.hashValue + photo.hashValue + studyyear.hashValue + studentid.hashValue
            }
        }
}

class CoachConnection: Equatable, Hashable{
    static func == (lhs: CoachConnection, rhs: CoachConnection) -> Bool {
        return lhs.studentID == rhs.studentID && lhs.coachID == rhs.coachID
    }
    var studentID: String
    var coachID: String
   
    
    init(studentID: String, coachID: String) {
        self.studentID = studentID
        self.coachID = coachID
    }

    var hashValue: Int {
            get {
                return studentID.hashValue + coachID.hashValue
            }
        }
}


var NewCoashesArray: [CoachesToChoose] = []
var CoachConnections: [CoachConnection] = []
var CoachesArray: [Coaches] = []
let Max_Pages: Int = 10



class BuddySwipeController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var NavigationBar: UINavigationItem!
    
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pagewidth = collectionView.frame.size.width
        let currentPage = collectionView.contentOffset.x / pagewidth
        let pageControlNumbersOfPages = PageControl.numberOfPages - 1
        let datasourceCount = CGFloat(CoachesArray.count - 1)
        let maxDotCountReduced = CGFloat(Max_Pages - 1)
        if datasourceCount > maxDotCountReduced {
            if currentPage >= maxDotCountReduced{
                if currentPage == datasourceCount {
                    PageControl.currentPage = pageControlNumbersOfPages
                }
                else {
                    PageControl.currentPage = pageControlNumbersOfPages - 1
                }
                return
            }
        }
        PageControl.currentPage = Int(currentPage)
    }
    
    private let NextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.InhollandPink, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleNext() {
        let pagewidth = collectionView.frame.size.width
        let currentPage = collectionView.contentOffset.x / pagewidth
        //------------------API WORKING: ----------------------------
        //let nextIndex = min(Int(currentPage) + 1, CoachesArray.count - 1)
        //------------------API NOT WORKING:-------------------------
        let nextIndex = min(Int(currentPage) + 1, NewCoashesArray.count - 1)
        nextPage(nextIndex: nextIndex)
    }
    
    func nextPage(nextIndex : Int) {
        let pagewidth = collectionView.frame.size.width
        let currentPage = collectionView.contentOffset.x / pagewidth
        let pageControlNumbersOfPages = PageControl.numberOfPages - 1
        
        //------------------API WORKING: ----------------------------
        //let datasourceCount = CGFloat(CoachesArray.count - 1)
        //------------------API NOT WORKING: ----------------------------
        let datasourceCount = CGFloat(NewCoashesArray.count - 1)
        
        
        let maxDotCountReduced = CGFloat(Max_Pages - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        if datasourceCount > maxDotCountReduced {
            if currentPage >= maxDotCountReduced{
                if currentPage == datasourceCount {
                    PageControl.currentPage = pageControlNumbersOfPages
                }
                else {
                    PageControl.currentPage = pageControlNumbersOfPages - 1
                }
                collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                return
            }
        }
        PageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    
    
    
    private let PrevButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("prev", comment: ""), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.InhollandPink, for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
    @objc private func handlePrev() {
        let pagewidth = collectionView.frame.size.width
        let currentPage = collectionView.contentOffset.x / pagewidth
        let prevIndex = max(Int(currentPage) - 1, 0)
        nextPage(nextIndex: prevIndex)
    }
    
    private let PageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = Max_Pages
        pc.currentPageIndicatorTintColor = .InhollandPink
        pc.pageIndicatorTintColor = .gray
        return pc
    }()
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        PageControl.currentPage = Int(x / view.frame.width)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Checkifuserhasbuddy()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //------------API NOT WORKING:--------
        NewCoashesArray.append(CoachesToChoose(name: "Demi", bio: "", study: "Economie", degree: "HBO", interests: "Sporten", photo: "https://image.shutterstock.com/image-photo/beautiful-african-american-woman-smiling-260nw-402466177.jpg", studyyear: "2", studentid: "570221"))
        NewCoashesArray.append(CoachesToChoose(name: "Jason", bio: "", study: "Wiskunde", degree: "HBO", interests: "tennis", photo: "https://st.focusedcollection.com/14026668/i/650/focused_172100334-stock-photo-portrait-young-smiling-businessman-profile.jpg", studyyear: "2", studentid: "570222"))
        NewCoashesArray.append(CoachesToChoose(name: "Erik", bio: "", study: "Informatica", degree: "HBO", interests: "Uitgaan", photo: "https://avatars2.githubusercontent.com/u/273509?s=400&u=66cc2a005c432ba73aebf3495314bf5db0d98d96&v=4", studyyear: "3", studentid: "570223"))
        NewCoashesArray.append(CoachesToChoose(name: "Martijn", bio: "", study: "Scheikunde", degree: "HBO", interests: "Voetbal, uitgaan, gamen", photo: "https://images.pexels.com/photos/2589653/pexels-photo-2589653.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", studyyear: "2", studentid: "570224"))
        NewCoashesArray.append(CoachesToChoose(name: "Sarah", bio: "", study: "Sportkunde", degree: "HBO", interests: "badminton, netflix", photo: "https://t4.ftcdn.net/jpg/03/64/20/99/360_F_364209944_kGGn4OUmBU2ySzpgXILSlMKkcH43PCs0.jpg", studyyear: "3", studentid: "570225"))
        NewCoashesArray.append(CoachesToChoose(name: "elise", bio: "", study: "Economie", degree: "HBO", interests: "Sporten, netflix", photo: "https://media.istockphoto.com/photos/close-up-portrait-of-brunette-woman-picture-id1154642632?k=6&m=1154642632&s=612x612&w=0&h=YTiNxRGupHJpMqQRu7Xh-U976mur5fp-cM_WEczpx04=", studyyear: "2", studentid: "570226"))
        
        
        print(NewCoashesArray.count)
        
        //-------------------WOKRING API:
        //CheckIfBuddyExist()
        //-------------------API NOT WORKING :
        Checkifuserhasbuddy()

            NavigationBar.title = NSLocalizedString("ChooseBuddy", comment: "")
             self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
             self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
             self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Header4"), for: .default)
             self.navigationController?.navigationBar.shadowImage = UIImage()
             self.navigationController?.navigationBar.isTranslucent = false
             self.navigationController?.view.backgroundColor = .clear
        
        collectionView?.backgroundColor = .white
        collectionView?.register(UINib(nibName: "BuddyProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BuddyProfileCollectionViewCell")
        
        collectionView?.isPagingEnabled = true
        //--------------------API WORKING
        //MakeApiCall()
        
        
        ConfigControl()
        
    }
    
    func Checkifuserhasbuddy(){
        let studentID = KeychainWrapper.standard.string(forKey: "StudentID")
        let coachIDtocheck =  KeychainWrapper.standard.string(forKey: "CoachID")
        print("check if user has buddy....")
        if CoachConnections.isEmpty == false && coachIDtocheck != "" {
            if CoachConnections.contains(where: { $0.studentID == studentID}){
                let indexOfUser = CoachConnections.firstIndex(where: { $0.studentID == studentID })
                let coachID = CoachConnections[indexOfUser!].coachID
                if NewCoashesArray.contains(where: { $0.studentid == coachID}){
                    let indexOfUser = NewCoashesArray.firstIndex(where: { $0.studentid == coachID })
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let DetailBuddyPage = (storyboard.instantiateViewController(withIdentifier:"detailpagebuddyviewcontroller") as? detailpagebuddyviewcontroller)!
                    
                    DetailBuddyPage.photo = NewCoashesArray[indexOfUser!].photo
                    DetailBuddyPage.name = NewCoashesArray[indexOfUser!].name
                    DetailBuddyPage.study = NewCoashesArray[indexOfUser!].study
                    DetailBuddyPage.studyyear = NewCoashesArray[indexOfUser!].studyyear
                    DetailBuddyPage.degree = NewCoashesArray[indexOfUser!].degree
                    DetailBuddyPage.interests = NewCoashesArray[indexOfUser!].interests
                    DetailBuddyPage.bio = NewCoashesArray[indexOfUser!].bio
                    DetailBuddyPage.coachID = Int(NewCoashesArray[indexOfUser!].studentid)!
                    DetailBuddyPage.ShowBackButton = false
                    
                    self.navigationController?.pushViewController(DetailBuddyPage, animated: true)
                }
            }
            
        }
    }
    
    func ConfigControl(){
        self.collectionView.reloadData()
        if (NewCoashesArray.count > 10)
               {
                    self.PageControl.numberOfPages = 10
               }else{
                    self.PageControl.numberOfPages = NewCoashesArray.count
               }
       
        self.setupBottomControls()
    }
    
    
    func CheckIfBuddyExist(){
        ApiManager.getCoachForTutorant().responseData(completionHandler: { [weak self] (response) in
            let jsonData = response.data
            if jsonData != nil{
                let decoder = JSONDecoder()
                            let Coach = try? decoder.decode(Tutorants.self, from: jsonData!)
                            if (Coach != nil){
                                ApiManager.getProfile(studentID: Coach!.coachid).responseData(completionHandler: { [weak self] (response) in
                //                    self!.UpdateIndicator.isHidden = false
                                    let jsonData = response.data!
                                    let decoder = JSONDecoder()
                                    let Coachprofile = try? decoder.decode(Student.self, from: jsonData)
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let DetailBuddyPage = (storyboard.instantiateViewController(withIdentifier:"detailpagebuddyviewcontroller") as? detailpagebuddyviewcontroller)!
                                    if (Coachprofile != nil){
                                        DetailBuddyPage.photo = Coachprofile!.photo
                                        DetailBuddyPage.name = Coachprofile!.firstname
                                        DetailBuddyPage.study = Coachprofile!.study
                                        DetailBuddyPage.studyyear = String(Coachprofile!.studyyear)
                                        DetailBuddyPage.degree = Coachprofile!.degree
                                        DetailBuddyPage.interests = Coachprofile!.interests
                                        DetailBuddyPage.bio = Coachprofile!.description
                                        DetailBuddyPage.coachID = Coachprofile!.studentid
                                        DetailBuddyPage.ShowBackButton = false
                                    }
                                    
                                    self!.navigationController?.pushViewController(DetailBuddyPage, animated: true)
                                    
                //                    self!.UpdateIndicator.isHidden = true
                 
                                    })
                }
            }
        })
        
    }
    
    
    func MakeApiCall(){
        CoachesArray = []
        ApiManager.getCoaches().responseData(completionHandler: { [weak self] (response) in
            let jsonData = response.data!
            let decoder = JSONDecoder()
            let AllCoaches = try? decoder.decode([Coaches].self, from: jsonData)
            if (AllCoaches != nil){
                for item in AllCoaches!{
                    CoachesArray.append(item)
                }
            }
            
            self!.collectionView.reloadData()
            if (CoachesArray.count > 10)
                   {
                        self!.PageControl.numberOfPages = 10
                   }else{
                        self!.PageControl.numberOfPages = CoachesArray.count
                   }
           
            self!.setupBottomControls()
        })
        
        }
    
    fileprivate func setupBottomControls() {
        let BottomControlsStackView = UIStackView(arrangedSubviews: [PrevButton, PageControl, NextButton])
        BottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        BottomControlsStackView.distribution = .fillEqually
        
        view.addSubview(BottomControlsStackView)
        
        
        NSLayoutConstraint.activate([
            BottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            BottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        BottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        
        BottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            //----------------WORKING API:
            //return CoachesArray.count
            //----------------API NOT WORKING:
        return NewCoashesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuddyProfileCollectionViewCell", for: indexPath) as! BuddyProfileCollectionViewCell
        // ------------------------WORKING API-------------------------
        /*
        cell.NameLabel.text = CoachesArray[indexPath.item].student.firstname
        cell.StudyLabel.text = CoachesArray[indexPath.item].student.study
        cell.LocationALabel.text = String(CoachesArray[indexPath.item].student.studentid)
        cell.PreStudyALabel.text = CoachesArray[indexPath.item].student.degree
        cell.BioALabel.text = CoachesArray[indexPath.item].student.description
        let ImageUrl = URL(string: CoachesArray[indexPath.item].student.photo)
        cell.ProfileImageView.kf.setImage(with: ImageUrl)
        */
        //-------------------------API NOT WORKING__________________
        print(NewCoashesArray[indexPath.item].name)
        cell.NameLabel.text = NewCoashesArray[indexPath.item].name
        cell.StudyLabel.text = NewCoashesArray[indexPath.item].study
        cell.LocationALabel.text = NewCoashesArray[indexPath.item].studentid
        cell.PreStudyALabel.text = NewCoashesArray[indexPath.item].degree
        cell.BioALabel.text = NewCoashesArray[indexPath.item].bio
        let ImageUrl = URL(string: NewCoashesArray[indexPath.item].photo)
        cell.ProfileImageView.kf.setImage(with: ImageUrl)

        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let DetailBuddyPage = (storyboard.instantiateViewController(withIdentifier:"detailpagebuddyviewcontroller") as? detailpagebuddyviewcontroller)!
        //--------------------API WORKING:-----------------------
        /*
        DetailBuddyPage.photo = CoachesArray[index].student.photo
        DetailBuddyPage.name = CoachesArray[index].student.firstname
        DetailBuddyPage.study = CoachesArray[index].student.study
        DetailBuddyPage.studyyear = String(CoachesArray[index].student.studyyear)
        DetailBuddyPage.degree = CoachesArray[index].student.degree
        DetailBuddyPage.interests = CoachesArray[index].student.interests
        DetailBuddyPage.bio = CoachesArray[index].student.description
        DetailBuddyPage.coachID = CoachesArray[index].coach.studentid
    */
        //-------------------API NOT WORKING------------------------
        DetailBuddyPage.photo = NewCoashesArray[index].photo
        DetailBuddyPage.name = NewCoashesArray[index].name
        DetailBuddyPage.study = NewCoashesArray[index].study
        DetailBuddyPage.studyyear = NewCoashesArray[index].studyyear
        DetailBuddyPage.degree = NewCoashesArray[index].degree
        DetailBuddyPage.interests = NewCoashesArray[index].interests
        DetailBuddyPage.bio = NewCoashesArray[index].bio
        DetailBuddyPage.coachID = Int(NewCoashesArray[index].studentid)!
        
        
        
        
        DetailBuddyPage.ShowBackButton = true
        navigationController?.pushViewController(DetailBuddyPage, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)

        return layout.itemSize
    }
    
    
}
