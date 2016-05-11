var loadPeopleFromJSON = function(jsonString) {
    console.log(".........")
    var data = JSON.parse(jsonString);
    var people = [];
    
    for (i = 0; i < data.length; i++) {
        //初始化方法无效.....
        //这段代码将创建新的 Person 实例。
        //javaScriptCore 转换的 Objective-C / Swift 方法名是 JavaScript 兼容的。由于 JavaScript 没有参数 名称，任何外部参数名称都会被转换为驼峰形式并且附加到函数名后。在这个例子中，Objective-C 的方法 createWithFirstName:lastName: 变成了在JavaScript中的 createWithFirstNameLastName()
        var person = creatPerson(data[i].first, data[i].last);
//        var person = Person.createWithFirstNameLastName(data[i].first, data[i].last);
        person.birthYear = data[i].year;
        people.push(person);
    }
    return people;
}

//test
var loadPeople = function(nan) {
    return nan
}