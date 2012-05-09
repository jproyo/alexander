window.Person = Backbone.Model.extend({
    urlRoot:"/api/persons",
    defaults:{
        "user_name":null,
        "first_name":"",
        "last_name":""
    }
});

window.PersonCollection = Backbone.Collection.extend({
    model:Person,
    url:"/api/persons"
});