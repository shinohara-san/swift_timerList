//
//  TableViewController.swift
//  swift_timeWithUserDefault
//
//  Created by Yuki Shinohara on 2020/06/03.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit
import AVFoundation

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var itemArray = [TimerItem]()
    
    let userDefaults = UserDefaults.standard
    
    private var timer = Timer()
    
    let soundPath = Bundle.main.bundleURL.appendingPathComponent("fate2.mp3")
    var soundPlayer = AVAudioPlayer()
    
    @IBOutlet var startButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        startButton.image = UIImage(systemName: "play.fill")
        title = "たくさんタイマー"
        if let data = userDefaults.object(forKey:"Timer") as? Data {
            itemArray = try! PropertyListDecoder().decode([TimerItem].self, from: data)
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let ac = UIAlertController(title: "タイマーを追加", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Title here"
        }
        
        ac.addTextField { (textField) in
            textField.placeholder = "Seconds here"
            textField.keyboardType = .numberPad
        }
        
        let add = UIAlertAction(title: "追加", style: .default) { (void) in
            
            let title = ac.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let seconds = ac.textFields![1].text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if title != "" && seconds != "" {
                
                let newItem = TimerItem(title: title!, seconds: Int(seconds!) ?? 0)
                self.itemArray.append(newItem)
                self.userDefaults.set(try? PropertyListEncoder().encode(self.itemArray), forKey:"Timer")
                
            } else {
                print("Empty TextFields")
                return
            }
            
            
            if let data = self.userDefaults.object(forKey:"Timer") as? Data {
                self.itemArray = try! PropertyListDecoder().decode([TimerItem].self, from: data)
            }
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "キャンセル", style: .default, handler: nil)
        
        ac.addAction(add)
        ac.addAction(cancel)
        present(ac, animated: true)
        
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    ///
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let timerForRow = Timer()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TimerViewCell
        cell.titleLabel?.text = itemArray[indexPath.row].title
        cell.timerLabel?.text = String(itemArray[indexPath.row].seconds) + "びょう"
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        itemArray.remove(at: indexPath.row)
        userDefaults.set(try? PropertyListEncoder().encode(self.itemArray), forKey:"Timer")
        tableView.reloadData()
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if !timer.isValid {
            startButton.image = UIImage(systemName: "pause.fill")
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        else {
            startButton.image = UIImage(systemName: "play.fill")
            timer.invalidate()
        }
    }
    
    @objc func updateTimer(){
        
        for i in 0..<itemArray.count{
            if itemArray[i].seconds > 0{
            itemArray[i].seconds -= 1
            }
///            全部が0になったらtimer止める
            
//            if itemArray.allSatisfy($0, $1.seconds == 0){
//                timer.invalidate()
//            }
            
        }
            
            let indexPathsArray = tableView.indexPathsForVisibleRows
            for indexPath in indexPathsArray! {
                let cell = tableView.cellForRow(at: indexPath)
                cell?.detailTextLabel?.text = String(itemArray[indexPath.row].seconds) + "びょう"
                //ループで全部のseconds見て0びょうだけだったらtimer.invalidate()
//                if cell?.detailTextLabel?.text == "0びょう"{
//                    itemArray[indexPath.row].timer
//                    soundPlayer(player: &soundPlayer, path: soundPath, count: 0)
                
//                }
            }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        //画面閉じるときにタイマー止める
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        timer.invalidate()
        if let data = userDefaults.object(forKey:"Timer") as? Data {
            itemArray = try! PropertyListDecoder().decode([TimerItem].self, from: data)
        }
        startButton.image = UIImage(systemName: "play.fill")
        tableView.reloadData()
    }
    
    fileprivate func soundPlayer(player:inout AVAudioPlayer, path: URL, count:Int){
        do{
            player = try AVAudioPlayer(contentsOf: path, fileTypeHint: nil)
            player.numberOfLoops = count
            player.play()
            
        }catch{
            print("エラー")
        }
    }
    
    
}

//https://www.it-swarm.dev/ja/ios/%E6%A7%8B%E9%80%A0%E4%BD%93%E3%82%92userdefaults%E3%81%AB%E4%BF%9D%E5%AD%98/833650600/

///途中で削除すると時間が減った状態で上書きされるのでrefreshがおかしい
///０びょうで自動ストップさせたい
///ゲージでカウントダウンしたい
///音つけたい → タイマー一つ一つ止めないとリピートする
///音も選択できるようにしたい
///行ごとでアイコンを選べるようにしたい→別ページでいろいろ設定。アイコンも保存しなきゃなのでrealmの出番か。
