//
//  GoodsSpecLayout.swift
//  CollectionViewLayout
//
//  Created by simon on 2017/4/6.
//  Copyright © 2017年 simon. All rights reserved.
//

import UIKit

/// 类似于商品规格, 搜索关键字的布局

class SMLayout: UICollectionViewFlowLayout {
    
}

/// 重写items的布局
extension SMLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var i = 1
        for _ in 0..<attributes.count{
            
            if attributes.count == 1 {break}
            
            if attributes[i].representedElementKind == UICollectionElementKindSectionFooter || attributes[i].representedElementKind == UICollectionElementKindSectionHeader {continue}
            
            let curAttributes = attributes[i]
            let preAttributes = attributes[i - 1]
            
            if preAttributes.indexPath.section == curAttributes.indexPath.section {
                
                let originX = preAttributes.frame.maxX
                if (originX + minimumInteritemSpacing + curAttributes.frame.width) < collectionViewContentSize.width  - sectionInset.right { // 属于同一行
                    curAttributes.frame.origin.x = originX + minimumInteritemSpacing
                } else { // 需要换行
                    let originY = preAttributes.frame.maxY
                    curAttributes.frame.origin.y = originY + minimumLineSpacing
                    curAttributes.frame.origin.x = minimumInteritemSpacing
                }
            }
            
            i += 1
            if i == attributes.count {break}
        }
        return attributes
    }
}
