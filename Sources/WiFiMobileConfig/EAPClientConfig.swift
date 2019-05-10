//
//  EAPClientConfig.swift
//  WiFiMobileConfig
//
//  Created by Dominic Amato on 5/9/19.
//

import Foundation

public struct EAPClientConfig: Equatable {

    // An array of integers that mark the eap types
    public let eapTypes: [EAPType]
    
    // Whether to use a one time password for authentication
    public let oneTimePass: Bool?
    
    public let payloadCertAnchorUUID: [UUID]?
    
    public let tlsMax: String?
    
    public let tlsMin: String?
    
    public let tlsTrustedServers: [String]?
    
    public let ttlsInnerAuth: TTLSInnerAuthType?
    
    public let username: Username?
    
    public let password: Password?
    
    public let outerIdentity: String?
    
    public let allowTrustExceptions: Bool?
    
    public let certificateIsRequired: Bool?
    
    public let usePAC: Bool?
    
    public let provisionPAC: Bool?
    
    public let provisionPACAnonymously: Bool?
    
    public let numberOfRANDs: Int?
    
    public init(
        eapTypes: [EAPType],
        oneTimePass: Bool?,
        payloadCertAnchorUUID: [UUID]?,
        tlsMax: String?,
        tlsMin: String?,
        tlsTrustedServers: [String]?,
        ttlsInnerAuth: TTLSInnerAuthType?,
        username: Username?,
        password: Password?,
        outerIdentity: String?,
        allowTrustExceptions: Bool?,
        certificateIsRequired: Bool?,
        usePAC: Bool?,
        provisionPAC: Bool?,
        provisionPACAnonymously: Bool?,
        numberOfRANDs: Int?
        ) {
        self.eapTypes = eapTypes
        self.oneTimePass = oneTimePass
        self.payloadCertAnchorUUID = payloadCertAnchorUUID
        self.tlsMax = tlsMax
        self.tlsMin = tlsMin
        self.tlsTrustedServers = tlsTrustedServers
        self.ttlsInnerAuth = ttlsInnerAuth
        self.username = username
        self.password = password
        self.outerIdentity = outerIdentity
        self.allowTrustExceptions = allowTrustExceptions
        self.certificateIsRequired = certificateIsRequired
        self.usePAC = usePAC
        self.provisionPAC = provisionPAC
        self.provisionPACAnonymously = provisionPACAnonymously
        self.numberOfRANDs = numberOfRANDs
    }
    
    public enum EAPType: Int, Equatable {
        case TLS = 13
        case LEAP = 17
        case EAPSIM = 18
        case TTLS = 21
        case EAPAKA = 23
        case PEAP = 25
        case EAPFAST = 43
        
        public var serializableRepresentation: PlistSerializable {
            return .from(self.rawValue)
        }
    }
    
    public enum TTLSInnerAuthType: String, Equatable {
        case PAP = "PAP"
        case CHAP = "CHAP"
        case MSCHAP = "MSCHAP"
        case MSCHAP2 = "MSCHAPv2"
        
        public var serializableRepresentation: PlistSerializable {
            return .from(self.rawValue)
        }
    }
    
    public var serializableRepresentation: PlistSerializable {
        var result = [String: PlistSerializable]()
        
        result[EAPSpecificKey.eapTypes] = .from(self.eapTypes.map{ $0.serializableRepresentation })
        
        if let username = self.username {
            result[EAPSpecificKey.username] = .from(username.text)
        }
        
        if let password = self.password {
            result[EAPSpecificKey.password] = .from(password.text)
        }
        
        if let tlsMin = self.tlsMin {
            result[EAPSpecificKey.tlsMin] = .from(tlsMin)
        }
        
        if let tlsMax = self.tlsMax {
            result[EAPSpecificKey.tlsMax] = .from(tlsMax)
        }
        
        if let tlsTrustedServers = self.tlsTrustedServers {
            result[EAPSpecificKey.tlsTrustedServers] = .from(tlsTrustedServers.map{ .from($0) })
        }
        
        if let ttlsInnerAuth = self.ttlsInnerAuth {
            result[EAPSpecificKey.ttlsInnerAuth] = ttlsInnerAuth.serializableRepresentation
        }
        
        if let payloadCertAnchorUUID = self.payloadCertAnchorUUID {
            result[EAPSpecificKey.payloadCertAnchorUUID] = .from(payloadCertAnchorUUID.map{ .from($0.uuidString) })
        }
        
        if let oneTimePass = self.oneTimePass {
            result[EAPSpecificKey.oneTimePass] = .from(oneTimePass)
        }
        
        if let outerIdentity = self.outerIdentity {
            result[EAPSpecificKey.outerIdentity] = .from(outerIdentity)
        }
        
        if let allowTrustExceptions = self.allowTrustExceptions {
            result[EAPSpecificKey.allowTrustExceptions] = .from(allowTrustExceptions)
        }
        
        if let certificateIsRequired = self.certificateIsRequired {
            result[EAPSpecificKey.certificateIsRequired] = .from(certificateIsRequired)
        }
        
        if let usePAC = self.usePAC {
            result[EAPSpecificKey.usePAC] = .from(usePAC)
        }
        
        if let provisionPAC = self.provisionPAC {
            result[EAPSpecificKey.provisionPAC] = .from(provisionPAC)
        }
        
        if let provisionPACAnonymously = self.provisionPACAnonymously {
            result[EAPSpecificKey.provisionPACAnonymously] = .from(provisionPACAnonymously)
        }
        
        if let numberOfRANDs = self.numberOfRANDs {
            result[EAPSpecificKey.numberOfRANDs] = .from(numberOfRANDs)
        }
        
        return .from(result)
    }
    
    
    public enum EAPSpecificKey {
        public static let eapTypes = "AcceptEAPTypes"
        public static let oneTimePass = "OneTimeUserPassword"
        public static let payloadCertAnchorUUID = "PayloadCertificateAnchorUUID"
        public static let tlsMax = "TLSMaximumVersion"
        public static let tlsMin = "TLSMinimumVersion"
        public static let tlsTrustedServers = "TLSTrustedServerNames"
        public static let ttlsInnerAuth = "TTLSInnerAuthentication"
        public static let username = "UserName"
        public static let password = "UserPassword"
        public static let outerIdentity = "OuterIdentity"
        public static let allowTrustExceptions = "TLSAllowTrustExceptions"
        public static let certificateIsRequired = "TLSCertificateIsRequired"
        public static let usePAC = "EAPFASTUsePAC"
        public static let provisionPAC = "EAPFASTProvisionPAC"
        public static let provisionPACAnonymously = "EAPFASTProvisionPACAnonymously"
        public static let numberOfRANDs = "EAPSIMNumberOfRANDs"
    }
}
