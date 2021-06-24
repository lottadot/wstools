//
//  BAWebsocketTests.swift
//  BAWebsocketTests
//
//  Created by Shane Zatezalo on 6/24/21.
//

import XCTest
@testable import BAWebsocket
import Starscream

class BAWebsocketTests: XCTestCase {

	var mockDelegate: WebSocketMockDelegate!

	override func setUp() {
		mockDelegate = WebSocketMockDelegate()
	}

    func testSocketConnection() throws {
		let hostname = "storefront.bankofamerica.com"
		let path = "/mblm/S2/ios/mobile/dsa/dsaservice"
		guard let URL = URL(string: hostname + path) else {
			XCTFail()
			return
		}

		let expectation = expectation(description: WebSocketDelegateExpectation.connected.rawValue)
		mockDelegate.asyncExpectations.append(expectation)

		var request = URLRequest(url: URL)
		request.timeoutInterval = 5
		let socket = WebSocket(request: request)
		socket.delegate = mockDelegate
		socket.connect()

		socket.onEvent = { [self] event in
			print("NOTE: Received event via closure NOT delegate. Delegate is\(nil != socket.delegate ? " NOT" : "") nil.")
			self.mockDelegate.didReceive(event: event, client: socket)
		}

		wait(for: [expectation], timeout: 5)
		mockDelegate.validateExpectation(with: WebSocketDelegateExpectation.connected.rawValue)
    }
}
