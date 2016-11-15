//
//  Data.swift
//
//  Created by Димас on 7/12/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

public class Data: NSObject, Mappable, NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
//	internal let kDataDateKey: String = "date"
//	internal let kDataTotalKey: String = "total"
    internal let kDataSDateKey: String = "starts"
    internal let kDataEDateKey: String = "ends"
    internal let kDataTypeKey: String = "shift_type"
    internal let kDataStatusKey: String = "status"
    internal let kDataTotalKey: String = "total_time"

    // MARK: Properties
//	public var date: Int?
//	public var total: Int?
    public var sdate: String?
    public var edate: String?
    public var type: Int?
    public var status: String?
    public var total: Int?

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
//		date = json[kDataDateKey].int
//		total = json[kDataTotalKey].int
        
        sdate = json[kDataSDateKey].string
        edate = json[kDataEDateKey].string
        type = json[kDataTypeKey].intValue
        status = json[kDataStatusKey].string
        total = json[kDataTotalKey].intValue
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
//		date <- map[kDataDateKey]
//		total <- map[kDataTotalKey]

        sdate <- map[kDataSDateKey]
        edate <- map[kDataEDateKey]
        type <- map[kDataTypeKey]
        status <- map[kDataStatusKey]
        total <- map[kDataTotalKey]
    }

    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
//		if date != nil {
//			dictionary.updateValue(date!, forKey: kDataDateKey)
//		}
//		if total != nil {
//			dictionary.updateValue(total!, forKey: kDataTotalKey)
//		}

        if sdate != nil {
            dictionary.updateValue(sdate!, forKey: kDataSDateKey)
        }
        if edate != nil {
            dictionary.updateValue(edate!, forKey: kDataEDateKey)
        }
        if type != nil {
            dictionary.updateValue(type!, forKey: kDataTypeKey)
        }
        if status != nil {
            dictionary.updateValue(status!, forKey: kDataStatusKey)
        }
        if total != nil {
            dictionary.updateValue(total!, forKey: kDataTotalKey)
        }
        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
//		self.date = aDecoder.decodeObjectForKey(kDataDateKey) as? Int
//		self.total = aDecoder.decodeObjectForKey(kDataTotalKey) as? Int

        self.sdate = aDecoder.decodeObjectForKey(kDataSDateKey) as? String
        self.edate = aDecoder.decodeObjectForKey(kDataEDateKey) as? String
        self.type = aDecoder.decodeObjectForKey(kDataTypeKey) as? Int
        self.status = aDecoder.decodeObjectForKey(kDataStatusKey) as? String
        self.total = aDecoder.decodeObjectForKey(kDataTotalKey) as? Int
    }

    public func encodeWithCoder(aCoder: NSCoder) {
//		aCoder.encodeObject(date, forKey: kDataDateKey)
//		aCoder.encodeObject(total, forKey: kDataTotalKey)

        aCoder.encodeObject(sdate, forKey: kDataSDateKey)
        aCoder.encodeObject(edate, forKey: kDataEDateKey)
        aCoder.encodeObject(type, forKey: kDataTypeKey)
        aCoder.encodeObject(status, forKey: kDataStatusKey)
        aCoder.encodeObject(total, forKey: kDataTotalKey)
    }

}
