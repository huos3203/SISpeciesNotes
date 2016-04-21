//: [Previous](@previous)

import Foundation
import XCPlayground
import SnapKit


//添加五张图片
func addSubPageView()->UIScrollView {
    
    let scrollView = UIScrollView()
    scrollView.frame = CGRectMake(0, 0, 80, 60)
    scrollView.backgroundColor = UIColor.yellowColor()
    let imageview1 = UIImageView(image: [#Image(imageLiteral: "barcelona-thumb@3x.jpg")#])
    let imageview2 = UIImageView(image:[#Image(imageLiteral: "beijing-thumb@3x.jpg")#])
    let imageview3 = UIImageView(image:[#Image(imageLiteral: "denali-national-park-and-preserve-thumb@3x.jpg")#])
    let imageview4 = UIImageView(image: [#Image(imageLiteral: "walt-disney-world-thumb@3x.jpg")#])
    let imageview5 = UIImageView(image: [#Image(imageLiteral: "sydney-thumb@3x.jpg")#])
    //        let pages = [imageview1,imageview2,imageview3,imageview4,imageview5]
    //向scrollview中添加操作
    scrollView.addSubview(imageview1)
    scrollView.addSubview(imageview2)
    scrollView.addSubview(imageview3)
    scrollView.addSubview(imageview4)
    scrollView.addSubview(imageview5)
    imageview1.snp_makeConstraints { (make) in
        //
        make.left.top.bottom.equalTo(scrollView)
    }

    imageview2.snp_makeConstraints { (make) in
        //
        make.centerY.equalTo(imageview1)
        make.left.equalTo(imageview1.snp_right)
    }

    imageview3.snp_makeConstraints { (make) in
        //
        make.centerY.equalTo(imageview2)
        make.left.equalTo(imageview2.snp_right)
    }

    imageview4.snp_makeConstraints { (make) in
        //
        make.centerY.equalTo(imageview3)
        make.left.equalTo(imageview3.snp_right)
    }
    imageview5.snp_makeConstraints { (make) in
        //
        make.centerY.equalTo(imageview4)
        make.left.equalTo(imageview4.snp_right)
        make.right.equalTo(scrollView.snp_right)
    }
    print("................")
    return scrollView
}

XCPlaygroundPage.currentPage.liveView = addSubPageView()



//: [Next](@next)