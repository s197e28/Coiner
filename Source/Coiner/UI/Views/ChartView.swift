//
//  ChartView.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/25/22.
//

import Foundation
import UIKit

final class ChartView: UIView {
    
    private lazy var minLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = SemanticColor.secondaryTextColor
        return label
    }()
    
    private lazy var maxLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = SemanticColor.secondaryTextColor
        return label
    }()
    
    private var graphLayer: CALayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clear() {
        graphLayer?.removeFromSuperlayer()
        minLabel.removeFromSuperview()
        maxLabel.removeFromSuperview()
    }
    
    func drawPoints(points: [Float], minLabelText: String? = nil, maxLabelText: String? = nil, completion: (() -> Void)? = nil) {
        guard points.count > 1,
              let minPoint = points.min(),
              let maxPoint = points.max() else {
            return
        }
        
        let frameWidth = frame.width
        let frameHeight = frame.height
        let edgeOffset: CGFloat = 25.0
        
        let stepByX = frameWidth / CGFloat(points.count - 1)
        let deltaY = maxPoint - minPoint
        let scaleByY = deltaY > 0 ? (frameHeight - 50) / CGFloat(deltaY) : 1
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            var curentXPos:CGFloat = 0
            var coordinates: [CGPoint] = []
            
            for point in points.map({ CGFloat($0 - minPoint) }) {
                let yPos = frameHeight - edgeOffset - (point * scaleByY)
                coordinates.append(CGPoint(x: curentXPos, y: yPos))
                curentXPos += stepByX
            }
            
            let minCoordinate = coordinates.min(by: { $0.y > $1.y })
            let maxCoordinate = coordinates.max(by: { $0.y > $1.y })
            
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                
                self.graphLayer = self.drawChart(with: coordinates, of: UIColor.black, in: self)
                
                if let minCoord = minCoordinate {
                    self.minLabel.text = minLabelText
                    let lSize = self.minLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
                    var lXPos = minCoord.x - lSize.width / 2
                    lXPos = lXPos > 0 ? lXPos : 4
                    lXPos = lXPos + lSize.width < frameWidth ? lXPos : frameWidth - lSize.width - 4
                    let lYPos = minCoord.y + 2
                    self.minLabel.frame = .init(origin: CGPoint(x: lXPos, y: lYPos), size: lSize)
                    self.addSubview(self.minLabel)
                }
                
                if let maxCoord = maxCoordinate {
                    self.maxLabel.text = maxLabelText
                    let lSize = self.maxLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
                    var lXPos = maxCoord.x - lSize.width / 2
                    lXPos = lXPos > 0 ? lXPos : 4
                    lXPos = lXPos + lSize.width < frameWidth ? lXPos : frameWidth - lSize.width - 4
                    let lYPos = maxCoord.y - lSize.height - 2
                    self.maxLabel.frame = .init(origin: CGPoint(x: lXPos, y: lYPos), size: lSize)
                    self.addSubview(self.maxLabel)
                }
                
                completion?()
            }
        }
    }
    
    // MARK: Private methods
    
    private func drawChart(with coordinates: [CGPoint], of lineColor: UIColor, in view: UIView) -> CALayer? {
        let path = UIBezierPath()
        
        guard let firstCoordinate = coordinates.first else {
            return nil
        }
        
        path.move(to: firstCoordinate)
        path.addLine(to: firstCoordinate)
        for coordinate in coordinates.dropFirst() {
            path.addLine(to: coordinate)
            path.move(to: coordinate)
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 2.0
        
        view.layer.addSublayer(shapeLayer)
        
        return shapeLayer
    }
}
