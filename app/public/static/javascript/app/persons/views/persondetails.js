window.PersonView = Backbone.View.extend({

    initialize:function () {
        this.template = _.template(tpl.get('person-details'));
        this.model.bind("change", this.render, this);
    },

    render:function (eventName) {
        var model = this.model.toJSON();
        model.id = model.user_name;
        $(this.el).html(this.template(model));
        return this;
    },

    events:{
        "change input":"change",
        "click .save":"savePerson",
        "click .delete":"deletePerson"
    },

    change:function (event) {
        var target = event.target;
        console.log('changing ' + target.id + ' from: ' + target.defaultValue + ' to: ' + target.value);
        // You could change your model on the spot, like this:
        // var change = {};
        // change[target.name] = target.value;
        // this.model.set(change);
    },

    savePerson:function () {
        this.model.set({
            user_name:$('#personId').val(),
            first_name:$('#first_name').val(),
            last_name:$('#last_name').val()
        });
        if (this.model.isNew()) {
            var self = this;
            app.personList.create(this.model, {
                success:function () {
                    self.model.set("id", self.model.get("user_name"));
                    app.navigate('person/detail/' + self.model.attributes.id, false);
                }
            });
        } else {
            this.model.save();
        }

        return false;
    },

    deletePerson:function () {
        this.model.destroy({
            success:function () {
                alert('Person deleted successfully');
                window.history.back();
            }
        });
        return false;
    }

});