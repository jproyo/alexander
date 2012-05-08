jQuery(function($) {
	var personDef = person.module("personDef");

	var personsEntities = new personDef.Persons();

	personsEntities.fetch({
		success: function() {
			var personsListView = new personDef.PersonsListView({model:personsEntities});
			personsListView.render();
		}, error: function() {
			alert("Error fetching persons");
		}
	});
});