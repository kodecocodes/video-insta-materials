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

import SwiftUI
import Combine

struct LoginSignupView: View {
  @State private var validationError = false
  @State private var requestError = false
  @State private var requestErrorText: String = ""
  @State var networkOperation: AnyCancellable?

  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }

  private func toggleState() {
//    authState = (authState == .signUp ? .signIn : .signUp)
  }

  private func doAuth() {
//    networkOperation?.cancel()
//    switch authState {
//    case .signIn:
//      doSignIn()
//    case .signUp:
//      doSignUp()
//    }
  }

  private func doSignIn() {
//    guard username.count > 0, password.count > 0 else {
//      validationError = true
//      return
//    }
//
//    let client = APIClient()
//    let request = SignInUserRequest(username: username, password: password)
//    networkOperation = client.publisherForRequest(request)
//      .sink(receiveCompletion: { result in
//        handleResult(result)
//      }, receiveValue: {_ in})
  }

  private func doSignUp() {
//    guard username.count > 0, email.count > 0, password.count > 0 else {
//      validationError = true
//      return
//    }
//
//    let client = APIClient()
//    let request = SignUpUserRequest(username: username, email: email, password: password)
//    networkOperation = client.publisherForRequest(request)
//      .sink(receiveCompletion: { result in
//        handleResult(result)
//      }, receiveValue: {_ in})
  }

  private func handleResult(_ result: Subscribers.Completion<Error>) {
//    if case .failure(let error) = result {
//      // TODO: we could check for 401 and show a nicer error
//      switch error {
//      case APIError.requestFailed(let statusCode):
//        requestErrorText = "Status code: \(statusCode)"
//      case APIError.postProcessingFailed(let innerError):
//        requestErrorText = "Error: \(String(describing: innerError))"
//      default:
//        requestErrorText = "An error occurred: \(String(describing: error))"
//      }
//    } else {
//      requestErrorText = ""
//      networkOperation = nil
//    }
//    requestError = requestErrorText.count > 0
  }
}

struct LoginSignupView_Previews: PreviewProvider {
  static var previews: some View {
    LoginSignupView()
  }
}
