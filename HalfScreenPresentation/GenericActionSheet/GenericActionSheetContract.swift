//
//  GenericActionSheetContract.swift
//  ellavevirtual
//
//  Created by Digital on 18/07/21.
//  Copyright © 2021 Scotiabank México. All rights reserved.
//

import Foundation
import UIKit

protocol GenericActionSheetViewToPresenterProtocol: class {
    var view: GenericActionSheetPresenterToViewProtocol? { get set }
    var interactor: GenericActionSheetPresenterToInteractorProtocol? { get set }
    var router: GenericActionSheetPresenterToRouterProtocol? { get set }
    
    func viewDidLoad()
}

protocol GenericActionSheetPresenterToViewProtocol: class {
}

protocol GenericActionSheetPresenterToRouterProtocol: class {
    static func createGenericActionSheetViewController(controller: UIViewController, initSize: SheetSize) -> GenericActionSheetViewController
}

protocol GenericActionSheetInteractorToPresenterProtocol: class {
}

protocol GenericActionSheetPresenterToInteractorProtocol: class {
    var presenter: GenericActionSheetInteractorToPresenterProtocol? { get set }
}
