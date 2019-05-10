//
//  Installer.swift
//  WiFiMobileConfig
//
//  Created by Magic.io on 5/10/19.
//

import Foundation

protocol Installer {
    func install(mobileConfig: MobileConfig) -> InstallationResult
    func installed(mobileConfig: MobileConfig) -> Bool
}

public enum InstallationResult: Equatable {
    case success
    case confirming
    case failed(because: InstallationFailure)
}


public enum InstallationFailure: Equatable {
    case cliProblem(reason: String)
    case locatingUserDirectoryProblem(reason: String)
    case writingToUserDirectoryProblem(reason: String)
    case distributionServerProblem(MobileConfigDistributionServerState.FailureReason)
    case serializationProblem(PlistDocument.SerializationFailureReason)
}
