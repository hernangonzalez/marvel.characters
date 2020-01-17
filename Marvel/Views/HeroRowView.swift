//
//  HeroRowView.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 17/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import SwiftUI
import UIKit
import Combine
import MarvelKit

class HeroRowViewModel: Identifiable, ObservableObject {
    let id: Character.ID
    let name: String

    init(from character: Character) {
        id = character.id
        name = character.name
    }
}
