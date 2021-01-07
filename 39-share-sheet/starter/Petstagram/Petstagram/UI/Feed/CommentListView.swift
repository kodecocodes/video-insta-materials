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

struct CommentListView: View {
  var image: UIImage
  private let postId: UUID
  @StateObject var list: CommentList
  @State var newCommentDescription = ""
  @State private var subscriptions: Set<AnyCancellable> = []

  fileprivate init(comments: [Comment], image: UIImage) {
    let newId = UUID()
    let displayList = CommentList(forPostId: newId)
    displayList.comments.append(contentsOf: comments)
    self._list = StateObject(wrappedValue: displayList)
    self.image = image
    self.postId = newId
  }

  init(forPostId postId: UUID, image: UIImage) {
    self._list = StateObject(wrappedValue: CommentList(forPostId: postId))
    self.image = image
    self.postId = postId
  }

  var body: some View {
    VStack(alignment: .leading) {
      ScrollView {
        HStack {
          Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 160)
            .clipped()
          Spacer()
        }

        ForEach(list.comments) { comment in
          CommentCell(comment: comment)
          Divider()
        }
      }

      HStack(spacing: 2) {
        TextField("Add a comment...", text: $newCommentDescription)
          .padding(7)
          .background(Color.paleGrey)
          .clipShape(SelectiveRoundedRectangle(corners: [.topLeft, .bottomLeft], radius: 7))
        Button("Post", action: addComment)
          .padding(8)
          .accentColor(.accentGreen)
          .background(Color.paleGrey)
          .clipShape(SelectiveRoundedRectangle(corners: [.topRight, .bottomRight], radius: 7))
      }
    }
    .padding()
    .navigationBarTitle("Comments")
    .navigationBarTitleDisplayMode(.inline)
  }

  private func addComment() {
    guard newCommentDescription.isEmpty == false else { return }
    let client = APIClient()
    let request = AddCommentToPostRequest(postId: postId, caption: newCommentDescription)
    client.publisherForRequest(request)
      .sink(receiveCompletion: { result in
        if case .finished = result {
          newCommentDescription = ""
        }
      }, receiveValue: {newComment in
        list.comments.append(newComment)
      })
      .store(in: &subscriptions)
  }
}

struct SelectiveRoundedRectangle: Shape {
  let corners: UIRectCorner
  let radius: CGFloat
  func path(in rect: CGRect) -> Path {
    let bPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    return Path(bPath.cgPath)
  }
}

struct CommentListView_Previews: PreviewProvider {
  static var previews: some View {
    let postId = UUID()
    let comment1 = Comment(postId: postId, createdBy: "User 1", createdAt: Date(), caption: "Comment 1")
    let comment2 = Comment(postId: postId, createdBy: "User 2", createdAt: Date(), caption: "Comment 2")
    return
      NavigationView {
        CommentListView(comments: [comment1, comment2], image: UIImage(named: "puppies")!)
      }
  }
}
