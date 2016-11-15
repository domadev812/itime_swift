//
//  Data.swift
//
//  Created by Димас on 6/10/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper
import UIKit

public class LoginData: NSObject, Mappable, NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kDataConstructionKey: String = "construction"
	internal let kDataInternalIdentifierKey: String = "id"
	internal let kDataCscsdateKey: String = "cscsdate"
	internal let kDataCompanyKey: String = "company"
	internal let kDataJobKey: String = "job"
	internal let kDataCscsKey: String = "cscs"
	internal let kDataLastnameKey: String = "lastname"
	internal let kDataImageKey: String = "image"
	internal let kDataMobKey: String = "mob"
	internal let kDataFirstnameKey: String = "firstname"
	internal let kDataEmailKey: String = "email"
	internal let kDataDobKey: String = "dob"

    // MARK: Properties
	public var construction: String?
	public var internalIdentifier: Int?
	public var cscsdate: String?
	public var company: String?
	public var job: String?
	public var cscs: String?
	public var lastname: String?
	public var image: String?
	public var mob: String?
	public var firstname: String?
	public var email: String?
	public var dob: String?
    
//    public var user_id: String?
    public var avatar: UIImage?


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
		construction = json[kDataConstructionKey].string
		internalIdentifier = json[kDataInternalIdentifierKey].intValue
		cscsdate = json[kDataCscsdateKey].string
		company = json[kDataCompanyKey].string
		job = json[kDataJobKey].string
		cscs = json[kDataCscsKey].string
		lastname = json[kDataLastnameKey].string
		image = json[kDataImageKey].string
		mob = json[kDataMobKey].string
		firstname = json[kDataFirstnameKey].string
		email = json[kDataEmailKey].string
		dob = json[kDataDobKey].string
        
        
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
		construction <- map[kDataConstructionKey]
		internalIdentifier <- map[kDataInternalIdentifierKey]
		cscsdate <- map[kDataCscsdateKey]
		company <- map[kDataCompanyKey]
		job <- map[kDataJobKey]
		cscs <- map[kDataCscsKey]
		lastname <- map[kDataLastnameKey]
		image <- map[kDataImageKey]
		mob <- map[kDataMobKey]
		firstname <- map[kDataFirstnameKey]
		email <- map[kDataEmailKey]
		dob <- map[kDataDobKey]

    }

    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if construction != nil {
			dictionary.updateValue(construction!, forKey: kDataConstructionKey)
		}
		if internalIdentifier != nil {
			dictionary.updateValue(internalIdentifier!, forKey: kDataInternalIdentifierKey)
		}
		if cscsdate != nil {
			dictionary.updateValue(cscsdate!, forKey: kDataCscsdateKey)
		}
		if company != nil {
			dictionary.updateValue(company!, forKey: kDataCompanyKey)
		}
		if job != nil {
			dictionary.updateValue(job!, forKey: kDataJobKey)
		}
		if cscs != nil {
			dictionary.updateValue(cscs!, forKey: kDataCscsKey)
		}
		if lastname != nil {
			dictionary.updateValue(lastname!, forKey: kDataLastnameKey)
		}
		if image != nil {
			dictionary.updateValue(image!, forKey: kDataImageKey)
		}
		if mob != nil {
			dictionary.updateValue(mob!, forKey: kDataMobKey)
		}
		if firstname != nil {
			dictionary.updateValue(firstname!, forKey: kDataFirstnameKey)
		}
		if email != nil {
			dictionary.updateValue(email!, forKey: kDataEmailKey)
		}
		if dob != nil {
			dictionary.updateValue(dob!, forKey: kDataDobKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.construction = aDecoder.decodeObjectForKey(kDataConstructionKey) as? String
		self.internalIdentifier = aDecoder.decodeObjectForKey(kDataInternalIdentifierKey) as? Int
		self.cscsdate = aDecoder.decodeObjectForKey(kDataCscsdateKey) as? String
		self.company = aDecoder.decodeObjectForKey(kDataCompanyKey) as? String
		self.job = aDecoder.decodeObjectForKey(kDataJobKey) as? String
		self.cscs = aDecoder.decodeObjectForKey(kDataCscsKey) as? String
		self.lastname = aDecoder.decodeObjectForKey(kDataLastnameKey) as? String
		self.image = aDecoder.decodeObjectForKey(kDataImageKey) as? String
		self.mob = aDecoder.decodeObjectForKey(kDataMobKey) as? String
		self.firstname = aDecoder.decodeObjectForKey(kDataFirstnameKey) as? String
		self.email = aDecoder.decodeObjectForKey(kDataEmailKey) as? String
		self.dob = aDecoder.decodeObjectForKey(kDataDobKey) as? String

    }

    public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(construction, forKey: kDataConstructionKey)
		aCoder.encodeObject(internalIdentifier, forKey: kDataInternalIdentifierKey)
		aCoder.encodeObject(cscsdate, forKey: kDataCscsdateKey)
		aCoder.encodeObject(company, forKey: kDataCompanyKey)
		aCoder.encodeObject(job, forKey: kDataJobKey)
		aCoder.encodeObject(cscs, forKey: kDataCscsKey)
		aCoder.encodeObject(lastname, forKey: kDataLastnameKey)
		aCoder.encodeObject(image, forKey: kDataImageKey)
		aCoder.encodeObject(mob, forKey: kDataMobKey)
		aCoder.encodeObject(firstname, forKey: kDataFirstnameKey)
		aCoder.encodeObject(email, forKey: kDataEmailKey)
		aCoder.encodeObject(dob, forKey: kDataDobKey)

    }

}
