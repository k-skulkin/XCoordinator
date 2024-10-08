//
//  Presentable.swift
//  XCoordinator
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// Presentable represents all objects that can be presented (i.e. shown) to the user.
///
/// Therefore, it is useful for view controllers, coordinators and views.
/// Presentable is often used for transitions to allow for view controllers and coordinators to be transitioned to.
///
public protocol Presentable {

    ///
    /// The viewController of the Presentable.
    ///
    /// In the case of a `UIViewController`, it returns itself.
    /// A coordinator returns its rootViewController.
    ///
	@MainActor var viewController: UIViewController! { get }

    ///
    /// This method can be used to retrieve whether the presentable can trigger a specific route
    /// and potentially returns a router to trigger the route on.
    ///
    /// Deep linking makes use of this method to trigger the specified routes.
    ///
    /// - Parameter route:
    ///     The route to determine a router for.
    ///
	@MainActor func router<R: Route>(for route: R) -> (any Router<R>)?

    ///
    /// This method is called whenever a Presentable is shown to the user.
    /// It further provides information about the context a presentable is shown in.
    ///
    /// - Parameter presentable:
    ///     The context in which the presentable is shown.
    ///     This could be a window, another viewController, a coordinator, etc.
    ///     `nil` is specified whenever a context cannot be easily determined.
    ///
	@MainActor func presented(from presentable: (any Presentable)?)

    ///
    /// This method is used to register a parent coordinator to a child coordinator.
    ///
    /// - Note:
    ///     This method is used internally and should never be called directly.
    ///
	@MainActor func registerParent(_ presentable: any Presentable & AnyObject)

    ///
    /// This method gets called when the transition of a child coordinator is being reported to its parent.
    ///
    /// - Note:
    ///     This method is used internally and should never be called directly.
    ///
	@MainActor func childTransitionCompleted()

    ///
    /// Sets the presentable as the root of the window.
    ///
    /// This method sets the rootViewController of the window and makes it key and visible.
    /// Furthermore, it calls `presented(from:)` with the window as its parameter.
    ///
    /// - Parameter window:
    ///     The window to set the root of.
    ///
	@MainActor func setRoot(for window: UIWindow)
}

extension Presentable {
    
    public func registerParent(_ presentable: any Presentable & AnyObject) {}

    public func childTransitionCompleted() {}

	@MainActor public func setRoot(for window: UIWindow) {
        let previousRoot = window.rootViewController
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        presented(from: window)

        if let previousRoot {
            previousRoot.removeFromParent()
            previousRoot.dismiss(animated: false) {
                previousRoot.viewIfLoaded?.removeFromSuperview()
            }
        }
    }

    public func presented(from presentable: (any Presentable)?) {}

    ///
    /// Returns the value as an `any Presentable`.
    ///
    /// This might be useful when getting an error "Runtime support for parameterized protocol types is only available in iOS 16.0.0 or newer" to still use these objects in transitions.
    ///
    public var asPresentable: any Presentable { self }

}

extension UIViewController: Presentable {
    public func router<R: Route>(for route: R) -> (any Router<R>)? {
        nil
    }
}
extension UIWindow: Presentable {
    public func router<R: Route>(for route: R) -> (any Router<R>)? {
        nil
    }
}
