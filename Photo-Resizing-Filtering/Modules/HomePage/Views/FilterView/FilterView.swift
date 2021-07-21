//
//  FilterView.swift
//  Photo-Resizing-Filtering
//
//  Created by Sagar on 21/7/21.
//

import UIKit
class FilterView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var noFilterButton: UIButton!
    @IBOutlet weak var sepiaFilterButton: UIButton!
    @IBOutlet weak var blurFilterButton: UIButton!
    @IBOutlet weak var noirFilterButton: UIButton!
    @IBOutlet weak var photoEffectProcessFilterButton: UIButton!
    @IBOutlet weak var filterEffectSlider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var filterEffectValueLabel: UILabel!
    
    let minSepiaFilterValue : Double = 1
    let minBlurFilterValue : Double = 10
    let minPhotoEffectProcessFilterValue : Int = 0
    let minNoirFilterValue : Int = 0
    weak var delegate : SavePhotoToLibraryDelegate?
    
    enum SelectedFilter {
        case NoFilter
        case SepiaFilter
        case BlurFilter
        case NoirFilter
        case PhotoEffectProcessFilter
        
    }
    
    var image : UIImage?
    var currentFilter = SelectedFilter.NoFilter
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib(frame: frame)
        self.filterEffectValueLabel.backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func hideSlider() {
        self.filterEffectSlider.isHidden = true
        self.filterEffectValueLabel.isHidden = true
    }
    
    private func showSlider() {
        self.filterEffectSlider.isHidden = false
        self.filterEffectValueLabel.isHidden = false
        self.setFilterEffectValueLabel()
        
    }
    
    func processing() {
        self.noFilterButton.backgroundColor = .red
        self.setSlider()
        self.hideSlider()
        self.setImageToImageView()
    }
    
    private func setImageToImageView() {
        self.imageView.image = image
    }
    
    private func setupNib(frame : CGRect) {
        let nib = UINib(nibName: "FilterView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = frame
        addSubview(contentView)
        
    }
    
    private func  setSlider() {
        self.filterEffectSlider.minimumValue = 0.0
        self.setSliderValue(value: 0.0)
    }
    
    private func setSliderValue (value : Float) {
        self.filterEffectSlider.setValue(value, animated: false)
        self.setFilterEffectValueLabel()
    }
    
    private func setFilterEffectValueLabel() {
        self.filterEffectValueLabel.text = String(format: "%.2f", filterEffectSlider.value * 100)
    }
    
    @IBAction func noFilterButtonAction(_ sender: Any) {
        hideSlider()
        noFilterButton.backgroundColor = .red
        sepiaFilterButton.backgroundColor = .clear
        blurFilterButton.backgroundColor = .clear
        noirFilterButton.backgroundColor = .clear
        photoEffectProcessFilterButton.backgroundColor = .clear
        currentFilter = .NoFilter
        self.setFilterEffect()
    }
    
    @IBAction func sepiaFilterButtonAction(_ sender: UIButton) {
        self.filterEffectSlider.minimumValue = Float(minSepiaFilterValue/100.0)
        showSlider()
        noFilterButton.backgroundColor = .clear
        sepiaFilterButton.backgroundColor = .red
        blurFilterButton.backgroundColor = .clear
        noirFilterButton.backgroundColor = .clear
        photoEffectProcessFilterButton.backgroundColor = .clear
        currentFilter = .SepiaFilter
        self.setFilterEffect()
    }
    
    @IBAction func blurFilterButtonAction(_ sender: UIButton) {
        self.filterEffectSlider.minimumValue = Float(minBlurFilterValue/100.0)
        showSlider()
        noFilterButton.backgroundColor = .clear
        sepiaFilterButton.backgroundColor = .clear
        blurFilterButton.backgroundColor = .red
        noirFilterButton.backgroundColor = .clear
        photoEffectProcessFilterButton.backgroundColor = .clear
        currentFilter = .BlurFilter
        self.setFilterEffect()
    }
    
    @IBAction func noirFilterButtonAction(_ sender: UIButton) {
        hideSlider()
        noFilterButton.backgroundColor = .clear
        sepiaFilterButton.backgroundColor = .clear
        blurFilterButton.backgroundColor = .clear
        noirFilterButton.backgroundColor = .red
        photoEffectProcessFilterButton.backgroundColor = .clear
        currentFilter = .NoirFilter
        self.setFilterEffect()
    }
    
    
    @IBAction func photoEffectProcessFilterButtonAction(_ sender: UIButton) {
        hideSlider()
        noFilterButton.backgroundColor = .clear
        sepiaFilterButton.backgroundColor = .clear
        blurFilterButton.backgroundColor = .clear
        noirFilterButton.backgroundColor = .clear
        photoEffectProcessFilterButton.backgroundColor = .red
        currentFilter = .PhotoEffectProcessFilter
        self.setFilterEffect()
    }
    
    @IBAction func filterEffectSliderValueChanged(_ sender: UISlider) {
        
        self.setFilterEffectValueLabel()
        setFilterEffect()
    }
    
    private func setFilterEffect() {
        guard let image = self.image else {
            return
        }
        self.imageView.image = image
        switch currentFilter {
        case .SepiaFilter:
            self.imageView.image = applyFilterTo(filterEffect: Filter(filterName: "CISepiaTone", filterEffectValue: filterEffectSlider.value * 100, filterEffectValueName: kCIInputIntensityKey), image: image)
            break
        case .PhotoEffectProcessFilter:
            self.imageView.image = applyFilterTo(filterEffect: Filter(filterName: "CIPhotoEffectProcess", filterEffectValue: nil, filterEffectValueName: nil), image: image)
            break
        case .BlurFilter:
            self.imageView.image = applyFilterTo(filterEffect: Filter(filterName: "CIGaussianBlur", filterEffectValue: filterEffectSlider.value*100, filterEffectValueName: kCIInputRadiusKey), image: image)
            break
        case .NoirFilter:
            self.imageView.image = applyFilterTo(filterEffect: Filter(filterName: "CIPhotoEffectNoir", filterEffectValue: nil, filterEffectValueName: nil), image: image)
            break
        case .NoFilter:
            self.imageView.image = self.image
            break
            
        default:
            self.imageView.image = self.image
            break
        }
    }
    
    private func applyFilterTo(filterEffect : Filter, image : UIImage)->UIImage? {
        guard let cgImage = image.cgImage, let openGLContext = EAGLContext(api: .openGLES3) else {
            return nil
        }
        let context = CIContext(eaglContext: openGLContext)
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: filterEffect.filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let filterEffectValue = filterEffect.filterEffectValue, let filterEffectValueName = filterEffect.filterEffectValueName {
            filter?.setValue(filterEffectValue, forKey: filterEffectValueName)
        }
        
        var filterdImage : UIImage?
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage, let cgImageResult = context.createCGImage(output, from: output.extent) {
            filterdImage = UIImage(cgImage: cgImageResult)
        }
        return filterdImage
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        guard let filteredImage = self.imageView.image else {
            return
        }
        delegate?.getPhotoToSave(image: filteredImage)
    }
    
}
