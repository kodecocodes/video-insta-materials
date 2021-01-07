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
import SwiftUI

class TakePhotoViewController: UIViewController {
  @IBOutlet var previewView: CameraPreviewView!
  var captureController: PhotoCaptureController!
  let completionHandler: (UIImage) -> Void

  init?(coder: NSCoder, completionHandler: @escaping (UIImage) -> Void) {
    self.completionHandler = completionHandler
    super.init(coder: coder)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    captureController = PhotoCaptureController(previewView: previewView, alertPresenter: self, captureCompletionHandler: completionHandler)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    captureController.startSession()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    captureController.stopSession()
  }

  @IBAction func shutterButtonTapped() {
    captureController.capturePhoto()
  }
}

struct TakePhotoView: UIViewControllerRepresentable {
  let onPhotoCapture: (UIImage) -> Void

  func makeUIViewController(context: Context) -> TakePhotoViewController {
    let storyboard = UIStoryboard(name: "TakePhotoStoryboard", bundle: nil)
    let controller = storyboard.instantiateInitialViewController { coder in
      TakePhotoViewController(coder: coder, completionHandler: onPhotoCapture)
    }
    return controller!
  }

  func updateUIViewController(_ uiViewController: TakePhotoViewController, context: Context) {
    // Nothing to do in an update with this view controller
  }
}

struct TakePhotoView_Previews: PreviewProvider {
  static var previews: some View {
    return TakePhotoView(onPhotoCapture: {_ in})
  }
}
