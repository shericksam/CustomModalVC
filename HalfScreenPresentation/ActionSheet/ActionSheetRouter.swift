//
//  ActionSheetRouter.swift
//  ellavevirtual
//
//  Created by Digital on 22/07/21.
//  Copyright © 2021 Scotiabank México. All rights reserved.
//

import Foundation
import UIKit

class ActionSheetRouter: ActionSheetPresenterToRouterProtocol {
    
    class func createActionSheetViewController(controller: UIViewController, initSize: SheetSize = .percent(0.40)) -> ActionSheetViewController {
        let viewController: ActionSheetViewController = .init(controller: controller, initSize: initSize)
        let presenter: ActionSheetViewToPresenterProtocol & ActionSheetInteractorToPresenterProtocol = ActionSheetPresenter()
        let interactor: ActionSheetPresenterToInteractorProtocol = ActionSheetInteractor()
        let router: ActionSheetPresenterToRouterProtocol = ActionSheetRouter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return viewController
    }
    
    class func createActionSheetViewController(view: UIView, initSize: SheetSize = .percent(0.40)) -> ActionSheetViewController {
        let viewController: ActionSheetViewController = .init(view: view, initSize: initSize)
        let presenter: ActionSheetViewToPresenterProtocol & ActionSheetInteractorToPresenterProtocol = ActionSheetPresenter()
        let interactor: ActionSheetPresenterToInteractorProtocol = ActionSheetInteractor()
        let router: ActionSheetPresenterToRouterProtocol = ActionSheetRouter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return viewController
    }
}
