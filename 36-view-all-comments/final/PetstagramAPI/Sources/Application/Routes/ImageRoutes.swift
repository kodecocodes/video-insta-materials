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
import Credentials
import CredentialsHTTP

func initializeImageRoutes(app: App) throws {
  initializeBasicAuth(app: app)
  let fileServer = try setupFileServer()
  app.router.get("/api/v1/images", middleware: fileServer)
  app.router.post("/api/v1/image") { request, response, next in
    defer { next() }

    guard let filename = request.headers["Slug"] else {
      response.status(.preconditionFailed).send("Filename not specified")
      return
    }
    var imageData = Data()
    do {
      try _ = request.read(into: &imageData)
    } catch let readError {
      response.status(.internalServerError).send("Unable to read image data: \(readError.localizedDescription)")
      return
    }
    do {
      let fullPath = "\(fileServer.absoluteRootPath)/\(filename)"
      let fileUrl = URL(fileURLWithPath: fullPath)
      try imageData.write(to: fileUrl)
      response.status(.created).send("Image created")
    } catch let writeError {
      response.status(.internalServerError).send("Unable to write image data: \(writeError.localizedDescription)")
      return
    }
  }
}

func initializeBasicAuth(app: App) {
  let credentials = Credentials()
  let basicCredentials = CredentialsHTTPBasic(verifyPassword: { username, password, credentialsCallback in
    UserAuthentication.verifyPassword(username: username, password: password, callback: { user in
      if user != nil {
        let profile = UserProfile(id: username, displayName: username, provider: "HTTPBasic")
        credentialsCallback(profile)
      } else {
        credentialsCallback(nil)
      }
    })
  })
  credentials.register(plugin: basicCredentials)
  app.router.all("/api/v1/images", middleware: credentials)
  app.router.post("/api/v1/image", middleware: credentials)
}

private func setupFileServer() throws -> StaticFileServer {
  let cacheOptions = StaticFileServer.CacheOptions(maxAgeCacheControlHeader: 3600)
  let options = StaticFileServer.Options(cacheOptions: cacheOptions)
  let fileServer = StaticFileServer(path: "images", options: options)
  try FileManager.default.createDirectory(atPath: fileServer.absoluteRootPath, withIntermediateDirectories: true, attributes: nil)
  return fileServer
}
