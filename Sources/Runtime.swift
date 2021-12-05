//
//  Runtime.swift
//  
//
//  Created by Alberto García-Muñoz on 5/12/21.
//

import Foundation

private enum RuntimeStatus {
    case initial, loading, loaded
}

final class Runtime {
    private static var status: RuntimeStatus = .initial
    static func loadModules() {
        guard status == .initial else {
            return
        }
        status = .loading
        var numberOfImages: UInt32 = 0
        let images = objc_copyImageNames(&numberOfImages)
        defer {
            images.deallocate()
            status = .loaded
        }
        (0..<numberOfImages).forEach { offset in
            let bundleName = String(cString: images[Int(offset)]).components(separatedBy: "/").last
            let moduleType = bundleName.flatMap { objc_lookUpClass("\($0).Module") as? ModuleContract.Type }
            moduleType?.get()
        }
    }
}
