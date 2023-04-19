//
//  https://mczachurski.dev
//  Copyright © 2023 Marcin Czachurski and the repository contributors.
//  Licensed under the Apache License 2.0.
//

import ArgumentParser
import Foundation

@main
struct InstancesApp: AsyncParsableCommand {
    
    @Option(name: .shortAndLong, help: "The path to the list of the instances.")
    var instances: String? = nil
        
    mutating func run() async throws {
        guard let instances else {
            throw RuntimeError("Instance parameter is mandatory!")
        }

        guard let instancesContent = try? String(contentsOfFile: instances) else {
            throw RuntimeError("Couldn't read from '\(instances)'!")
        }
        
        guard let data = instancesContent.data(using: .utf8) else {
            throw RuntimeError("Couldn't convert to data!")
        }
        
        let metadata = try JSONDecoder().decode(Metadata.self, from: data)
        let metadataInstances = Instances()

        for item in metadata.instances {
            do {
                // Download JSON file about instance metadata.
                let instanceMetadata = try await downloadJson(instanceAddress: item)
                
                // We have to remove old thumbnail from entity.
                let orginalThumnailUrl = instanceMetadata.thumbnail
                instanceMetadata.thumbnail = nil
                
                // Add to instances collection.
                metadataInstances.instances.append(instanceMetadata)
                
                // Download instance thumbnail.
                guard let thumbnailUrl = orginalThumnailUrl else {
                    continue
                }
                
                guard let imageData = await self.downloadThumbnail(thumbnailUrl: thumbnailUrl) else {
                    continue
                }

                let fileName = "\(UUID().uuidString).\(thumbnailUrl.pathExtension)".lowercased()
                let thumbnailsDirectory = "\(FileManager.default.currentDirectoryPath)/thumbnails/"
                
                let imageUrl = "https://raw.githubusercontent.com/VernissageApp/Home/main/thumbnails/\(fileName)"
                let imagePath = "\(thumbnailsDirectory)/\(fileName)"
                
                // Save file in working directory.
                if !self.directoryExists(path: thumbnailsDirectory) {
                    try self.createDirectory(path: thumbnailsDirectory)
                }

                let fileSaved = FileManager.default.createFile(atPath: imagePath, contents: imageData)

                // Change url to thumbnail.
                if fileSaved, let url = URL(string: imageUrl) {
                    instanceMetadata.thumbnail = url
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        // Save file to disk.
        let jsonEncoder = JSONEncoder()
        // jsonEncoder.outputFormatting = .withoutEscapingSlashes
        jsonEncoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]

        let metadataInstancesData = try jsonEncoder.encode(metadataInstances)
        let metadataPath = "\(FileManager.default.currentDirectoryPath)/instances2.json"
        
        
        let metadataSaved = FileManager.default.createFile(atPath: metadataPath, contents: metadataInstancesData)
        guard metadataSaved else {
            throw RuntimeError("Metadata file has not been saved!")
        }
    }
    
    private func downloadJson(instanceAddress: String) async throws -> Instance {
        guard let instanceUrl = URL(string: "\(instanceAddress)/api/v1/instance") else {
            throw RuntimeError("Couldn't convert instance address to URL!")
        }
        
        let (data, response) = try await URLSession.shared.data(from: instanceUrl)

        guard (response as? HTTPURLResponse)?.status?.responseType == .success else {
            throw NetworkError.notSuccessResponse(response)
        }
        
        let instance = try JSONDecoder().decode(Instance.self, from: data)
        return instance
    }
    
    private func downloadThumbnail(thumbnailUrl: URL) async -> Data? {
        do {
            let (data, response) = try await URLSession.shared.data(from: thumbnailUrl)
            
            guard (response as? HTTPURLResponse)?.status?.responseType == .success else {
                throw NetworkError.notSuccessResponse(response)
            }
            
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    private func createDirectory(path: String) throws {
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
    }
    
    private func directoryExists(path: String) -> Bool {
        var isDirectory : ObjCBool = true
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}
