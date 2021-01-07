/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest
import Swifter
import Combine
@testable import Petstagram

class APIClientTests: XCTestCase {
  var server = HttpServer()

  override func setUpWithError() throws {
    server.notFoundHandler = { [weak self] request in
      let attachment = XCTAttachment(string: "\(request.method) on \(request.path) requested, but not found")
      attachment.name = "Unhandled API path requested"
      attachment.lifetime = .keepAlways
      self?.add(attachment)
      return .notFound
    }
    do {
      try server.start()
    } catch {
      XCTFail("Could not start Swifter")
    }
  }

  override func tearDownWithError() throws {
    server.stop()
  }

  func testPublisherForRequest() {
    server.GET["/api/v1/posts"] = { _ in HttpResponse.ok(.text(JsonData.goodFeed)) }
    let request = PostRequest()
    let client = APIClient(environment: .local)

    var networkResult: Subscribers.Completion<Error>?
    var fetchedPosts: [Post]?
    let networkExpectation = expectation(description: "Network request")

    let cancellable = client.publisherForRequest(request)
      .sink { result in
        networkResult = result
        XCTAssertTrue(Thread.current.isMainThread, "Network completion called on background thread")
        networkExpectation.fulfill()
      } receiveValue: { posts in
        fetchedPosts = posts
      }

    wait(for: [networkExpectation], timeout: 3)
    cancellable.cancel()

    guard let result = networkResult else {
      XCTFail("No result from network request")
      return
    }
    switch result {
    case .finished:
      XCTAssertEqual(fetchedPosts?.count ?? 0, 3)
    case .failure(let error):
      XCTFail(error.localizedDescription)
    }
  }
}
