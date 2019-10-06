//
//  CommandLineInstaller.swift
//  WiFiMobileConfig
//
//  Created by Magic.io on 5/10/19.
//

#if os(macOS)
import Cocoa
import Foundation

@available(OSX 10.0, *)
public class CommandLineInstaller {

    public static func install(mobileConfig: MobileConfig, configName: String) -> InstallationResult {
        do {
            // get the documents folder url
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                // create the destination url for the text file to be saved
                let fileURL = documentDirectory.appendingPathComponent("\(configName).mobileconfig")
                // writing to disk
                try mobileConfig.generatePlist().serializeAsPlistXML().data!.write(to: fileURL, options: .atomicWrite)
                
                let task = Process()
                // Using sudo removes the prompt 
//                task.launchPath = "/usr/bin/sudo"
//                task.arguments = ["profiles", "install", "-path=\(fileURL.absoluteString)", "-user=\(NSUserName())"]
                task.launchPath = "/usr/bin/profiles"
                task.arguments = ["install", "-path=\(fileURL.path)", "-user=\(NSUserName())"]
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
    
    public static func installed(config: MobileConfig) -> Bool {
        let pipe = Pipe()
        let task = Process()
        task.launchPath = "/usr/bin/profiles"
        task.arguments = ["list"]
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        let fh = pipe.fileHandleForReading
        let output = String(data: fh.availableData, encoding: .ascii)!
        return output.contains("profileIdentifier: \(config.identifier.toString())")
    }
    
    public static func remove(config: MobileConfig) -> Bool {
        let task = Process()
        task.launchPath = "/usr/bin/profiles"
        task.arguments = ["remove", "-identifier=\(config.identifier.toString())"]
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus.signum() == 0
    }
}
#endif
