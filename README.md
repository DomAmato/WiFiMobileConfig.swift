WifiMobileConfig
=============
![Swift Compatible](https://img.shields.io/badge/Swift%20version-4.1-brightgreen.svg)


Example Mobile Config
```Swift
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
```

References
----------

- [Configuration Profile Reference - Apple](https://developer.apple.com/library/content/featuredarticles/iPhoneConfigurationProfileRef/)
- [Installing a configuration profile on iPhone - programmatically](https://stackoverflow.com/questions/2338035/installing-a-configuration-profile-on-iphone-programmatically/)


License
-------

The MIT License (MIT)
