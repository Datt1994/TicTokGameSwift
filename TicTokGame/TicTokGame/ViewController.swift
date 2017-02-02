//
//  ViewController.swift
//  TicTokGame
//
//  Created by karishma on 2/1/17.
//  Copyright © 2017 karishma. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource{
    @IBOutlet weak var collectionview: UICollectionView!
    
    let reuseIdentifier = "Cell"
    var isSelectRed = false
    var isCPU = Bool()
    
    
    var items = NSArray()
    var Group = NSArray()
    var aryRed = NSMutableArray()
    var aryBlack = NSMutableArray()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Group = [[0,1,2],[0,3,6],[3,4,5],[1,4,7],[6,7,8],[2,5,8],[0,4,8],[2,4,6]]
        items = [0,1,2,3,4,5,6,7,8]
        definesPresentationContext = true
        
        self.showAlertGame()
       
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func showAlertGame()  {
        let alert = UIAlertController(title: "Select Game" as String, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "1 Player", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
            self.isCPU = true
            self.initNavigationItemTitleView(title: "1 Player")
            self.reset()
        })
        alert.addAction(UIAlertAction(title: "2 Player", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
            self.navigationItem.title = "2 Player"
            self.isCPU = false
            self.initNavigationItemTitleView(title: "2 Player")
            self.reset()
        })
        self.present(alert, animated: true)
    }
    private func initNavigationItemTitleView(title : NSString) {
        let titleView = UILabel()
        titleView.text = title as String
        titleView.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        titleView.textAlignment = .center
 //        let width = titleView.sizeThatFits(CGSizeMake(CGFloat.greatestFiniteMagnitude, CGFloat.greatestFiniteMagnitude)).width
//        titleView.frame = CGRect(origin:CGPointZero, size:CGSizeMake(width, 500))
        self.navigationItem.titleView = titleView
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.titleWasTapped))
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(recognizer)
    }
    @objc private func titleWasTapped() {
         self.showAlertGame()
    }
    func reset() {
        self.collectionview.reloadData()
        self.isSelectRed = false
        self.aryRed = NSMutableArray()
        self.aryBlack = NSMutableArray()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TicCollectionViewCell
        Cell.imgView.image=nil
        
        Cell.isUserInteractionEnabled = true
        Cell.backgroundColor = UIColor.cyan
        return Cell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TicCollectionViewCell
        if isSelectRed {
            //cell.backgroundColor = UIColor.red
            cell.imgView.image = UIImage(named:"cross")
            isSelectRed = false
            aryRed.add(indexPath.row)
            
            
            
            if aryRed.count > 2 {
                if self.isWin(Arr: aryRed)  {
                    self.showAlert(title: "Cross Win")
                    
                }
            }
            
        }
        else
        {
            //cell.backgroundColor = UIColor.black
            cell.imgView.image = UIImage(named:"zero")
            
            isSelectRed = true
            aryBlack.add(indexPath.row)
            
            var isBlackWin = false
            
            if aryBlack.count > 2 {
                if  self.isWin(Arr: aryBlack) {
                    self.showAlert(title: "Zero Win")
                    isBlackWin = true
                }
                
            }
            
            if isCPU && !isBlackWin {
                var tmp = NSMutableArray()
                let tmpRedBlack = NSMutableArray(array: Array(aryRed) + Array(aryBlack))
                //print(tmpRedBlack)
                tmp = items.mutableCopy() as! NSMutableArray
                //tmpRedBlack.addObjects(from: [aryBlack as Any])
                // tmpRedBlack.append(aryBlack )
                for i in 0 ..< items.count
                {
                    if tmpRedBlack.contains(items[i]) {
                        tmp.remove(items[i])
                    }
                }
                let randomIndex = Int(arc4random_uniform(UInt32(tmp.count)))
                //               let cell1 = collectionView.cellForItem(at: IndexPath(item: tmp[randomIndex], section: 0)) as! TicCollectionViewCell
                if  tmp.count > 0{
                   self.collectionView(self.collectionview!, didSelectItemAt: IndexPath(item: tmp[randomIndex] as! Int, section: 0))
                }
                
                
               
            }

            
            
        }
        cell.isUserInteractionEnabled = false
        
        if  aryRed.count + aryBlack.count == 9{
            self.showAlert(title: "Game Over")
        }
        
    }
    func isWin(Arr : NSArray) -> Bool {
        var NumberCount = Int()
        var FG = false
        
        for i in 0 ..< Group.count
        {
            NumberCount = 0
            for j in 0 ..< (Group[i] as AnyObject).count
            {
                
                //                for k in 0 ..< Arr.count
                //                {
                //                    if Arr[k] as! Int == (Group[i] as! NSArray)[j] as! Int  {
                //                        NumberCount += 1
                //                    }
                //
                //                }
                if Arr.contains((Group[i] as! NSArray)[j])
                {
                    NumberCount += 1
                }
                
                if NumberCount == 3 {
                    FG = true
                    break
                }
            }
            if NumberCount == 3 {
                break
            }
            
        }
        return FG
    }
    func showAlert(title : NSString) {
        let alert = UIAlertController(title: title as String, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            // perhaps use action.title here
            //self.collectionview.subviews.removeAll()
            self.dismiss(animated: true, completion: nil)
            self.reset()
        })
        self.present(alert, animated: true)
    }
    
    
}

