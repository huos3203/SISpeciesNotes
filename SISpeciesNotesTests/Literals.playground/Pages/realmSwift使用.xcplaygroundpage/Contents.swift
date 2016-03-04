//: [Previous](@previous)

import Foundation

import Realm


//: 添加数据

class SpeciesModel: RLMObject {
    
    dynamic var name = ""      //物种名称
    
    dynamic var speciesDescription = ""   //物种的描述信息
    dynamic var latitude: Double = 0       //纬度信息
    dynamic var longitude: Double = 0    //经度
    dynamic var created = NSDate()       //创建的时间
}

func addNewSpecies()
{
    var species = SpeciesModel()
    species.name = "nihao"
    species.speciesDescription = "n"
    species.latitude = 3.0
    species.longitude = 5.0
    species.created = NSDate()
    
    let realm = RLMRealm.defaultRealm()
    realm.beginWriteTransaction()
    realm.addObject(species)
    try! realm.commitWriteTransaction()
    
    var sp:RLMResults? = SpeciesModel.allObjects()
    var name = (sp![0] as! SpeciesModel).name
    print(name)
}

addNewSpecies()



/*:
*  @author shuguang, 16-01-20 20:01:19
*
*  查询数据
*
*  @since 1
*/
/**:
 通过物种名，查询realm
 
 - parameter username:物种名
 */
func fetch(speciesname:String)
{
    let realm = RLMRealm.defaultRealm()
    
    //断言
    let predicate = NSPredicate(format: "name beginswith %@", speciesname)
    
    //使用断言,查询物种
    let species = SpeciesModel.objectsWithPredicate(predicate)
    //使用RLMResults对象
    let sum = "检索到的个数：\(species.count)"
    let name = "物种名称：\((species[0] as! SpeciesModel).name)"
    print(sum+"\n"+name)
//    let spe:SpeciesModel? = species[0] as? SpeciesModel
//    print(spe!)
    // 如何从RLMResults中检索出SpeciesModel对象
    
    
}

fetch("nihao")

/*:
*  @author shuguang, 16-01-20 20:01:40
*
*  删除数据
*
*  @since 1
*/























//: [Next](@next)
