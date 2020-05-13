//
//  Organizer.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/13/19.
//  Copyright © 2020 Davide De Rosa. All rights reserved.
//

import Foundation

public protocol OrganizerMetadata: Codable, Hashable, Comparable {
    var uuid: UUID { get }
}

public protocol OrganizerProfile: Codable {
    associatedtype M: OrganizerMetadata
    
    var metadata: M { get }
}

private struct OrganizerIndex<M: OrganizerMetadata>: Codable {
    let profiles: [M]
    
    let activeUUID: UUID
}

public class Organizer<P: OrganizerProfile> {
    private let indexFilename = "index.json"

    private var optionalBaseURL: URL?

    private var baseURL: URL {
        get {
            guard let url = optionalBaseURL else {
                fatalError("baseURL is nil")
            }
            return url
        }
        set {
            optionalBaseURL = newValue
        }
    }

    private var profiles: [P] = []

    private var indexOfActiveProfile: Int = 0 {
        didSet {
            guard indexOfActiveProfile < profiles.count else {
                fatalError("Index out of bounds (\(indexOfActiveProfile) >= \(profiles.count))")
            }
            try? saveIndex()
        }
    }

    public var activeProfile: P {
        get {
            guard !isEmpty else {
                fatalError("Cannot access activeProfile, profiles are empty")
            }
            return profiles[indexOfActiveProfile]
        }
        set {
            guard let newIndex = profiles.firstIndex(where: { $0.metadata == newValue.metadata }) else {
                fatalError("Active profile not found in profiles")
            }
            indexOfActiveProfile = newIndex
        }
    }

    public var isEmpty: Bool {
        return profiles.isEmpty
    }

    public init(baseURL: URL) {
        self.baseURL = baseURL
        print("Convenience.Organizer: persisting to: \(baseURL)")
    }
    
    public func load(withInitialProfile initialProfile: () -> P) throws {
        profiles.removeAll()
        
        let decoder = JSONDecoder()

        // index may not exist
        do {
            let indexData = try Data(contentsOf: baseURL.appendingPathComponent(indexFilename))
            let index = try decoder.decode(OrganizerIndex<P.M>.self, from: indexData)

            for metadata in index.profiles {
                let profile: P
                do {
                    let filename = metadata.uuid.filename
                    let profileData = try Data(contentsOf: baseURL.appendingPathComponent(filename))
                    profile = try decoder.decode(P.self, from: profileData)
                } catch {
                    continue
                }
                profiles.append(profile)
                if metadata.uuid == index.activeUUID {
                    indexOfActiveProfile = profiles.count - 1
                }
            }
        } catch let e {
            print("Convenience.Organizer: \(e)")
        }

        // always fall back to at least one exercise
        if profiles.isEmpty {
            let profile = initialProfile()
            _ = addProfile(profile)

            // persist
            try save()
        }

        // pre-sort by metadata
        profiles.sort { $0.metadata < $1.metadata }
    }

    public func metadata() -> [P.M] {
        return (profiles.map { $0.metadata }).sorted()
    }

    public func containsProfile(withUUID uuid: UUID) -> Bool {
        return profiles.contains { $0.metadata.uuid == uuid }
    }

    public func containsProfile(where containmentBlock: (P.M) -> Bool) -> Bool {
        return profiles.contains { containmentBlock($0.metadata) }
    }

    public func profile(withUUID uuid: UUID) -> P? {
        return profiles.first { $0.metadata.uuid == uuid }
    }

    public func profile(where containmentBlock: (P.M) -> Bool) -> P? {
        return profiles.first { containmentBlock($0.metadata) }
    }

    @discardableResult
    public func addProfile(_ profile: P) -> (Int, P)? {
        let pos = targetIndex(forProfile: profile)
        guard pos != NSNotFound else {
            return nil
        }
        profiles.insert(profile, at: pos)
        if profiles.count == 1 {
            indexOfActiveProfile = 0
        }
        try? save(onlyProfile: profile)
        return (pos, profile)
    }

    @discardableResult
    public func removeProfile(at index: Int) -> P {
        let profile = profiles.remove(at: index)
        try? FileManager.default.removeItem(at: baseURL.appendingPathComponent(profile.filename))
        try? saveIndex()
        return profile
    }

    private func targetIndex(forProfile profile: P) -> Int {
        var pos = 0
        for (i, s) in profiles.enumerated() {

            // duplicate
            if profile.metadata == s.metadata {
                return NSNotFound
            }

            pos = i
            if profile.metadata < s.metadata {
                break
            }
            pos += 1
        }
        return pos
    }

    // MARK: Serialization

    public func save(onlyProfile: P? = nil) throws {
        let encoder = JSONEncoder()

        var profileIndexes: [P.M] = []
        for p in profiles {
            profileIndexes.append(p.metadata)
            if onlyProfile == nil || p.metadata == onlyProfile?.metadata {
                do {
                    try saveProfile(p, encoder: encoder)
                } catch let e {
                    print("Convenience.Organizer: \(e)")
                }
            }
        }

        try saveIndex(profileIndexes: profileIndexes, encoder: encoder)
    }

    public func saveIndex() throws {
        let encoder = JSONEncoder()

        var profileIndexes: [P.M] = []
        for p in profiles {
            profileIndexes.append(p.metadata)
        }

        try saveIndex(profileIndexes: profileIndexes, encoder: encoder)
    }

    private func saveProfile(at index: Int, encoder: JSONEncoder) throws {
        guard index < profiles.count else {
            fatalError("Profile out of range (\(index) > \(profiles.count - 1))")
        }
        let profile = profiles[index]
        try saveProfile(profile, encoder: encoder)
    }

    private func saveProfile(_ profile: P, encoder: JSONEncoder) throws {
        let data = try encoder.encode(profile)
        try data.write(to: baseURL.appendingPathComponent(profile.filename))
    }

    private func saveIndex(profileIndexes: [P.M], encoder: JSONEncoder) throws {
        guard !isEmpty else {
            fatalError("Saving index with empty profiles")
        }
        if indexOfActiveProfile >= profiles.count {
            indexOfActiveProfile = 0
        }
        let index = OrganizerIndex(profiles: profileIndexes, activeUUID: activeProfile.metadata.uuid)
        let indexData = try encoder.encode(index)
        try indexData.write(to: baseURL.appendingPathComponent(indexFilename))
    }
}

private extension UUID {
    var filename: String {
        return "\(uuidString).json"
    }
}

private extension OrganizerProfile {
    var filename: String {
        return metadata.uuid.filename
    }
}
