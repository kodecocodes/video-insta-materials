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

extension UIImage {
  func filteredImages(filters: [CIFilter], includeOriginal: Bool = true) -> [UIImage] {
    var images: [UIImage] = []
    if includeOriginal {
      images.append(self)
    }
    let filteredImages = filters.compactMap({ filter in self.applying(filter: filter) })
    images.append(contentsOf: filteredImages)
    return images
  }

  func applying(filter: CIFilter) -> UIImage? {
    guard let ciImage = CIImage(image: self) else { return nil }
    filter.setValue(ciImage, forKey: kCIInputImageKey)
    guard let outputCIImage = filter.outputImage else { return nil }
    // When we create a UIImage from a CIImage, it treats the image differently. But, if we make the CIImage into a CGImage, and create the UIImage from that, it behaves as expected.
    let context = CIContext(options: nil)
    guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil }
    return UIImage(cgImage: cgImage)
  }

  /// UIImage can use metadata to rotate an image, but some apparent UIKit bugs cause the image to render incorrectly, so we physically rotate the image to normalize.
  func fixedOrientation() -> UIImage? {
    // When UIImage.draw(in:) renders the image, it uses the orientation metadata to do it. Then UIGraphicsGetImageFromCurrentImageContext gets the rotated image with the orientation already applied.
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    draw(in: CGRect(origin: .zero, size: size))
    let processedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return processedImage
  }
}
