Backbone.View.prototype.close = function () {
    console.log('Closing view ' + this);
    if (this.beforeClose) {
        this.beforeClose();
    }
    this.remove();
    this.unbind();
};

var AppRouter = Backbone.Router.extend({

    initialize:function () {
    },

    routes:{
        "":"list",
        "person/page/:page"  : "list",
        "person/after/save/:id": "personAfterSave",
        "person/new":"newPerson",
        "person/detail/:id":"personDetails",
        "person/delete/:id": "personDelete"
    },

    list: function(page) {
        var p = page ? parseInt(page, 10) : 1;
        this.personList = new PersonCollection();
        this.personList.fetch({success:function () {
            $('#content').html(new PersonListView({model:app.personList, page: p}).render().el);
            if (callback) callback();
        }});
    },


    personDelete: function (id) {
        var person = app.personList.get(id);
        person.destroy({
            success: function () {
                app.showView('#content', new PersonListView({model:this.personList}));
            }
        });
        return false;
    },

    personAfterSave: function(id){
        app.showView('#content', new PersonListView({model:this.personList}));
    },

    personDetails:function (id) {
        var person = app.personList.get(id);
        app.showView('#content', new PersonView({model:person}));
    },

    newPerson:function () {
        app.showView('#content', new PersonView({model:new Person()}));
    },

    showView:function (selector, view) {
        if (this.currentView) this.currentView.close();
        $(selector).html(view.render().el);
        this.currentView = view;
        return view;
    },

});

tpl.loadTemplates(['person-details', 'person-list-item', 'person-list-header'], function () {
    app = new AppRouter();
    Backbone.history.start();
});