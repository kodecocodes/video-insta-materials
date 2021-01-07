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
import Kitura

func initializeLikeRoutes(app: App) {
  app.router.post("/api/v1/likes", handler: addLike)
  app.router.delete("/api/v1/likes", handler: deleteLike)
}

func addLike(user: UserAuthentication, like: Like, completion: @escaping (Like?, RequestError?) -> Void) {
  var newLike = like
  if newLike.createdByUser != user.id {
    return completion(nil, RequestError.forbidden)
  }
  if newLike.id == nil {
    newLike.id = UUID()
  }
  newLike.save(completion)
}

func deleteLike(user: UserAuthentication, query: LikeParams, completion: @escaping (RequestError?) -> Void) {
  if query.createdByUser != user.id {
    return completion(RequestError.forbidden)
  }
  Like.findAll(matching: query) { foundLikes, error in
    guard let foundLike = foundLikes?.first else {
      return completion(error ?? .notFound)
    }
    guard let likeId = foundLike.id else {
      return completion(.ormInternalError)
    }
    Like.delete(id: likeId, completion)
  }
}
