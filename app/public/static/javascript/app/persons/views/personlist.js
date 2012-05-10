window.PersonListView = Backbone.View.extend({

    tagName:'div',

    initialize:function () {
        this.template = _.template(tpl.get('person-list-header'));
        this.model.bind("reset", this.render, this);
        var self = this;
        this.model.bind("add", function (person) {
            $(self.el).find('tbody').append(new PersonListItemView({model:person}).render().el);
        });
    },

    render:function (eventName) {
        _.each(this.model.models, function (person) {
            $(this.el).find('tbody').append(new PersonListItemView({model:person}).render().el);
        }, this);
        $(this.el).html(this.template(this.model));
        return this;
    }
});

window.PersonListItemView = Backbone.View.extend({

    tagName:"tr",

    initialize:function () {
        this.template = _.template(tpl.get('person-list-item'));
        this.model.bind("change", this.render, this);
        this.model.bind("destroy", this.close, this);
    },

    render:function (eventName) {
        $(this.el).html(this.template(this.model.toJSON()));
        return this;
    }

});