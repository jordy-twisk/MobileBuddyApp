//
//  BuddySwipeController.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 29/04/2020.
//  Copyright © 2020 ProjectGroep5. All rights reserved.
//

import Foundation
import UIKit

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
        print("Newpage is: ", PageControl.currentPage)
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
        let nextIndex = min(Int(currentPage) + 1, CoachesArray.count - 1)
        print("Next :",nextIndex, PageControl.currentPage, CoachesArray.count)
        nextPage(nextIndex: nextIndex)
    }
    
    func nextPage(nextIndex : Int) {
        let pagewidth = collectionView.frame.size.width
        let currentPage = collectionView.contentOffset.x / pagewidth
        let pageControlNumbersOfPages = PageControl.numberOfPages - 1
        let datasourceCount = CGFloat(CoachesArray.count - 1)
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
        print("Newpage is: ", PageControl.currentPage)
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
        print("Prev :",prevIndex, PageControl.currentPage, CoachesArray.count)
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
        print(x, view.frame.width, x / view.frame.width)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        MakeApiCall()
        
        
    }
    
    
    
    func MakeApiCall(){
        CoachesArray = []
        ApiManager.getCoaches().responseData(completionHandler: { [weak self] (response) in
            let jsonData = response.data!
            let decoder = JSONDecoder()
            let AllCoaches = try? decoder.decode([Coaches].self, from: jsonData)
            print("All coaches count is:", AllCoaches?.count)
            if (AllCoaches != nil){
                for item in AllCoaches!{
                    CoachesArray.append(item)
//                    print(item.student.studentid)
                }
            }
            
                          
//                self!.LoadingIndicator.stopAnimating()
//                self!.LoadingIndicator.isHidden = true
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
        print("number of items is: ", CoachesArray.count)
            return CoachesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuddyProfileCollectionViewCell", for: indexPath) as! BuddyProfileCollectionViewCell
        cell.NameLabel.text = CoachesArray[indexPath.item].student.firstname
        cell.StudyLabel.text = CoachesArray[indexPath.item].student.study
        cell.LocationALabel.text = String(CoachesArray[indexPath.item].student.studentid)
        cell.PreStudyALabel.text = CoachesArray[indexPath.item].student.degree
        cell.BioALabel.text = CoachesArray[indexPath.item].student.description
        let ImageUrl = URL(string: CoachesArray[indexPath.item].student.photo)
        cell.ProfileImageView.kf.setImage(with: ImageUrl)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)

        return layout.itemSize
        
//        return CGSize(width: view.frame.width, height: view.frame.height)
    
    }
    
    
}
