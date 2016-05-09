var loadPeopleFromJSON = function(jsonString) {
    console.log(".........")
    var data = JSON.parse(jsonString);
    var people = [];
    for (i = 0; i < data.length; i++) {
        
        var person = Person.createWithFirstName();
        person.birthYear = data[i].year;
        
        people.push(data[i].year);
    }
    return people;
}

var loadPeople = function(nan) {
    return nan
}