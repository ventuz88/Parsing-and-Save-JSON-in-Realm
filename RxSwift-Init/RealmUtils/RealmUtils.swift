//
// Created by Stefano Venturin on 18/03/17.
// Copyright (c) 2017 Stefano Venturin. All rights reserved.
//

import Foundation
import RealmSwift

let REALM_SCHEMA_VERSION: UInt64 = 0

final class RealmUtils {

    static let shared = RealmUtils()

    /// Realm variable to access to it
    var realm: Realm? {
        get {
            var realm: Realm? = nil
            do {
                realm = try Realm(configuration: config)
            } catch let error {
                debugPrint("Realm could not be opened:", error)
            }
            return realm
        }
    }


    /**
        --- Realm Initialization ---
     */
    private var config: Realm.Configuration {
        get {
            let config = Realm.Configuration(
                    // Use the default directory, but replace the filename with a new one
                    fileURL: self.realmURL(userGuid: "test"),

                    // Open the encrypted Realm file
                    encryptionKey: self.getKey(),

                    // Set the new schema version. This must be greater than the previously used
                    // version (if you've never set a schema version before, the version is 0).
                    schemaVersion: REALM_SCHEMA_VERSION,

                    // Set the block which will be called automatically when opening a Realm with
                    // a schema version lower than the one set above
                    migrationBlock: { migration, oldSchemaVersion in
                        // We haven’t migrated anything yet, so oldSchemaVersion == 0
                        if (oldSchemaVersion < REALM_SCHEMA_VERSION) {
                            //
                        }
                    }, deleteRealmIfMigrationNeeded: true
            )
            return config
        }
    }

    /// URL where store Realm's files
    private func realmURL(userGuid: String? = nil) -> URL {
        let array:NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let document = array.object(at: 0) as! String
        let fileName: String = "MyTest" + (userGuid ?? "")
        return URL(fileURLWithPath: document).appendingPathComponent(fileName)
    }

    /// To encript Realm's file
    private func getKey() -> Data {
        // Identifier for our keychain entry - should be unique for your application
        let keychainIdentifier = "io.Realm.Encryption_ForThisTest_Key"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!

        // First check in the keychain for an existing key
        var query: [NSString: AnyObject] = [
                kSecClass: kSecClassKey,
                kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
                kSecAttrKeySizeInBits: 512 as AnyObject,
                kSecReturnData: true as AnyObject
        ]

        // To avoid Swift optimization bug, should use withUnsafeMutablePointer() function to retrieve the keychain item
        // See also: http://stackoverflow.com/questions/24145838/querying-ios-keychain-using-swift/27721328#27721328
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! Data
        }

        // No pre-existing key from this application, so generate a new one
        var keyData = Data(count: 64)
        let result = keyData.withUnsafeMutableBytes {mutableBytes in
            SecRandomCopyBytes(kSecRandomDefault, keyData.count, mutableBytes)
        }
        assert(result == 0, "Failed to get random bytes")

        // Store the key in the keychain
        query = [
                kSecClass: kSecClassKey,
                kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
                kSecAttrKeySizeInBits: 512 as AnyObject,
                kSecValueData: keyData as AnyObject
        ]

        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")

        return keyData as Data
    }


}
