//
//  AuthViewController.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 10.12.2020.
//

import UIKit
import Firebase
import GoogleSignIn

class AuthViewController: UIViewController {
    
    private lazy var signInButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Authorization"
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        setupUI()
        checkToken()
    }
    
    private let padding: CGFloat = 20
    
    func setupUI() {
        view.addSubview(signInButton)
        
        NSLayoutConstraint.activate([
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        view.backgroundColor = .white
    }
    
    func checkToken() {
        if let id = AppConfig.shared.idToken,
           let token = AppConfig.shared.accessToken {
            signIn(idToken: id, accessToken: token)
        }
    }
}

extension AuthViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let _ = error {
            return
        }
        
        guard let authentication = user.authentication else { return }
        self.signIn(idToken: authentication.idToken, accessToken: authentication.accessToken)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func signIn(idToken: String, accessToken: String) {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            if let error = error {
                return
            }
            
            AppConfig.shared.currentUser = authResult?.user
            AppConfig.shared.idToken = idToken
            AppConfig.shared.accessToken = accessToken
            
            let nc = UINavigationController(rootViewController: NewsViewController())
            nc.modalTransitionStyle = .crossDissolve
            nc.modalPresentationStyle = .fullScreen
            self?.present(nc, animated: true)
        }
    }
}
