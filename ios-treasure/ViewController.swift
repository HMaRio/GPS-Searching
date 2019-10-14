//
//  ViewController.swift
//  ios-treasure
//
//  Created by Mario Holper on 13.10.19.
//  Copyright © 2019 Mario Holper. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var labelPosition: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //Instanz von MyLocationManager
    var mylocmgr = MyLocationManager.shareInstance
    var poslist = Position.readArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        //wenn das Notification Center die Nachricht "NewLocation" erhält, wird die Methode notityNewLocation() aufgerufen
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.notifyNewLocation(_:)), name: Notification.Name(rawValue: "NewLocation"), object: nil)
    }
    
    //wird von Notification Center aufgerufen, sobald eine "NewLocation"-Nachricht eintrifft
    @objc func notifyNewLocation(_ notification: Notification) {
        let coord = mylocmgr.location.coordinate
        let long = degreesMinutes(coord.longitude)
        let lat = degreesMinutes(coord.latitude)
        labelPosition.text = "Position Lat= \(lat) / Long = \(long)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Segue zum Popup-Speicherdialog
        if let dest = segue.destination as? SaveVC, let popPC = dest.popoverPresentationController {
            popPC.delegate = self
        }
        //Segue zur Datailansicht
        if let dest = segue.destination as? DetailVC, let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            dest.row = indexPath.row
            dest.pos = poslist[indexPath.row]
            dest.delegate = self
        }
    }
    
    @IBAction func unwindToMainView(_ segue: UIStoryboardSegue) {
        if let src = segue.source as? SaveVC {
            //explizit ausblenden
            if !segue.source.isBeingDismissed {
                segue.source.dismiss(animated: true, completion: nil)
            }
            if let txt = src.posname.text {
                let posname = txt.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if posname != "", let loc = mylocmgr.location {
                    let newpos = Position(posname, loc.timestamp, loc.coordinate.latitude, loc.coordinate.longitude)
                    //am Beginn der Liste einfügen
                    poslist.insert(newpos, at: 0)
                    //neue Liste bleibend speichern
                    Position.saveArray(poslist)
                    //anzeigen
                    tableView.reloadData()
                }
            }
        }
    }
}
//Data Source Methoden
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poslist.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dfmt = DateFormatter()
        dfmt.dateStyle = .medium
        dfmt.timeStyle = .short
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProtoCell", for: indexPath)
        cell.textLabel?.text = poslist[indexPath.row].name
        cell.detailTextLabel?.text = dfmt.string(from: poslist[indexPath.row].time as Date)
        return cell
    }
}
// für Poupus auf dem iPhone
extension ViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
//eigener Delegate zur Verarbeitung der Rückkehr von DetailVC
extension ViewController: DetailVCDelegate {
    func backFromDetailVC(_ sourceVC: DetailVC) {
        if sourceVC.deleteItem == true {
            //Listenelement löschen
            poslist.remove(at: sourceVC.row)
            //anzeigen
            tableView.reloadData()
            //geänderte Liste bleiben speichern
            Position.saveArray(poslist)
        } else {
            //gegebenenfalls Titel des Listenelements ändern
            let txt = sourceVC.txtPosition.text!
            let newname = txt.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if newname != "" && newname != poslist[sourceVC.row].name {
                poslist[sourceVC.row].name = newname
                Position.saveArray(poslist)
                tableView.reloadData()
            }
        } //Ende der if-else-Konstruktion
    } //Ende der back-Methode
} //Ende der extension
