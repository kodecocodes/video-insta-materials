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

import UIKit
import Combine

final class PostController: ObservableObject {
  @Published var isRunning = false
  @Published var postUploaded = false
  private var subscriptions: Set<AnyCancellable> = []

  func uploadPost(withDescription description: String, image: UIImage) {
    isRunning = true
    let client = APIClient()
    let request = CreateNewPostRequest(caption: description)
    client.publisherForRequest(request)
      .tryMap { post -> (UUID, Data) in
        guard let imageId = post.id, let imageData = image.jpegData(compressionQuality: 80) else {
          throw APIError.postProcessingFailed(nil)
        }
        return (imageId, imageData)
      }
      .flatMap { (imageId, imageData) -> AnyPublisher<Void, Error> in
        let imageRequest = UploadImageRequest(imageId: imageId, imageData: imageData)
        return client.publisherForRequest(imageRequest)
      }
      .sink(receiveCompletion: { completion in
        self.isRunning = false
        self.postUploaded = true
      }, receiveValue: { value in
      })
      .store(in: &subscriptions)
  }
}
