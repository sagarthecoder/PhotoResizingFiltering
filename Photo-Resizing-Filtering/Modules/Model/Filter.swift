//
//  Filter.swift
//  Photo-Resizing-Filtering
//
//  Created by Sagar on 21/7/21.
//

import Foundation

struct Filter {
    let filterName : String
    var filterEffectValue : Any?
    var filterEffectValueName : String?
    
    init(filterName : String, filterEffectValue : Any?, filterEffectValueName : String?) {
        self.filterName = filterName
        self.filterEffectValue = filterEffectValue
        self.filterEffectValueName = filterEffectValueName
    }
}
