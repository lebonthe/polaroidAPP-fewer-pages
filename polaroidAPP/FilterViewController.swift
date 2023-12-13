//
//  FilterViewController.swift
//  polaroidAPP
//
//  Created by Min Hu on 2023/12/8.
//

import UIKit
import CoreImage.CIFilterBuiltins

class FilterViewController: UIViewController {
   
    @IBOutlet weak var photoInFilterImageView: UIImageView!
    // 預覽不同濾鏡的 Scroll View
    @IBOutlet weak var filtersScrollView: UIScrollView!
    // 裝著不同濾鏡的 Image View Outlet Collection
    @IBOutlet var filterPreviewImageViews: [UIImageView]!
    // 裝著三個 Slider 的 View
    @IBOutlet weak var slidersView: UIView!
    // Silder 的 Outlet Collection
    @IBOutlet var filterSliders: [UISlider]!
    // 標記 Slider 數值 Label 的 Outlet Collection
    @IBOutlet var filterValueLabels: [UILabel]!
    // 預覽相片的選擇外框
    @IBOutlet weak var previewFramelLabel: UILabel!
    // 預覽相片上的 button Outlet Collection
    @IBOutlet var previewButton: [UIButton]!

    
    
    var xForNextPage: Double! = 13 // 等會要儲存此頁 photoInFilterImageView 的 X 軸值以傳送到下一頁

    var width = 367 // 預設寬度
    var height = 295 // 預設高度
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 將照片放到 photoInFilterImageView 中顯示
        photoInFilterImageView.image = UIImage(named: "dog and his host in Karlovy Vary")
        // slidersView 預設隱藏
        slidersView.isHidden = true
        // 設定 filtersScrollView 的 contentOffset 到中段偏左位置
        let xOffset = max(0, (filtersScrollView.contentSize.width - filtersScrollView.bounds.size.width) / 2 - 20)
        // x 的偏移量若為正，將 ScrollView 內容向左捲動，使得內容往右邊移動。
        filtersScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
    
        // 設定三條 Slider 最小值端的顏色
        for i in 0...2{
            filterSliders[i].minimumTrackTintColor = .systemBlue
        }
        // 設定六個預覽照片
        for i in 0...5{
            filterPreviewImageViews[i].frame.size = CGSize(width: 100, height: 100)
            filterPreviewImageViews[i].clipsToBounds = true
            filterPreviewImageViews[i].contentMode = .scaleToFill
            filterPreviewImageViews[i].image = UIImage(named: "dog and his host in Karlovy Vary")
        }
        // 預覽圖片設定為各自的濾鏡效果
        filterVibrantChange(imageView: filterPreviewImageViews[1])
        filterWarmChange(imageView: filterPreviewImageViews[2])
        filterCoolChange(imageView: filterPreviewImageViews[3])
        filterVintageFilter(imageView: filterPreviewImageViews[4])
        filterMonoFilter(imageView: filterPreviewImageViews[5])
        
        // 為點到預覽相片的地方顯示外框，外框設定
        previewFramelLabel.layer.borderWidth = 3
        previewFramelLabel.layer.borderColor = UIColor.orange.cgColor
        previewFramelLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 102)
        // 重設三個 filterSliders
        resetSliders()

    }
    // 重設 slider 的函式
    func resetSliders(){
        filterSliders[0].value = 0
        filterSliders[1].value = 1
        filterSliders[2].value = 1
        filterValueLabels[0].text = "0"
        filterValueLabels[1].text = "1"
        filterValueLabels[2].text = "1"
    }
    // 點擊左下角 Button 出現 Slider 們
    @IBAction func showSlidersView(_ sender: UIButton) {
        slidersView.isHidden = false // slidersView 出現
        resetSliders()
    }
    // Tap Gesture Recognizer 收鍵盤
    @IBAction func hideSlidersView(_ sender: Any) {
        slidersView.isHidden = true // slidersView 隱藏
    }
    // 轉換曝光 Slider 的數字 function
    func floatNumberToStringExposure(value:Float,filterSlderNo:Int){
        if value == 0{
            filterValueLabels[filterSlderNo].text = String(format:"%.1f", 0)
        }else if value < 0.1 && value > 0{
            filterValueLabels[filterSlderNo].text = String(format:"%.1f", 0)
        }else if value > -0.1 && value < 0{
            filterValueLabels[filterSlderNo].text = String(format:"%.1f", 0)
        }else if value > 0{
            filterValueLabels[filterSlderNo].text = String(format:"+%.1f", value)
        }else {
            filterValueLabels[filterSlderNo].text = String(format:"%.1f", value)
        }
    }
    // 轉換對比與飽和度 Slider 的數字 function
    func floatNumberToStringOthers(value:Float,filterSlderNo:Int){
            filterValueLabels[filterSlderNo].text = String(format:"%.1f", value)
    }
    // 調整曝光函數，標準範圍為 -10.0 到 10.0，0.0 代表原始曝光值。
    func exposureFilter(_ input: CIImage, value: Float) -> CIImage?{
        let filter = CIFilter.exposureAdjust()
        filter.inputImage = input
        filter.setValue(value, forKey: kCIInputEVKey)
        
        return filter.outputImage
    }
    // 調整對比函數，kCIInputContrastKey 標準範圍為 0.25 到 4.0，1.0 代表原始的對比度。
    func contrastFilter(_ input: CIImage, value: Float) -> CIImage?{
        let filter = CIFilter.colorControls()
        filter.inputImage = input
        filter.contrast = value
        
        return filter.outputImage
    }
    // 調整飽和度函數，kCIInputSaturationKey 範圍為 0.0 到 2.0，其中 1.0 表示原始的飽和度。
    func saturationFilter(_ input: CIImage, value: Float) -> CIImage?{
        let filter = CIFilter.colorControls()
        filter.inputImage = input
        filter.saturation = value
        
        return filter.outputImage
    }
    // 改變三個 slider 的動作
    @IBAction func changeSliderFilter(_ sender: Any) {
        // 將 Slider 數值顯示轉換為文字，呈現到 filterValueLabel[0]中
        floatNumberToStringExposure(value: filterSliders[0].value, filterSlderNo: 0)
        floatNumberToStringOthers(value: filterSliders[1].value, filterSlderNo: 1)
        floatNumberToStringOthers(value: filterSliders[2].value, filterSlderNo: 1)
        // 取得圖片
        let image = UIImage(named: "dog and his host in Karlovy Vary")
        // 取得輸出的 CIImage
        if let ciImage = CIImage(image: image!),
           let exposuredImage = exposureFilter(ciImage, value: filterSliders[0].value),
           let contrastImage = contrastFilter(exposuredImage, value: filterSliders[1].value),
           let saturationImage = saturationFilter(contrastImage, value: filterSliders[2].value){
                // 將 CIImage 轉換為 UIImage
                let filterImage = UIImage(ciImage: saturationImage)
                // 顯示調整後的圖片
                photoInFilterImageView.image = filterImage
        }
    }
    
    // 鮮豔濾鏡函數
    func filterVibrantChange(imageView:UIImageView){
        // 取得圖片並轉換為 CIImage
        let ciImage = CIImage(image: UIImage(named: "dog and his host in Karlovy Vary")!)
        // 使用 CIFilter 創建 CIColorControls 的濾鏡
        if let filter = CIFilter(name: "CIColorControls") {
            filter.setDefaults() // 將濾鏡屬性設定為預設值
            // 將 ciImage 設置為濾鏡的輸入圖片
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            // 設定飽和度為 1.5（增加飽和度）
            filter.setValue(3, forKey: kCIInputSaturationKey)
            // 設定對比度為 1.2（增加對比度）
            filter.setValue(2, forKey: kCIInputContrastKey)
            // 檢查是否有輸出圖片
            if let outputImage = filter.outputImage {
                // 將 CIImage 轉換為 UIImage
                let filterImage = UIImage(ciImage: outputImage)
                // 顯示調整後的圖片
                imageView.image = filterImage
            }
        }
    }
    
    // 暖色濾鏡
    func filterWarmChange(imageView: UIImageView) {
        // 取得圖片並轉換為 CIImage
        let ciImage = CIImage(image: UIImage(named: "dog and his host in Karlovy Vary")!)
        // 使用 CIFilter 創建 CITemperatureAndTint 濾鏡，並設定輸入圖片為 ciImage
        if let filter = CIFilter(name: "CITemperatureAndTint", parameters: [kCIInputImageKey: ciImage!]) {
            filter.setDefaults() // 將濾鏡屬性設定為預設值
            // 設定色溫為 10000 ，使圖像更暖
            filter.setValue(CIVector(x: 10000), forKey: "inputNeutral")
            if let outputImage = filter.outputImage {
                // 將 CIImage 轉換為 UIImage
                let filterImage = UIImage(ciImage: outputImage)
                // 顯示調整後的圖片
                imageView.image = filterImage
            }
        }
    }
    // 冷色濾鏡
    func filterCoolChange(imageView:UIImageView){
        // 取得圖片並轉換為 CIImage
        let ciImage = CIImage(image: UIImage(named: "dog and his host in Karlovy Vary")!)
        // 使用 CIFilter 創建 CITemperatureAndTint 濾鏡，並設定輸入圖片為 ciImage
        if let filter = CIFilter(name: "CITemperatureAndTint", parameters: [kCIInputImageKey: ciImage!]){
            filter.setDefaults() // 將濾鏡屬性設定為預設值
        // 設定色溫為 4000 ，使圖像更冷
        filter.setValue(CIVector(x: 4000), forKey: "inputNeutral")
            if let outputImage = filter.outputImage{
                // 將 CIImage 轉換為 UIImage
                let filterImage = UIImage(ciImage: outputImage)
                // 顯示調整後的圖片
                imageView.image = filterImage
            }
        }
    }
    // 復古濾鏡
    func filterVintageFilter(imageView:UIImageView){
        // 取得圖片並轉換為 CIImage
        let ciImage = CIImage(image: UIImage(named: "dog and his host in Karlovy Vary")!)
        // 使用 CIFilter 創建 CIPhotoEffectInstant 的濾鏡
        if let filter = CIFilter(name:"CIPhotoEffectInstant"){
            filter.setDefaults() // 將濾鏡屬性設定為預設值
            // 將 ciImage 設置為濾鏡的輸入圖片
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            if let outputImage = filter.outputImage{
                // 將 CIImage 轉換為 UIImage
                let filterImage = UIImage(ciImage: outputImage)
                // 顯示調整後的圖片
                imageView.image = filterImage
            }
        }
    }
    // 黑白濾鏡
    func filterMonoFilter(imageView:UIImageView){
        // 取得圖片並轉換為 CIImage
        let ciImage = CIImage(image: UIImage(named: "dog and his host in Karlovy Vary")!)
        // 使用 CIFilter 創建 CIColorControls 的濾鏡
        if let filter = CIFilter(name: "CIColorControls") {
            filter.setDefaults() // 將濾鏡屬性設定為預設值
            // 將 ciImage 設置為濾鏡的輸入圖片
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            // 將飽和度調整為 0，轉為黑白
            filter.setValue(0.0, forKey: kCIInputSaturationKey)
            if let outputImage = filter.outputImage {
                // 將 CIImage 轉換為 UIImage
                let filterImage = UIImage(ciImage: outputImage)
                // 顯示調整後的圖片
                imageView.image = filterImage
            }
        }
    }
    
    // 點選濾鏡預覽 button
    @IBAction func changeFilterPreview(_ sender: UIButton) {
        let number = Int(sender.tag) // 將 button 的 tag 存到 number 中
        print(sender)
        // 預覽畫面外框隨著點到 button 上的 tag * 100 的 X 軸位置移動
        previewFramelLabel.frame = CGRect(x: 100 * number, y: 0, width: 100, height: 102)
        // 依照選到的不同 button，對中央的照片調整不同的濾鏡
        switch previewButton[number]{
        case previewButton[1]:
            filterVibrantChange(imageView: photoInFilterImageView)
        case previewButton[2]:
            filterWarmChange(imageView: photoInFilterImageView)
        case previewButton[3]:
            filterCoolChange(imageView: photoInFilterImageView)
        case previewButton[4]:
            filterVintageFilter(imageView: photoInFilterImageView)
        case previewButton[5]:
            filterMonoFilter(imageView: photoInFilterImageView)
        default:
            // 如果選擇原圖，則重新載入圖片，可取消之前作用的 filter
            photoInFilterImageView.image = UIImage(named: "dog and his host in Karlovy Vary")
        }
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
            print("3:4 width:\(width)，height:\(height)")
        case 3:
            height = width / 16 * 9 // 16:9 比例
            print("16:9 width:\(width)，height:\(height)")
        default:
            width = 367 // 預設寬度
            height = 295 // 預設高度
        }
        // 設定照片的 UIImageView 尺寸
        photoInFilterImageView.frame.size = CGSize(width: width, height: height)
        // 將照片比例的 UIImageView 置中於畫面 X 軸
        photoInFilterImageView.center.x = view.center.x
        // 將 photoInFilterImageView.frame 最小值 X 傳到 xForNextPage 中
        xForNextPage = photoInFilterImageView.frame.minX
    }
    
    @IBSegueAction func printPhoto(_ coder: NSCoder) -> PrintViewController? {
        // 將原始寬度和高度轉換為 Double 類型
        let width = Double(width)
        let height = Double(height)
        
        // 初始化 PrintViewController
        let controller = PrintViewController(coder: coder)
        
        // 設置 PrintViewController 的 photoToPrintImageView
        controller?.photoToPrintImage = photoInFilterImageView.image
        
        // 將寬度和高度作為 Ratio 物件傳遞給 PrintViewController 的 ratioResult
        controller?.ratioResult = Ratio(width: width, height: height, x: xForNextPage)
        
        return controller
    }
}
