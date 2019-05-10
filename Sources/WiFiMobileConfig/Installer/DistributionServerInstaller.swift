//
//  DistributionServerInstaller.swift
//  WiFiMobileConfig
//
//  Created by Magic.io on 5/10/19.
//

import Swifter
import Foundation

public class DistributionServerInstaller: Installer {
    fileprivate let distributionServer: MobileConfigDistributionServer
    fileprivate let distributionServerStatus: MobileConfigDistributionServerState
    
    public init(
        distributingBy distributionServer: MobileConfigDistributionServer
        ) {
        self.distributionServer = distributionServer
        self.distributionServerStatus = distributionServer.start()
    }
    
    public static func install(mobileConfig: MobileConfig) -> InstallationResult {
        return .failed(because: .distributionServerProblem("Must used instanced installer instead of static function"))
    }
    
    public func install(mobileConfig: MobileConfig) -> InstallationResult {
        switch self.distributionServerStatus {
        case .failed(because: let reason):
            return .failed(because: .distributionServerProblem(reason))
            
        case .successfullyStarted:
            switch mobileConfig.generatePlist().serializeAsPlistXML() {
            case .success(let data):
                self.distributionServer.update(
                    mobileConfigData: data,
                    mimeType: MIMEType.mobileConfig.text
                )
                return .confirming
                
            case .failed(because: let reason):
                return .failed(because: .serializationProblem(reason))
            }
        }
    }
    
    public static func installed(mobileConfig: MobileConfig) -> Bool {
        return false
    }
    
    
    //        public func keepDistributionServerForBackground(for application: UIApplication) {
    //            var taskIdentifier: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    //
    //            taskIdentifier = application.beginBackgroundTask(withName: "Awaiting install a provisioning profile") {
    //                DispatchQueue.main.async {
    //                    application.endBackgroundTask(taskIdentifier)
    //                    taskIdentifier = UIBackgroundTaskInvalid
    //                }
    //            }
    //        }
}

public protocol MobileConfigDistributionServer {
    var distributionURL: URL { get }
    func start() -> MobileConfigDistributionServerState
    func update(mobileConfigData: Data, mimeType: String)
}



public enum MobileConfigDistributionServerState: Equatable {
    case successfullyStarted
    case failed(because: FailureReason)
    
    public typealias FailureReason = String
}
