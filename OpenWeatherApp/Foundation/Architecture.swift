//
//  Architecture.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 5/12/20.
//

import UIKit

@dynamicMemberLookup
protocol Injectable {
    associatedtype Dependencies

    var dependencies: Dependencies { get mutating set }
}

extension Injectable {
    subscript<T>(dynamicMember keyPath: WritableKeyPath<Dependencies, T>) -> T {
        get { self[keyPath: (\Self.dependencies).appending(path: keyPath)] }
        set { self[keyPath: (\Self.dependencies).appending(path: keyPath)] = newValue }
    }
}

protocol InitInjectable: Injectable {
    init(dependencies: Dependencies)
}

// MARK: - DI
protocol FoundationInjection {}
protocol ServiceInjection {}
protocol UseCaseInjection {}

protocol InteractionInjection {}
protocol PresentationInjection {}
protocol ViewableInjection {}

// MARK: - Foundation
protocol FoundationDependencies: FoundationInjection {}
protocol Foundation: InitInjectable where Dependencies: FoundationDependencies {}

// MARK: - Service
protocol ServiceDependencies: ServiceInjection, FoundationInjection {}
protocol Service: InitInjectable where Dependencies: ServiceDependencies {}

// MARK: - UseCase
protocol UseCaseDependencies: ServiceInjection {}
protocol UseCase: InitInjectable where Dependencies: UseCaseDependencies {}

// MARK: - Scenes
protocol ScenesInjectable: Injectable {
    associatedtype Configuration

    var configuration: Configuration { get }

    init(dependencies: Dependencies, configuration: Configuration)
}

extension ScenesInjectable where Configuration == Void {
    var configuration : Void { () }

    init(dependencies: Dependencies) {
        self.init(dependencies: dependencies, configuration: ())
    }
}

// MARK: - Interaction
protocol InteractionDependencies: InteractionInjection, UseCaseInjection {}
protocol Interaction: ScenesInjectable where Dependencies: InteractionDependencies {}

// MARK: - Presentation
protocol PresentationDependencies: PresentationInjection {}
protocol Presentation: ScenesInjectable where Dependencies: PresentationDependencies {}

// MARK: - View
protocol ViewableDependencies: ViewableInjection {}
protocol Viewable: Injectable where Dependencies: ViewableDependencies {}

// Scene Life Cycle
protocol SceneObserver: class {
    func sceneDidLoad()
    func sceneWillAppear()
    func sceneDidAppear()
    func sceneWillDisappear()
    func sceneDidDisappear()
}

extension SceneObserver {
    func sceneDidLoad() {}
    func sceneWillAppear() {}
    func sceneDidAppear() {}
    func sceneWillDisappear() {}
    func sceneDidDisappear() {}
}

protocol SceneController {
    var sceneObserver: SceneObserver? { get }
}

fileprivate extension UIViewController {
    var sceneObserver: SceneObserver? {
        (self as? SceneController)?.sceneObserver
    }
}

class SceneViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneObserver?.sceneDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneObserver?.sceneWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sceneObserver?.sceneDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneObserver?.sceneWillDisappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sceneObserver?.sceneDidDisappear()
    }
}

// MARK: - VIP Scenes
// MARK: - VIPInteractor
protocol VIPInteractorDependencies: InteractionDependencies {
    associatedtype Presenter

    var presenter: Presenter { get }

    init(presenter: Presenter)
}

protocol VIPInteractor: Interaction, SceneObserver where Dependencies: VIPInteractorDependencies {}

// MARK: - VIPPresenter
protocol VIPPresenterDependencies: PresentationDependencies {
    associatedtype View

    var view: View { get }

    init(view: View)
}

protocol VIPPresenter: Presentation where Dependencies: VIPPresenterDependencies {}

// MARK: - VIPView
protocol VIPViewDependencies: ViewableDependencies {
    associatedtype Interactor

    var interactor: Interactor { get }

    init(interactor: Interactor)
}

protocol VIPView: Viewable, SceneController where Dependencies: VIPViewDependencies {
    associatedtype Injector

    var injector: Injector { get }
}

extension VIPView {
    var interactor: Dependencies.Interactor { dependencies.interactor }
    var sceneObserver: SceneObserver? { interactor as? SceneObserver }
}

// MARK: - Scene DI
struct VIPInjector<V: VIPView, I: VIPInteractor, P: VIPPresenter> {
    var presenterConfiguration: P.Configuration?
    var interactorConfiguration: I.Configuration?

    func inject(view: V) -> V.Dependencies {
        guard let pConfig = presenterConfiguration,
              let iConfig = interactorConfiguration else {
            preconditionFailure("Invalid scene configuration values")
        }

        guard let view = view as? P.Dependencies.View else {
            preconditionFailure("Unable to find View in Scene")
        }

        guard let presenter = P(dependencies: .init(view: view), configuration: pConfig) as? I.Dependencies.Presenter else {
            preconditionFailure("Unable to find Presenter in Scene")
        }

        guard let interactor = I(dependencies: .init(presenter: presenter), configuration: iConfig) as? V.Dependencies.Interactor else {
            preconditionFailure("Unable to find Interactor in Scene")
        }

        return V.Dependencies(interactor: interactor)
    }
}

extension VIPInjector where P.Configuration == Void, I.Configuration == Void {
    init() {
        presenterConfiguration = ()
        interactorConfiguration = ()
    }
}

extension VIPInjector where P.Configuration == Void {
    init() {
        presenterConfiguration = ()
    }
}

extension VIPInjector where I.Configuration == Void {
    init() {
        interactorConfiguration = ()
    }
}
