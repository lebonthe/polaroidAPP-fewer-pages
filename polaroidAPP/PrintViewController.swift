//
//  PrintViewController.swift
//  polaroidAPP
//
//  Created by Min Hu on 2023/12/8.
//

import UIKit

class PrintViewController: UIViewController {
    
    var photoToPrintImage: UIImage! // 顯示要列印的照片的 UIImageView
    var ratioResult: Ratio! // 儲存照片的寬度和高度比例

    override func viewDidLoad() {
        super.viewDidLoad()
        let photoToPrintImageView = UIImageView(image: photoToPrintImage)
        print(ratioResult.x, ratioResult.width, ratioResult.height)
        // 將照片的 UIImageView 設置初始位置為畫面上方
        photoToPrintImageView.frame = CGRect(x: ratioResult.x, y: -photoToPrintImage.size.height, width: ratioResult.width, height: ratioResult.height)
        
        // 將照片的 UIImageView 加到畫面中
        view.addSubview(photoToPrintImageView)
        
        // 執行動畫效果，將照片的 UIImageView 移至畫面中央
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            photoToPrintImageView.frame.origin.y = 103
        }, completion: nil)
    }
}
