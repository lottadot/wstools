//
//  WebSocketMockDelegate.swift
//  BAWebsocketTests
//
//  Created by Shane Zatezalo on 6/24/21.
//

import Foundation
import Starscream
import XCTest

protocol ExpectationHandling {
	func validateExpectation(with description: String)
}

enum WebSocketDelegateExpectation: String {
	case connected, disconnected, text, binary, ping, pong, viabilityChanged, reconnectSuggested, cancelled, error
}

class WebSocketMockDelegate {
	var asyncExpectations: [XCTestExpectation] = []
}

extension WebSocketMockDelegate: WebSocketDelegate {
	func didReceive(event: WebSocketEvent, client: WebSocket) {

		switch event {
			case .connected(let headers):
				validateExpectation(with: WebSocketDelegateExpectation.connected.rawValue)
				print("websocket is connected: \(headers)")
			case .disconnected(let reason, let code):
				validateExpectation(with: WebSocketDelegateExpectation.disconnected.rawValue)
				print("websocket is disconnected: \(reason) with code: \(code)")
			case .text(let string):
				validateExpectation(with: WebSocketDelegateExpectation.text.rawValue)
				print("Received text: \(string)")
			case .binary(let data):
				validateExpectation(with: WebSocketDelegateExpectation.binary.rawValue)
				print("Received data: \(data.count)")
			case .ping(_):
				validateExpectation(with: WebSocketDelegateExpectation.ping.rawValue)
				break
			case .pong(_):
				validateExpectation(with: WebSocketDelegateExpectation.pong.rawValue)
				break
			case .viabilityChanged(_):
				validateExpectation(with: WebSocketDelegateExpectation.viabilityChanged.rawValue)
				break
			case .reconnectSuggested(_):
				validateExpectation(with: WebSocketDelegateExpectation.reconnectSuggested.rawValue)
				break
			case .cancelled:
				validateExpectation(with: WebSocketDelegateExpectation.cancelled.rawValue)
			case .error(let error):
				validateExpectation(with: WebSocketDelegateExpectation.error.rawValue)
			print("error: \(String(describing: error?.localizedDescription))")
			}
	}
}

extension WebSocketMockDelegate: ExpectationHandling {
	func validateExpectation(with description: String) {
		guard let expectation = asyncExpectations.filter({ $0.description.lowercased() == description.lowercased()}).first, let index = asyncExpectations.firstIndex(of: expectation) else {
			return
		}

		expectation.fulfill()
		asyncExpectations.remove(at: index)
	}
}
