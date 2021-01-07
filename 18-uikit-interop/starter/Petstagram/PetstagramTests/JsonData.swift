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

import Foundation

enum JsonData {
  static let goodFeed = """
          [
            {
              "id": "210B9863-F7CC-4298-BA78-2A6C73D7D002",
              "createdAt": "2020-04-01T12:00:00Z",
              "caption": "Living her best life! #corgi #puppyStyle",
              "createdByUser": "corgistuff"
            },
            {
              "id": "144C56D1-F4D8-4BD2-8C9F-AAB87BA8B1C6",
              "createdAt": "2020-03-11T04:44:00Z",
              "caption": "Bath time is best time!",
              "createdByUser": "petcare47"
            },
            {
              "id": "823DE4BB-7FE9-41E6-A72E-208A6A6C5662",
              "createdAt": "2020-01-03T17:32:00Z",
              "caption": "Not sure if alien or dog...",
              "createdByUser": "truthisoutthere"
            }
          ]
          """

  static let badJson = """
    [
      "bad json"
    ]
    """

  static let goodSignUp = """
    {
      "username": "username",
      "email": "email@example.com"
    }
    """
}
