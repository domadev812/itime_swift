//
//  Data.swift
//
//  Created by Димас on 7/13/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

public class DataOfDay: NSObject, Mappable, NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kDataCheckoutDateKey: String = "checkout_date"
	internal let kDataCheckinDateKey: String = "checkin_date"
	internal let kDataTotalKey: String = "total"


    // MARK: Properties
	public var checkoutDate: Int?
	public var checkinDate: Int?
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
		checkoutDate = json[kDataCheckoutDateKey].int
		checkinDate = json[kDataCheckinDateKey].int
		total = json[kDataTotalKey].int

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
		checkoutDate <- map[kDataCheckoutDateKey]
		checkinDate <- map[kDataCheckinDateKey]
		total <- map[kDataTotalKey]

    }

    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if checkoutDate != nil {
			dictionary.updateValue(checkoutDate!, forKey: kDataCheckoutDateKey)
		}
		if checkinDate != nil {
			dictionary.updateValue(checkinDate!, forKey: kDataCheckinDateKey)
		}
		if total != nil {
			dictionary.updateValue(total!, forKey: kDataTotalKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.checkoutDate = aDecoder.decodeObjectForKey(kDataCheckoutDateKey) as? Int
		self.checkinDate = aDecoder.decodeObjectForKey(kDataCheckinDateKey) as? Int
		self.total = aDecoder.decodeObjectForKey(kDataTotalKey) as? Int

    }

    public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(checkoutDate, forKey: kDataCheckoutDateKey)
		aCoder.encodeObject(checkinDate, forKey: kDataCheckinDateKey)
		aCoder.encodeObject(total, forKey: kDataTotalKey)

    }

}
