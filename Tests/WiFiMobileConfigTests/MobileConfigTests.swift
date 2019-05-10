import Foundation
import XCTest
import WiFiMobileConfig

class MobileConfigTests: XCTestCase {
    func testMobileConfig() {
        let exampleUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        let mobileConfig = MobileConfig(
            contents: [
                MobileConfig.PayloadContent.wiFi(.init(
                    version: .init(version: 1),
                    identifier: .from(uuid: exampleUUID, type: .wiFi),
                    uuid: exampleUUID,
                    displayName: .init(displayName: "WIFI_DISPLAY_NAME"),
                    description: "WIFI_DESCRIPTION",
                    organization: .init(organizationName: "WIFI_ORGANIZATION_NAME"),
                    ssid: SSID("SSID"),
                    isHiddenNetwork: true,
                    isAutoJoinEnabled: true,
                    encryptionType: .wpa2(Password("WIFI_PASSWORD")),
                    hotspotType: .legacy,
                    proxy: .manual(.init(
                        server: .init(serverName: "PROXY_SERVER_NAME"),
                        port: .init(port: 1234),
                        authentication: .init(
                            userName: .init(userName: "PROXY_USER_NAME"),
                            password: .init(password: "PROXY_PASSWORD")
                        )
                    )),
                    isCaptiveBypassEnabled: true,
                    qosMarkingPolicy: .init(
                        whitelistedAppIdentifiers: [
                            .init(bundleIdentifier: "BUNDLE_IDENTIFIER"),
                        ],
                        isAppleAudioVideoCallsAllowed: true,
                        isEnabled: true
                    )
                ))
            ],
            certificates: nil,
            description: "MOBILE_CONFIG_DESCRIPTION",
            displayName: .init(displayName: "MOBILE_CONFIG_DISPLAY_NAME"),
            expired: Date(timeIntervalSince1970: 0),
            identifier: .from(uuid: exampleUUID, type: .mobileConfig),
            organization: .init(organizationName: "MOBILE_CONFIG_ORGANIZATION_NAME"),
            uuid: exampleUUID,
            isRemovalDisallowed: false,
            scope: .user,
            autoRemoving: .willRemoveUntil(1234),
            consentText: .init(consentTextsForEachLanguages: [
                .default: "DEFAULT_CONSENT_TEXT",
                .en: "DEFAULT_CONSENT_TEXT",
            ])
        )

        let plistData = mobileConfig.generatePlist().serializeAsPlistXML().data
        XCTAssertNotNil(plistData, "Failed serializing plist")
        let mobileConfigPlist = (String(
            data: plistData!,
            encoding: .utf8))
        let testConfig = (String(
            data: readPropertyList(name: "wpaconfig"),
            encoding: .utf8))
        XCTAssertNotNil(mobileConfigPlist, "Could not encode serialized plist data to string")
        XCTAssertEqual(mobileConfigPlist, testConfig, "Configuration does not match expected output")

    }
    
    func testEAPMobileConfig() {
        let exampleUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        let certUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
        let mobileConfig = MobileConfig(
            contents: [
                MobileConfig.PayloadContent.wiFi(.init(
                    version: .init(version: 1),
                    identifier: .from(uuid: exampleUUID, type: .wiFi),
                    uuid: exampleUUID,
                    displayName: .init(displayName: "WIFI_DISPLAY_NAME"),
                    description: "WIFI_DESCRIPTION",
                    organization: .init(organizationName: "WIFI_ORGANIZATION_NAME"),
                    ssid: SSID("SSID"),
                    isHiddenNetwork: false,
                    isAutoJoinEnabled: false,
                    encryptionType: .wpa2eap(EAPClientConfig(eapTypes: [.TTLS], oneTimePass: nil, payloadCertAnchorUUID: [certUUID], tlsMax: "1.2", tlsMin: "1.0", tlsTrustedServers: nil, ttlsInnerAuth: .PAP, username: Username("EAP_USERNAME"), password: Password("EAP_PASSWORD"), outerIdentity: nil, allowTrustExceptions: nil, certificateIsRequired: nil, usePAC: nil, provisionPAC: nil, provisionPACAnonymously: nil, numberOfRANDs: nil)),
                    hotspotType: .none,
                    proxy: .none,
                    isCaptiveBypassEnabled: false,
                    qosMarkingPolicy: .none
                    ))
            ],
            certificates: [Certificate(filename: "test.cer",
                                         content: "ABCDEF".data(using: .utf8)!,
                                         description: "Adds a PKCS#1-formatted certificate",
                                         displayName: .init(displayName: "Some name"),
                                         identifier: .from(uuid: certUUID, type: .cert),
                                         uuid: certUUID)],
            description: "MOBILE_CONFIG_DESCRIPTION",
            displayName: .init(displayName: "MOBILE_CONFIG_DISPLAY_NAME"),
            expired: nil,
            identifier: .from(uuid: exampleUUID, type: .mobileConfig),
            organization: .init(organizationName: "MOBILE_CONFIG_ORGANIZATION_NAME"),
            uuid: exampleUUID,
            isRemovalDisallowed: true,
            scope: .user,
            autoRemoving: .none,
            consentText: .none
        )
        
        let plistData = mobileConfig.generatePlist().serializeAsPlistXML().data
        XCTAssertNotNil(plistData, "Failed serializing plist")
        let mobileConfigPlist = (String(
            data: plistData!,
            encoding: .utf8))
        let testConfig = (String(
            data: readPropertyList(name: "wpaeapconfig"),
            encoding: .utf8))
        XCTAssertNotNil(mobileConfigPlist, "Could not encode serialized plist data to string")
        XCTAssertEqual(mobileConfigPlist, testConfig, "Configuration does not match expected output")
    }
    
    // https://stackoverflow.com/questions/19309092/nsurl-to-file-path-in-test-bundle-with-xctest
    func readPropertyList(name: String) -> Data {
        let plistPath: String? = Bundle(for: type(of: self)).path(forResource: name, ofType: "plist") //the path of the data
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        return plistXML
    }
}
