//
//  SaveVC.swift
//  ios-treasure
//
//  Created by Mario Holper on 13.10.19.
//  Copyright © 2019 Mario Holper. All rights reserved.
//

import UIKit

class SaveVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var posname: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        posname.delegate = self
        
        //Fokus in Textfeld setzen, Tastatur erscheint
        posname.becomeFirstResponder()
    }
    
      //bei return ausblenden
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Eingabe beenden, Tastatur ausblenden
        view.endEditing(true)
        
        //Segue zu View 2 initiieren
        performSegue(withIdentifier: "SegueUnwindSaveToMain", sender: self)
        //'return' nicht als Eingabe weitergeben
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
