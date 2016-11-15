
import Foundation
import SwiftyJSON
import ObjectMapper

public class Document: NSObject, Mappable, NSCoding {
    
    internal let kDataNameKey: String = "name"
    internal let kDataKindKey: String = "kind"
    internal let kDataSizeKey: String = "size"
    internal let kDataModifiedKey: String = "modified"
    internal let kDataFileNameKey: String = "filename"
    
    public var name: String?
    public var kind: String?
    public var size: Int?
    public var modified: String?
    public var fileName: String?
    
    // MARK: SwiftyJSON Initalizers
    /**
     Initates the class based on the object
     - parameter object: The object of either Dictionary or Array kind that was passed.
     - returns: An initalized instance of the class.
     */
    convenience public init(object: AnyObject) {
        self.init(json: JSON(object))
    }
    
    /**
     Initates the class based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public init(json: JSON) {
        name = json[kDataNameKey].string
        kind = json[kDataKindKey].string
        size = json[kDataSizeKey].intValue
        modified = json[kDataModifiedKey].string
        fileName = json[kDataFileNameKey].string
    }
    
    // MARK: ObjectMapper Initalizers
    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    required public init?(_ map: Map){
        
    }
    
    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    public func mapping(map: Map) {
        
        name <- map[kDataNameKey]
        kind <- map[kDataKindKey]
        size <- map[kDataSizeKey]
        modified <- map[kDataModifiedKey]
        fileName <- map[kDataFileNameKey]
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = [ : ]
        
        if name != nil {
            dictionary.updateValue(name!, forKey: kDataNameKey)
        }
        if kind != nil {
            dictionary.updateValue(kind!, forKey: kDataKindKey)
        }
        if size != nil {
            dictionary.updateValue(size!, forKey: kDataSizeKey)
        }
        if modified != nil {
            dictionary.updateValue(modified!, forKey: kDataModifiedKey)
        }
        if fileName != nil {
            dictionary.updateValue(fileName!, forKey: kDataFileNameKey)
        }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        
        self.name = aDecoder.decodeObjectForKey(kDataNameKey) as? String
        self.kind = aDecoder.decodeObjectForKey(kDataKindKey) as? String
        self.size = aDecoder.decodeObjectForKey(kDataSizeKey) as? Int
        self.modified = aDecoder.decodeObjectForKey(kDataModifiedKey) as? String
        self.fileName = aDecoder.decodeObjectForKey(kDataFileNameKey) as? String
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        //		aCoder.encodeObject(date, forKey: kDataDateKey)
        //		aCoder.encodeObject(total, forKey: kDataTotalKey)
        
        aCoder.encodeObject(name, forKey: kDataNameKey)
        aCoder.encodeObject(kind, forKey: kDataKindKey)
        aCoder.encodeObject(size, forKey: kDataSizeKey)
        aCoder.encodeObject(modified, forKey: kDataModifiedKey)
        aCoder.encodeObject(fileName, forKey: kDataFileNameKey)
    }
    
}
