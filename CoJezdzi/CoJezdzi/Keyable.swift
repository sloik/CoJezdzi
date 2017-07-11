//
//  Created by Lukasz Stocki on 26/02/16.
//  Copyright © 2016 A.C.M.E. All rights reserved.
//

import Foundation

public protocol Keyable {
    var keyID: String { get }
}

extension Keyable {
    var hashValue: Int {
        return self.keyID.hashValue
    }
}
