//
//  DetailVC.swift
//  ios-treasure
//
//  Created by Mario Holper on 13.10.19.
//  Copyright © 2019 Mario Holper. All rights reserved.
//

import UIKit
import CoreLocation


protocol DetailVCDelegate {
    func backFromDetailVC(_ sourceVC: DetailVC)
    
    }
class DetailVC: UIViewController {
    
    var pos: Position!
    var row: Int!
    let mylocmgr = MyLocationManager.shareInstance
    var deleteItem = false
    var heading = 0.0
    var delegate: DetailVCDelegate?
    
    @IBOutlet weak var txtPosition: UITextField!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lbllDistance: UILabel!
    @IBOutlet weak var lblLatLong: UILabel!
    @IBOutlet weak var arrowview: ArrowView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if pos == nil { return }
        
        //Steuerlemente mit Datum aus 'pos' initialisieren
        let dfmt = DateFormatter()
        dfmt.dateStyle = .medium
        dfmt.timeStyle = .short
        txtPosition.text = pos.name
        lblTime.text = "Zeit: " + dfmt.string(from: pos.time as Date)
        let long = degreesMinutes(pos.long)
        let lat = degreesMinutes(pos.lat)
        lblLatLong.text = "Ort: Lat = \(lat) / Long = \(long)"
        
        //Tastaturereignisse verarbeiten
        txtPosition.delegate = self
        
        //neue Position verarbeiten
        NotificationCenter.default.addObserver(self, selector: #selector(DetailVC.notifyNewLocation(_:)), name: Notification.Name(rawValue: "NewLocation"), object: nil)
    }
    @objc func notifyNewLocation(_ notification: Notification) {
        //Entfernung zwischen 'pos' und aktuellem Standpunkt errechnen
        let loc = CLLocation(latitude: pos.lat, longitude: pos.long)
        let dist = mylocmgr.location.distance(from: loc)
        lbllDistance.text = "--> " + String(format: "%.0f m", dist)
        
        //Richtung vom Standpunkt zum Ziel berechnen
        let toLat = pos.lat / 180 * .pi
        let toLong = pos.long / 180 * .pi
        let fromLat = mylocmgr.location.coordinate.latitude / 180 * .pi
        let fromLong = mylocmgr.location.coordinate.longitude / 180 * .pi
        let rad = atan2(sin(toLong - fromLong) * cos(toLat), cos(fromLat) * sin(toLat) - sin(fromLat) * cos(toLat) * cos(toLong - fromLong))
        heading = rad * 180 / .pi
    }
    @objc func notifyNewHeading(_ notification:Notification) {
        //Richtung von der aktuellen Richung zum Ziel ausrechnen
        arrowview.heading = mylocmgr.heading.trueHeading - heading + 90
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.backFromDetailVC(self)
    }
    
    @IBAction func deleteBtn(_ sender: UIButton) {
    //Dialog zusammenstellen
        let alert = UIAlertController(title: "Eintrag löschen", message: "Soll der aktuelle Eintrag wirklich gelöscht werden?", preferredStyle: .alert)
            //ja: deleteItem auf true setzen, dann Popup schließen
        alert.addAction(UIAlertAction(title: "Ja", style: .destructive, handler:
            { (_) in //closure
                self.deleteItem = true
                self.navigationController?.popViewController(animated: true)
        }
        ))
        //nein: keine Reaktion
        alert.addAction(UIAlertAction(title: "Nein", style: .cancel, handler: nil))
        
        //Dialog anzeigen
        present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DetailVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Eingabe beenden, Tastatur ausblenden
        view.endEditing(true)
        // Popup schließen
        _ = navigationController?.popViewController(animated: true)
        // 'Return' nicht als Eingabe weitergeben
        return false
    }
}
