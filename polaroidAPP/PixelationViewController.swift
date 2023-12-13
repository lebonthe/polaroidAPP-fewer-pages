//
//  PixelationViewController.swift
//  polaroidAPP
//
//  Created by Min Hu on 2023/12/8.
//

// 匯入 UIKit 框架
import UIKit
// 匯入 CoreImage.CIFilterBuiltins 框架以使用內建的濾鏡
import CoreImage.CIFilterBuiltins

class PixelationViewController: UIViewController {

    // 顯示像素化後圖片的 ImageView
    @IBOutlet weak var photoInPixelationImageView: UIImageView!
    // 調整像素化比例的 Slider
    @IBOutlet weak var pixelationRatioSlider: UISlider!
    
    var filter: CIFilter! // 儲存 CIFilter 的變數
    var xForNextPage: Double! = 13 // 等會要儲存此頁 photoInPixelationImageView 的 X 軸值以傳送到下一頁
    var width = 367 // 預設寬度
    var height = 295 // 預設高度

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 設定 Slider 的最小軌道顏色為系統藍色
        pixelationRatioSlider.minimumTrackTintColor = .systemBlue
        // 設定 Slider 的最大值為 1
        pixelationRatioSlider.maximumValue = 100
        // 設定 Slider 的最小值為 0.0001
        pixelationRatioSlider.minimumValue = 0.0001
        // 設定 Slider 的值為 0.0001
        pixelationRatioSlider.value = 0.0001

        // 如果無法取得 "dog and his host in Karlovy Vary" 的圖像，則返回
        guard let currentCGImage = UIImage(named: "dog and his host in Karlovy Vary")?.cgImage else { return }
        // 將 CGImage 轉換為 CIImage
        let currentCIImage = CIImage(cgImage: currentCGImage)
        
        // 創建名為 "CIPixelate" 的 CIFilter
        filter = CIFilter(name: "CIPixellate")

        // 設定 CIFilter 的 kCIInputImageKey 為目前的 CIImage
        filter?.setValue(currentCIImage, forKey: kCIInputImageKey)
        // 執行圖片處理
        applyProcessing()
    }
    
    func applyProcessing(){
        // 確保 filter 變數不為 nil，否則返回
        guard let filter = filter else { return }

        // 獲取 CIFilter 的輸入鍵值
        let inputKeys = filter.inputKeys

        // 如果包含 kCIInputScaleKey
        if inputKeys.contains(kCIInputScaleKey){
            // 設定 kCIInputScaleKey 的值為 Slider 值乘以 0.1
            filter.setValue(pixelationRatioSlider.value * 0.1, forKey: kCIInputScaleKey)
        }

        // 如果輸出圖片不存在，則返回
        guard let outputImage = filter.outputImage else { return }
        
        // 建立 CIContext
        let context = CIContext()
        
        // 嘗試從輸出圖片的範圍內建立 CGImage
        if let cgImg = context.createCGImage(outputImage, from: outputImage.extent){
            // 創建 UIImage
            let processedImage = UIImage(cgImage: cgImg)
            // 設定 ImageView 的圖片為處理後的圖片
            photoInPixelationImageView.image = processedImage
        }
        
    }
    
    @IBAction func pixelationChanged(_ sender: Any) {
        // 呼叫 applyProcessing 進行圖片處理
        applyProcessing()
        
    }
    
    // 選擇照片比例
    @IBAction func selectPhotoRatio(_ sender: UISegmentedControl) {
        width = 367 // 預設寬度
        height = 295 // 預設高度
        // 依照使用者選取的比例調整畫面比例
        switch sender.selectedSegmentIndex {
            
        case 1:
            width = height // 正方形比例
            print("width:\(width)，height:\(height)")
        case 2:
            height = width / 3 * 4 // 3:4 比例
        case 3:
            height = width / 16 * 9 // 16:9 比例
        default:
            width = 367 // 預設寬度
            height = 295 // 預設高度
        }
        // 設定照片的 UIImageView 尺寸
        photoInPixelationImageView.frame.size = CGSize(width: width, height: height)
        // 將照片比例的 UIImageView 置中於畫面 X 軸
        photoInPixelationImageView.center.x = view.center.x
        // 將 photoInPixelationImageView.frame 最小值 X 傳到 xForNextPage 中
        xForNextPage = photoInPixelationImageView.frame.minX
    }

    @IBSegueAction func printPhoto(_ coder: NSCoder) -> PrintViewController? {
        // 將原始寬度和高度轉換為 Double 類型
        let width = Double(width)
        let height = Double(height)
        
        // 初始化 PrintViewController
        let controller = PrintViewController(coder: coder)
        
        // 設置 PrintViewController 的 photoToPrintImageView.image
        controller?.photoToPrintImage = photoInPixelationImageView.image
        
        // 將寬度和高度作為 Ratio 物件傳遞給 PrintViewController 的 ratioResult
        controller?.ratioResult = Ratio(width: width, height: height, x: xForNextPage)
        
        return controller
    }
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

}

