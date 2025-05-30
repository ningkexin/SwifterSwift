// UINavigationControllerExtensionsTests.swift - Copyright 2025 SwifterSwift

@testable import SwifterSwift
import XCTest

#if canImport(UIKit) && !os(watchOS)
import UIKit

@MainActor
final class UINavigationControllerExtensionsTests: XCTestCase {
    func testPushViewController() {
        let navigationController = UINavigationController()
        let vcToPush = UIViewController()

        let exp = expectation(description: "pushCallback")

        navigationController.pushViewController(vcToPush) {
            XCTAssertEqual(navigationController.viewControllers.count, 1)
            XCTAssertEqual(navigationController.topViewController, vcToPush)
            exp.fulfill()
        }
        waitForExpectations(timeout: 5)
    }

    func testPopViewController() {
        let rootVC = UIViewController()
        let navigationController = UINavigationController(rootViewController: rootVC)
        let vcToPush = UIViewController()
        navigationController.pushViewController(vcToPush, animated: false)
        XCTAssertEqual(navigationController.viewControllers.count, 2)

        let exp = expectation(description: "popCallback")
        navigationController.popViewController(animated: false) {
            XCTAssertEqual(navigationController.viewControllers.count, 1)
            XCTAssertEqual(navigationController.topViewController, rootVC)
            exp.fulfill()
        }
        waitForExpectations(timeout: 5)
    }

    func testMakeTransparent() {
        let navigationController = UINavigationController(rootViewController: UIViewController())
        navigationController.makeTransparent(withTint: .red)
        let navBar = navigationController.navigationBar
        XCTAssertNotNil(navBar.shadowImage)
        XCTAssert(navBar.isTranslucent)
        XCTAssertEqual(navBar.tintColor, UIColor.red)

        let attrs = navBar.titleTextAttributes
        XCTAssertNotNil(attrs)
        let color = attrs![.foregroundColor] as? UIColor
        XCTAssertNotNil(color)
        XCTAssertEqual(color!, .red)
    }

    #if !os(tvOS)
    func testHideBottomBar() {
        let rootVC = UIViewController()
        let navigationController = UINavigationController(rootViewController: rootVC)
        let vcToPush = UIViewController()
        let tabVC = UITabBarController()
        tabVC.viewControllers = [navigationController]
        navigationController.pushViewController(vcToPush, hidesBottomBar: true, animated: false)
        XCTAssert(vcToPush.hidesBottomBarWhenPushed)
        XCTAssert(tabVC.tabBar.isHidden)
    }
    #endif
}
#endif
