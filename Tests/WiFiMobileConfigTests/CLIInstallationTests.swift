//
//  CLIInstallationTests.swift
//  WiFiMobileConfigTests
//
//  Created by Dominic Amato on 5/10/19.
//

import WiFiMobileConfig
import XCTest

class CLIInstallationTests: XCTestCase {

    func testAccessProfiles() {
        let task = Process()
        task.launchPath = "/usr/bin/profiles"
        task.arguments = ["list"]
        task.launch()
        task.waitUntilExit()
        XCTAssertEqual(task.terminationStatus, 0)
    }
    
    func testCreateFile() {
        do {
            // get the documents folder url
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                // create the destination url for the text file to be saved
                let fileURL = documentDirectory.appendingPathComponent("test.mobileconfig")
                // writing to disk
                try "I am a mobile config".data(using: .utf8)!.write(to: fileURL, options: .atomicWrite)
                
                try FileManager.default.removeItem(at: fileURL)
            } else {
                XCTFail()
            }
        } catch {
            XCTFail()
        }
    }
    
    func testMobileProfileNotInstalled() {
        let exampleUUID = UUID(uuidString: "10000000-0000-0000-0000-000000000000")!
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
        XCTAssertFalse(CommandLineInstaller.installed(config: mobileConfig))
    }
    
    func testCliInstallation() {
        let payloadUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        let configUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
        let certUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
        let mobileConfig = MobileConfig(
            contents: [
                MobileConfig.PayloadContent.wiFi(.init(
                    version: .init(version: 1),
                    identifier: .from(uuid: payloadUUID, type: .wiFi),
                    uuid: payloadUUID,
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
            certificates: [Certificate(filename: "Internet Widgits Pty Ltd.cer",
                                       content: Data(base64Encoded: "MIIFazCCA1OgAwIBAgIUBjZ5/+ERQTKs86ZrRWvk1mZ79wUwDQYJKoZIhvcNAQELBQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoMGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDAeFw0xOTA1MTMyMDQwMzBaFw0yMDA1MTIyMDQwMzBaMEUxCzAJBgNVBAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEwHwYDVQQKDBhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDG/pkRziR4KLA0SQNQWRHMQnbUNgsyAE9MsaN2KyTNVASd8LabEeRcSiIs8v//jmF9m5rDuAyMFYx7INzrm1nkoTDz6b92Dges2Ajl45zhfvhAjswrHt3FRQInH4hRrM/lHAZbVup1tuseQTfpQeN6TuKH+pfdMzacZLN9lPxEmGM0tCRrGYxBu81JvZXSfaMpwzZbsWQNv9n5jg8nlEWpDQ64BAo2dfnbg015oUdpOEOnA79zUueCqW1Q3YwJvlxQKcM5nuu+A0L7MyAnZQjLlHn8TZizoAGJPAyUCADUgDlwiYHOV+bohMQlazuoXxVXiY7frfxUggoZWn8IVu4lTl0kxCBdvYC+Nw6qEsQwOySEqcZf/hZmqwju6NSP6rkVivPBKQFGxxjB48fd1JT/0il4mrkQijb97cznQcVIN3aF5FpSn844cvv6+YNFxnHX0Echs1Ft9GAXeSnQcmtcSgNz0f4ak1T3g7WrQTAlJsk/vmd55rtjtuVM1h/j/pFKLev7pVxBJKIHnv9e4GBmmj8tNH6540pNfsHj8Mw2wwSIzcTQVrtWCQQyOhKTsQkn5Ig2seZYOYJpwNi1SgPOw5gNoaCASynTXwQiAtKcN92nDPbPS2iQ6CSJ1SEBfwDg9rXWmTbzq8wkfjUlh4cdXbSW1Bat01qoNbwO9Gr80wIDAQABo1MwUTAdBgNVHQ4EFgQUQ3TDET4qrp81PRbYX+1o717JsdcwHwYDVR0jBBgwFoAUQ3TDET4qrp81PRbYX+1o717JsdcwDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAgEAQzsjypDct+GL9H/r3K5rXe8jPAIOuX/noWKbudLzM8gOz5WqXe94ffYx+J9DK6CjfQLunx6g1tL9H2ErtJSQRVpucGfb5CEZuJOMUj9mxdYu1JBxewNWlhev1N9fwaXdWkwysjKYU9lK0o5+ghEKSX3612Fr61N7uyH/dwUA+sfvsOzUg1jLgcwdsQsJZJ1K4238rrsCMv497w0mhZy7wL5NNiCOyNxfJppvWZere59AHcqzrNJoaAJJxqgE9cRHSeZgzURd9lufilFsmsxj4J3StrXnisn46LpE7YbEqYKII97/s3F8+1yoWtSMSWxPRzIFcG+z45lRB1LyAD04Buo95j2SGKmRepRSRMNHuPH+M0ZpZkopWGp9vGOI8qMzb9pvCd3aQ3az/ZUlpApIL35zvH2J23VQQdVxzEJau/cUqPyfYjaWOEcURUz/hoNikASNaSOHhNUvmK2OVaPUnm8bwUrDrk3YFJbx0rVphPJMsajT99Tpkw1umVq7bnyeZCmF2oWFQA5ZpGnLZCZGdYG+d+N3nmojXh94p9sWmMKN3T4vyyDsTd2kxXSWIpne/EiRk3X8YgfLetgHbjDb2w4mrplpAHAWgmCCh9kXcB0hxPTCoFNnyWxVvyR4I5fS5R70LkyzocL8x7MGJYnJop2YpQBo7B4ExRaPf8gEFeI=")!,
                                       description: "Adds a PKCS#1-formatted certificate",
                                       displayName: .init(displayName: "Some Cert Stuff"),
                                       identifier: .from(uuid: certUUID, type: .cert),
                                       uuid: certUUID)],
            description: "MOBILE_CONFIG_DESCRIPTION",
            displayName: .init(displayName: "MOBILE_CONFIG_DISPLAY_NAME"),
            expired: nil,
            identifier: .from(uuid: configUUID, type: .mobileConfig),
            organization: .init(organizationName: "MOBILE_CONFIG_ORGANIZATION_NAME"),
            uuid: configUUID,
            isRemovalDisallowed: true,
            scope: .user,
            autoRemoving: .none,
            consentText: .none
        )
        let result = CommandLineInstaller.install(mobileConfig: mobileConfig, configName: "test")
        print(result)
        XCTAssertEqual(result, .success)
    }

    func testMobileProfileInstalled() {
        let exampleUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
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
        XCTAssertTrue(CommandLineInstaller.installed(config: mobileConfig))
    }
    
    func testMobileProfileRemove() {
        let exampleUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
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
        XCTAssertTrue(CommandLineInstaller.remove(config: mobileConfig))
    }
}
