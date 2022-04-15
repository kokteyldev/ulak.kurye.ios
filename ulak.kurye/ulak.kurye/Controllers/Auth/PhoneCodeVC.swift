//
//  PhoneCodeVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.03.2022.
//

import UIKit

protocol PhoneCodeVCDelegate: AnyObject {
    func didSelectCountry(country: Country)
}

final class PhoneCodeVC: BaseVC {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    weak var delegate: PhoneCodeVCDelegate?
    private var countries = PhoneHelper.getCountries()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        navigationBar.title = "country_phone_code".localized
    }
    
    // MARK: - Presenter
    static func present(fromVC: UIViewController, delegate: PhoneCodeVCDelegate) {
        DispatchQueue.main.async {
            let sb = UIStoryboard(name: "Auth", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "PhoneCodeVC") as! PhoneCodeVC
            vc.delegate = delegate
            
            fromVC.present(vc, animated: true, completion: nil)
        }
    }
    
    //MARK: - Actions
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - TableViewDelegate, TableViewDatasource
extension PhoneCodeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneCodeTVC", for: indexPath) as! PhoneCodeTVC
        cell.setCountry(countries[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.delegate?.didSelectCountry(country: self.countries[indexPath.row])
        }
    }
}




