import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health
import KituraOpenAPI

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
  let router = Router()
  let cloudEnv = CloudEnv()

  public init() throws {
    // Configure logging
    initializeLogging()
    Persistence.setUp()
    // Run the metrics initializer
    initializeMetrics(router: router)
  }

  func postInit() throws {
    // Endpoints
    initializeHealthRoutes(app: self)
    initializePostRoutes(app: self)
    initializeUserRoutes(app: self)
    try initializeImageRoutes(app: self)
    initializeLikeRoutes(app: self)
    initializeCommentRoutes(app: self)
    KituraOpenAPI.addEndpoints(to: router)
  }

  public func run() throws {
    try postInit()
    let certificateKeyFile = "\(projectPath)/certs/PetstagramAPI.p12"
    let config = SSLConfig(withChainFilePath: certificateKeyFile, withPassword: "petstagram", usingSelfSignedCerts: false)
    Kitura.addHTTPServer(onPort: cloudEnv.port, with: router, withSSL: config)
    Kitura.run()
  }
}
