//= require knockout-3.0.0
//= require knockout.validation.min

(function() {
  ko.validation.rules.pattern.message = 'Invalid.';

  ko.validation.configure({
    registerExtenders:    true,
    messagesOnModified:   true,
    insertMessages:       false,
    parseInputAttributes: true,
    messageTemplate:      null
  });
  // Bind twitter typeahead
  ko.bindingHandlers.typeahead = {
    init: function (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
      var $element     = $(element),
          allBindings  = allBindingsAccessor(),
          typeaheadArr = ko.utils.unwrapObservable(valueAccessor()),
          config = {
            'source':    typeaheadArr,
            'minLength': allBindings.minLength,
            'items':     allBindings.items
          };

      if ( $element.data('prefetch') ) {
        config.prefetch = $element.data('prefetch');
      }

      $element.attr("autocomplete", "off").typeahead(config);
      $element.on('typeahead:selected', function(evt, data) {
        allBindings.value($element.val());
      });
    }
  };

  ko.bindingHandlers.enterkey = {
    init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
      var allBindings = allBindingsAccessor();
      $(element).on('keypress', 'input', function(e) {
        var keyCode = e.which || e.keyCode;
        if ( keyCode !== 13 ) {
          return true;
        }

        var target = e.target;
        target.blur();
        allBindings.enterkey.call(viewModel, viewModel, target, element);
        return false;
      });
    }
  };

  function Role(data) {
    var self = this;

    self.id           = ko.observable(data.id);
    self.name         = ko.observable(data.name).extend({ required: true });
    self.quantity     = ko.observable(parseInt(data.quantity || 1, 10)).extend({ required: true, min: 1 });
    self.filled_count = ko.observable(0);
    self.needed_count = ko.computed(function() {
      return self.quantity() - self.filled_count();
    });

    self.roleURL = ko.computed(function() {
      if ( self.id() ) {
        return $("#role-editor").data('roleUri').replace('%7Bid%7D', self.id());
      } else {
        return '#';
      }
    });

    self.errors = ko.validation.group(self);
  }

  function RoleViewModel() {
    var self = this,
        mappedRoles = $.map($.isArray(window.roles) ? window.roles : [], function(item) { return new Role(item); });

    self.roles = ko.observableArray(mappedRoles);

    self.newRoleName     = ko.observable("").extend({ required: true });
    self.newRoleQuantity = ko.observable(1).extend({ required: true, min: 1 });

    self.addRole = function() {
      var role = new Role({ name: this.newRoleName(), quantity: this.newRoleQuantity() });

      // TODO: I don't like this, but need to figure out how we want to display error messages
      if ( role.errors().length > 0 ) {
        console.log(role.errors());
        return;
      }

      $.ajax(
        $("#role-editor").data('addRoleUri'),
        {
          type:       'post',
          data:        ko.toJSON({ 'role': role }),
          contentType: 'application/json',
          dataType:    'json'
        }
      )
      .success(function(o) {
        if ( typeof o === 'object' && typeof o.role === 'object' ) {
          console.log('Setting ID to ' + o.role.id);
          role.id(o.role.id);
          self.roles.push(role);
          self.newRoleName("");
          self.newRoleName.isModified(false);
          self.newRoleQuantity(1);
          self.newRoleQuantity.isModified(false);
        }
      })
      .fail(function(o) {
        alert("Unable to save this role!");
      })
      .always(function() {
        $("#newRoleName").typeahead('setQuery', '').focus();
        //$("#newRoleName").focus();
      });
    };
  }

  $(document).on("page:change", function() {
    // TODO: I'm not entirely sure how to manage separate pages like this with turbolinks and have specific JS for actions.
    // This seems dumb:
    if ( $("#role-editor").length === 0 ) {
      return;
    }
    ko.applyBindings(new RoleViewModel());
  });
}());
