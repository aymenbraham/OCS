//
//  ProgrammeCollectionViewCell.swift
//  OCS
//
//  Created by aymen braham on 20/01/2022.
//

import UIKit

class ProgrammeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var programmeImage: UIImageView!
    @IBOutlet weak var programmeTitle: UILabel!
    @IBOutlet weak var programmeSubTitle: UILabel!
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
