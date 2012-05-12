window.PersonListView = Backbone.View.extend({

    tagName: 'table', className: 'table table-striped',

    initialize:function () {
        this.template = _.template(tpl.get('person-list-header'));
        this.model.bind("reset", this.render, this);
        var self = this;
        this.model.bind("add", function (person) {
            $(self.el).find('tbody').append(new PersonListItemView({model:person}).render().el);
        });
    },

    render:function (eventName) {

        var persons = this.model.models;
        var len = persons.length;
        var startPos = (this.options.page - 1) * 8;
        var endPos = Math.min(startPos + 8, len);

        $(this.el).html(this.template(this.model));

        for (var i = startPos; i < endPos; i++) {
            $(this.el).find('tbody').append(new PersonListItemView({model:persons[i]}).render().el);
        }

        $(this.el).append(new Paginator({model: this.model, page: this.options.page}).render().el);

        return this;
    }
});

window.PersonListItemView = Backbone.View.extend({

    tagName: 'tr',

    initialize:function () {
        this.template = _.template(tpl.get('person-list-item'));
        this.model.bind("change", this.render, this);
        this.model.bind("destroy", this.close, this);
    },

    render:function (eventName) {
        this.model.set("id", this.model.get("user_name"));
        $(this.el).html(this.template(this.model.toJSON()));
        return this;
    }

});