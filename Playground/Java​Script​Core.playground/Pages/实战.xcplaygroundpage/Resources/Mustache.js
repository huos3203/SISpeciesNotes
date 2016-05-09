var loadPeopleFromJSON = function(jsonString) {
    console.log(".........")
    var data = JSON.parse(jsonString);
    var people = [];
    for (i = 0; i < data.length; i++) {
        //初始化方法无效.....
        var person = Person.createWithFirstNameLastName(data[i].first, data[i].last);
        person.birthYear = data[i].year;
        
        people.push(data[i].year);
    }
    return people;
}

var loadPeople = function(nan) {
    return nan
}