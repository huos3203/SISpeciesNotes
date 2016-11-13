//
//  ViewController.swift
//  SISpeciesNotes
//
//  Created by 星夜暮晨 on 2015-04-29.
//  Copyright (c) 2015 益行人. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/// 地图首页
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // MARK: - 属性
    
    /// 地图控件
    @IBOutlet weak fileprivate var mapView: MKMapView!
    /// 位置管理器
    fileprivate var locationManager = CLLocationManager()
    /// 最后一个标记点信息
    fileprivate var lastAnnotation: MKAnnotation!
    /// 标记用户是否定位
    fileprivate var isUserLocated = false
    
    // MARK: - 控制器生命周期

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "未能获取定位"
        
        initMapView()
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            print("请求授权")
        } else {
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Realm相关方法
    
    // MARK: - CLLocationManager Delegate
    
    /// 改变授权状态信息时调用
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            print("已禁止应用获取用户位置信息，请授权！")
        } else {
            mapView.showsUserLocation = true
        }
    }
    
    // MARK: - MKMapView Delegate
    
    /// 标记的视图定义
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let currentAnnotation = annotation as? SpeciesAnnotation else { return nil }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: currentAnnotation.subtitle!) else {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: currentAnnotation.subtitle!)
            
            annotationView.image = currentAnnotation.category.getImage()
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            annotationView.centerOffset = CGPoint(x: 0, y: -10)
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            if currentAnnotation.category == .Uncategorized {
                annotationView.isDraggable = true
            }
            return annotationView
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for annotationView in views {
            if annotationView.annotation is SpeciesAnnotation {
                annotationView.transform = CGAffineTransform(translationX: 0, y: -500)
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                    annotationView.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: nil)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if view.annotation is SpeciesAnnotation {
            self.performSegue(withIdentifier: "NewEntry", sender: view.annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if newState == .ending {
            view.dragState = .none
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        getCurrentGeoInfo()
    }
    
    // MARK: - 按钮动作
    
    @IBAction func addNewEntryTapped(_ sender: UIBarButtonItem) {
        addNewAnnotation()
    }
    
    @IBAction func centerToUserLocationTapped(_ sender: UIBarButtonItem) {
        centerToUsersLocation()
    }
    
    /// 界面跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewEntry" {
            let controller = segue.destination as! AddNewEntryController
            let speciesAnnotation = sender as! SpeciesAnnotation
            controller.selectedAnnotation = speciesAnnotation
        }
    }
    
    @IBAction func unwindFromAddNewEntry(_ segue: UIStoryboardSegue) {
        
        let addNewEntryController = segue.source as! AddNewEntryController
        
        if lastAnnotation != nil {
            mapView.removeAnnotation(lastAnnotation)
        } else {
            for annotation in mapView.annotations {
                
            }
        }
        
        lastAnnotation = nil
    }
    
    // MARK: - 私有的简易方法
    
    /// 将地图中心重定位到当前用户位置
    fileprivate func centerToUsersLocation() {
        let userLocation = mapView.userLocation.coordinate
        mapView.setCenterCoordinate(userLocation, zoomLevel: 5, animated: true)
    }
    
    /// 添加新的标记点
    fileprivate func addNewAnnotation() {
        if lastAnnotation == nil {

            let species = SpeciesAnnotation(coordinate: mapView.centerCoordinate, title: "新物种", sub: .Uncategorized)
            
            mapView.addAnnotation(species)
            lastAnnotation = species
            
        }else {
            let alertController = UIAlertController(title: "这个位置已被标记", message: "当前位置已经标记过了，如果需要更改这个标记的位置，请将其拖动到其他位置！", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "确定", style: .destructive, handler: {
                (alert: UIAlertAction) -> Void in
                    alertController.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // 获取当前地理位置信息
    fileprivate func getCurrentGeoInfo() {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        geocoder.reverseGeocodeLocation(location, completionHandler: {
            placemarks, error in
            if error != nil {
                print("获取当前的位置失败：\(error)")
                return
            }
            for placemark in placemarks! {
                print(placemark.addressDictionary)
                if let area = placemark.addressDictionary!["SubLocality"] as? String {
                    // 区
                    self.title = area
                    print(area)
                }else if let city = placemark.addressDictionary!["City"] as? String {
                    // 市
                    self.title = city
                    print(city)
                }else if let province = placemark.addressDictionary!["State"] as? String {
                    // 省
                    self.title = province
                    print(province)
                }
                else if let country = placemark.addressDictionary!["Country"] as? String {
                    // 国家
                    self.title = country
                    print(country)
                }else {
                    self.title = "未能获取定位"
                }
            }
        })
        
    }
    
    // MARK: - Setter & Getter

    func initMapView() {
        mapView.deleteAttributionLabel()
        mapView.deleteMapInfo()
    }
}

