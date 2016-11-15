
import Foundation
import SwiftyJSON
import ObjectMapper

public class CheckData: NSObject, Mappable, NSCoding {
    
    internal let kDataCheckInKey: String = "checkin"
    internal let kDataCheckOutKey: String = "checkout"
    internal let kDataStatusKey: String = "status"
    internal let kDataTotalTimeKey: String = "total_time"
    
    public var checkin: String?
    public var checkout: String?
    public var status: String?
    public var total_time: String?
    
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
        checkin = json[kDataCheckInKey].string
        checkout = json[kDataCheckOutKey].string
        status = json[kDataStatusKey].string
        total_time = json[kDataTotalTimeKey].string
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
        
        checkin <- map[kDataCheckInKey]
        checkout <- map[kDataCheckOutKey]
        status <- map[kDataStatusKey]
        total_time <- map[kDataTotalTimeKey]
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = [ : ]
        
        if checkin != nil {
            dictionary.updateValue(checkin!, forKey: kDataCheckInKey)
        }
        if checkout != nil {
            dictionary.updateValue(checkout!, forKey: kDataCheckOutKey)
        }
        if status != nil {
            dictionary.updateValue(status!, forKey: kDataStatusKey)
        }
        if total_time != nil {
            dictionary.updateValue(total_time!, forKey: kDataTotalTimeKey)
        }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        
        self.checkin = aDecoder.decodeObjectForKey(kDataCheckInKey) as? String
        self.checkout = aDecoder.decodeObjectForKey(kDataCheckOutKey) as? String
        self.status = aDecoder.decodeObjectForKey(kDataStatusKey) as? String
        self.total_time = aDecoder.decodeObjectForKey(kDataTotalTimeKey) as? String
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        //		aCoder.encodeObject(date, forKey: kDataDateKey)
        //		aCoder.encodeObject(total, forKey: kDataTotalKey)
        
        aCoder.encodeObject(checkin, forKey: kDataCheckInKey)
        aCoder.encodeObject(checkout, forKey: kDataCheckOutKey)
        aCoder.encodeObject(status, forKey: kDataStatusKey)
        aCoder.encodeObject(total_time, forKey: kDataTotalTimeKey)
    }
    
}
