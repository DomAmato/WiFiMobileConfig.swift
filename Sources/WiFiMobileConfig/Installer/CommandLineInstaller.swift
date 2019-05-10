//
//  CommandLineInstaller.swift
//  WiFiMobileConfig
//
//  Created by Magic.io on 5/10/19.
//

import Foundation

public class CommandLineInstaller: Installer {

    public static func install(mobileConfig: MobileConfig) -> InstallationResult {
        
        do {
            // get the documents folder url
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                // create the destination url for the text file to be saved
                let fileURL = documentDirectory.appendingPathComponent("magic.mobileconfig")
                // writing to disk
                try mobileConfig.generatePlist().serializeAsPlistXML().data!.write(to: fileURL, options: .atomicWrite)
                
                let task = Process()
                task.launchPath = "/usr/bin"
                task.arguments = ["profiles", "install", "-path=\(fileURL.absoluteString)", "-user=\(NSUserName())"
                ]
                task.launch()
                task.waitUntilExit()
                let status = task.terminationStatus
                
                try FileManager.default.removeItem(at: fileURL)
                
                if status.signum() == 0 {
                    return InstallationResult.success
                }
                return .failed(because: .cliProblem(reason: status.description))
            } else {
                return .failed(because: .locatingUserDirectoryProblem(reason: "Could not get directory"))
            }
        } catch {
            return .failed(because: .writingToUserDirectoryProblem(reason: "\(error)"))
        }
    }
    
    public static func installed(mobileConfig: MobileConfig) -> Bool {
        let task = Process()
        //  % \

        task.launchPath = "/usr/bin"
        task.arguments = ["profiles", "-Lv", "|", "grep", "name: \(mobileConfig.displayName!)",
            "-4", "|", "awk", """
            -F": "
            """, """
            "/attribute: profileIdentifier/{print $NF}"
            """]
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus.signum() == 0
    }
}
