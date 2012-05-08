(function(common) {
	common.TemplatedView = Backbone.View.extend({
		render : function() {
			var html = this.template.tmpl(this.getModel());
			this.$el.html(html);
		},

		getModel : function() {
			return this.model.toJSON();
		},
	});
})(person.module("common"));
