//
//  LaunchViewModel.swift
//  DragonBall
//
//  Created by Victoria Aloy on 20/9/22.
//

import Foundation

protocol LaunchViewModelProtocol: AnyObject {
    func onViewsLoaded()
}

class LaunchViewModel {
    
    private let keyChain = KeyChainStore()
    private weak var viewDelegate: LaunchViewProtocol?
    
    init(viewDelegate: LaunchViewProtocol?) {
        self.viewDelegate = viewDelegate
    }
    
    private func isAlreadyLoggedIn() -> Bool{
        if(!UserDefaultsData.isOpened()){
            keyChain.delete(service: KeyChainConstant.service, account: KeyChainConstant.loginTokenAccount)
            UserDefaultsData.setOpened()
            return false
        }else{
            return keyChain.read(service: KeyChainConstant.service, account: KeyChainConstant.loginTokenAccount) != nil
        }
        
    }
    
    private func onLoggedIn(){
        var time: DispatchTime {
           .now() + .seconds(3)
       }
        if(isAlreadyLoggedIn()){
            executeUserInterfaceTaskDelayed(time: time) {
                self.viewDelegate?.onNavigateHome()
            }
        }else{
            executeUserInterfaceTaskDelayed(time: time) {
                self.viewDelegate?.onNavigateLogin()
            }
        }
    }
    
}

extension LaunchViewModel: LaunchViewModelProtocol {
    
    func onViewsLoaded() {
        onLoggedIn()
    }

}
