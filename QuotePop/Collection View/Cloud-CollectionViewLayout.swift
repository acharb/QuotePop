//
//  Cloud-CollectionViewLayout.swift
//  QuotePop
//
//  Created by Alec Charbonneau on 4/9/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import UIKit

class Cloud_CollectionViewLayout: UICollectionViewLayout {

    weak var delegate: CloudLayoutDelegate!
    
    var contentHeight: CGFloat = 0
    
    var cellPadding: CGFloat = 6
    
    var numberOfColumns = 2
    
    var contentWidth: CGFloat {
        guard let collectionView = self.collectionView else {
            return 0
        }
        
        let inset = collectionView.contentInset
        return collectionView.bounds.width - (inset.left + inset.right)
    }
    
    var cache = [UICollectionViewLayoutAttributes]()
    
    // MARK : Layout properties
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight )
    }
    
    // MARK: Prepare
    // called whenever collection view layout is invalidated Need to recalculate attriutes when bounds change, like when orientation changes - NEED TO DO!
    override func prepare() {
        

        
        // only prepare attributes if cache is empty and collection view is there
        guard cache.isEmpty == true, let collectionView = self.collectionView else {
            return
        }
        
        // getting the x and y offset
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0..<numberOfColumns{
            xOffset.append(CGFloat(column)*columnWidth)
        }
        
        var yOffset = [CGFloat] (repeating:0,count: numberOfColumns)
        
        // loop through items in section (assume 1 section), starting on left column
        var column = 0
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // frame size calculations
            let cloudHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
            let height = cellPadding * 2 + cloudHeight
            let frame = CGRect(x:xOffset[column],y: yOffset[column], width: columnWidth, height:height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // create attribute, set frame, add to cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // expands content height of collection view, advances yOffset for current column, goes to next column for next item
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            //column = column < (numberOfColumns - 1) ? (column + 1) : 0
            
            // next column is shortest column
            var shortestColumn = column
            for wantMin in 0..<numberOfColumns{
                shortestColumn = yOffset[shortestColumn] <= yOffset[wantMin] ? shortestColumn:wantMin
            }
            column = shortestColumn
        }
        
    }
    
    
    //MARK: Layout functions
    
    override func invalidateLayout() {
        super.invalidateLayout()
        
    }
    
    //called after prepare() to determine which items are visible
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        //loop through cache for items in visible rect
        for attributes in cache {
            if attributes.frame.intersects(rect){
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    
}

protocol CloudLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
}

