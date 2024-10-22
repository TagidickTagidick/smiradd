import SwiftUI

struct ServiceModel: Codable, Identifiable {
    var id: String {name}
    let name: String
    let description: String?
    let price: Int?
    var cover_url: String?
    let coverImage: UIImage?
    let coverVideo: URL?
    
    private enum CodingKeys: String, CodingKey {
        case name, description, price, cover_url
    }
    
    init(
        name: String,
        description: String?,
        price: Int?,
        cover_url: String?,
        coverImage: UIImage?,
        coverVideo: URL?
    ) {
        self.name = name
        self.description = description
        self.price = price
        self.cover_url = cover_url
        self.coverImage = coverImage
        self.coverVideo = coverVideo
    }
    
    init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )
        
        name = try container.decode(
            String.self,
            forKey: .name
        )
        
        description = try container.decode(
            String?.self,
            forKey: .description
        )
        
        price = try container.decode(
            Int?.self,
            forKey: .price
        )
        
        cover_url = try container.decode(
            String?.self,
            forKey: .cover_url
        )
        
        coverImage = nil
        coverVideo = nil
    }
    
    func encode(
        to encoder: Encoder
    ) throws {
        var container = encoder.container(
            keyedBy: CodingKeys.self
        )
        
        try container.encode(
            name,
            forKey: .name
        )
        
        try container.encode(
            description,
            forKey: .description
        )
        
        try container.encode(
            price,
            forKey: .price
        )
        
        try container.encode(
            cover_url,
            forKey: .cover_url
        )
    }
}
