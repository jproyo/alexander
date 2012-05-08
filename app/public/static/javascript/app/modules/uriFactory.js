(function(module, $) {

    var resources = [
        { name: "persons",      template: "/api/persons" }
    ];

    module.buildUri = function(resourceName, params) {
        var ret = null;

        $.each(resources, function(index, resource) {
            if(resource.name == resourceName) {
                ret = resolvePlaceholders(resource.template, params);
                return false;
            }
        });

        if(!ret)
            throw new Error("uriFactory.buildUri: unknown resource (" + resourceName + ")");

        return ret;
    };

    function resolvePlaceholders(template, params) {
        var pattern = /\{([A-Za-z0-9_]+)\}/g;
        var ret = "";
        var index = 0;
        var result;

        while((result = pattern.exec(template)) != null) {
            if(result.index > index) {
                ret += template.substring(index, result.index);
            }

            var key = result[1];
            var value = params[key];

            ret += value;

            index = result.index + result[0].length;
        }

        if(template.length > index) {
            ret += template.substring(index);
        }

        return ret;
    }

})(person.module("uriFactory"), jQuery);
