(function(m) {
  var common = person.module("common");
  var uriFactory = person.module("uriFactory");

  /**
   * Skill
   */
  m.Person = Backbone.Model.extend({
    urlRoot: "/api/persons",

  });

  /**
   * Skill collection
   */
  m.Persons = Backbone.Collection.extend({

    model : m.Person,

    initialize: function(options) {
      if (options && options.url) {
        this.url = options.url;
      }
    },

    url : function() {
      return uriFactory.buildUri("persons", {});
    }
  });

  /**
   * Persons List View
   */
  m.PersonsListView = common.TemplatedView.extend({

    events: {
      "click .destroy-btn" : "destroySkill"
    },

    el : $('#persons-list-container'),

    template : $('#persons-list-tmpl'),

    initialize : function(options) {
      this.model = options.model;
    },

    render : function() {
      common.TemplatedView.prototype.render.call(this);
    },

    destroySkill: function(event) {
      this.model.get($(event.target).data('id')).destroy({
        success: function() {
          $(".alert-message success").show();
          window.location = "./skills"
        }
      })
    },
    getModel : function() {
      return this.model.toJSON();
    }
  });

  
})(person.module("personDef"));



