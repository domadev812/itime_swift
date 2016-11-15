//
//  DayDatas.swift
//
//  Created by Димас on 7/13/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

public class DayDatas: NSObject, Mappable, NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kDayDatasDataKey: String = "data"
	internal let kDayDatasStatusKey: String = "status"


    // MARK: Properties
	public var data: [DataOfDay]?
	public var status: Int?


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
		data = []
		if let items = json[kDayDatasDataKey].array {
			for item in items {
				data?.append(DataOfDay(json: item))
			}
		} else {
			data = nil
		}
		status = json[kDayDatasStatusKey].int

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
		data <- map[kDayDatasDataKey]
		status <- map[kDayDatasStatusKey]

    }

    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if data?.count > 0 {
			var temp: [AnyObject] = []
			for item in data! {
				temp.append(item.dictionaryRepresentation())
			}
			dictionary.updateValue(temp, forKey: kDayDatasDataKey)
		}
		if status != nil {
			dictionary.updateValue(status!, forKey: kDayDatasStatusKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.data = aDecoder.decodeObjectForKey(kDayDatasDataKey) as? [DataOfDay]
		self.status = aDecoder.decodeObjectForKey(kDayDatasStatusKey) as? Int

    }

    public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(data, forKey: kDayDatasDataKey)
		aCoder.encodeObject(status, forKey: kDayDatasStatusKey)

    }

}
