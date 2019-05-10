//
//  Certificate.swift
//  WiFiMobileConfig
//
//  Created by Dominic Amato on 5/9/19.
//

import Foundation

public struct Certificate: Equatable {
    // The payload type. The payload types are described in Payload-Specific Property Keys.
    public var type: MobileConfig.PayloadType {
        return .cert
    }
    
    public let filename: String
    
    public let content: Data
    
    public let description: String?
    
    public let displayName: MobileConfig.DisplayName
    
    public let identifier: MobileConfig.PayloadIdentifier

    public let uuid: UUID

    public let version = MobileConfig.PayloadVersion(version: 1)


    public init(
        filename: String,
        content: Data,
        description: String?,
        displayName: MobileConfig.DisplayName,
        identifier: MobileConfig.PayloadIdentifier,
        uuid: UUID
        ) {
        self.filename = filename
        self.content = content
        self.description = description
        self.displayName = displayName
        self.identifier = identifier
        self.uuid = uuid
    }
    
    public var serializableRepresentation: PlistSerializable {
        var result = [String: PlistSerializable]()
        
        result[CertificateSpecificKey.filename] = .from(self.filename)
        result[CertificateSpecificKey.content] = .from(self.content)
        
        result[MobileConfig.CommonKey.type] = self.type.serializableRepresentation
        result[MobileConfig.CommonKey.version] = self.version.serializableRepresentation
        result[MobileConfig.CommonKey.identifier] = self.identifier.serializableRepresentation
        result[MobileConfig.CommonKey.uuid] = .from(self.uuid.uuidString)
        result[MobileConfig.CommonKey.displayName] = self.displayName.serializableRepresentation
        
        if let description = self.description {
            result[MobileConfig.CommonKey.description] = .from(description)
        }
        
        return .from(result)
    }
    
    public enum CertificateSpecificKey {
        public static let filename = "PayloadCertificateFileName"
        public static let content = "PayloadContent"
    }
}
