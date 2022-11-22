//
//  PageModel.swift
//  Pinch
//
//  Created by Bertuğ Horoz on 21.11.2022.
//

import Foundation

struct Page : Identifiable {
    let id : Int
    let imageName : String
}

extension Page {
    var thumbnailName : String {
        return "thumb-" + imageName
    }
}
