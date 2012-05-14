window.Person = Backbone.Model.extend({
    urlRoot:"/api/persons",
    defaults:{
        "id":null,
        "user_name": "",
        "first_name":"",
        "last_name":""
    }
});

window.PersonCollection = Backbone.Collection.extend({
    model:Person,
    url:"/api/persons"
});