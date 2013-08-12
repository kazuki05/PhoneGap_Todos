(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  $(function() {
    var App, AppView, Todo, TodoList, TodoView, Todos, _ref, _ref1, _ref2, _ref3;
    Todo = (function(_super) {
      __extends(Todo, _super);

      function Todo() {
        _ref = Todo.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Todo.prototype.defaults = function() {
        return {
          done: false
        };
      };

      Todo.prototype.toggle = function() {
        return this.save({
          done: !this.get("done")
        });
      };

      return Todo;

    })(Backbone.Model);
    TodoList = (function(_super) {
      __extends(TodoList, _super);

      function TodoList() {
        _ref1 = TodoList.__super__.constructor.apply(this, arguments);
        return _ref1;
      }

      TodoList.prototype.model = Todo;

      TodoList.prototype.localStorage = new Store("todos");

      TodoList.prototype.done = function() {
        return this.filter(function(todo) {
          return todo.get('done');
        });
      };

      TodoList.prototype.remaining = function() {
        return this.without.apply(this, this.done());
      };

      return TodoList;

    })(Backbone.Collection);
    TodoView = (function(_super) {
      __extends(TodoView, _super);

      function TodoView() {
        _ref2 = TodoView.__super__.constructor.apply(this, arguments);
        return _ref2;
      }

      TodoView.prototype.tagName = "li";

      TodoView.prototype.template = $("#item-template").template();

      TodoView.prototype.events = {
        "change   .check": "toggleDone",
        "dblclick .todo-content": "edit",
        "click    .todo-destroy": "destroy",
        "keypress .todo-input": "updateOnEnter",
        "blur     .todo-input": "close"
      };

      TodoView.prototype.initialize = function() {
        _.bindAll(this, 'render', 'close', 'remove', 'edit');
        this.model.bind('change', this.render);
        return this.model.bind('destroy', this.remove);
      };

      TodoView.prototype.render = function() {
        var element;
        console.log('call render');
        console.log("" + (this.model.toJSON()));
        element = $.tmpl(this.template, this.model.toJSON());
        $(this.el).html(element);
        this.input = this.$(".todo-input");
        return this;
      };

      TodoView.prototype.toggleDone = function() {
        console.log('call toggleDone');
        return this.model.toggle();
      };

      TodoView.prototype.edit = function() {
        $(this.el).addClass("editing");
        return this.input.focus();
      };

      TodoView.prototype.close = function() {
        this.model.save({
          content: this.input.val()
        });
        return $(this.el).removeClass("editing");
      };

      TodoView.prototype.updateOnEnter = function(e) {
        if (e.keyCode === 13) {
          return e.target.blur();
        }
      };

      TodoView.prototype.remove = function() {
        return $(this.el).remove();
      };

      TodoView.prototype.destroy = function() {
        return this.model.destroy();
      };

      return TodoView;

    })(Backbone.View);
    AppView = (function(_super) {
      __extends(AppView, _super);

      function AppView() {
        _ref3 = AppView.__super__.constructor.apply(this, arguments);
        return _ref3;
      }

      AppView.prototype.el = $("#todoapp");

      AppView.prototype.statsTemplate = $("#stats-template").template();

      AppView.prototype.events = {
        "keypress #new-todo": "createOnEnter",
        "click .todo-clear a": "clearCompleted"
      };

      AppView.prototype.initialize = function() {
        console.log('call initialize');
        _.bindAll(this, 'addOne', 'addAll', 'render');
        console.log('1');
        this.input = this.$("#new-todo");
        console.log('2');
        Todos.bind('add', this.addOne);
        console.log('3');
        Todos.bind('refresh', this.addAll);
        console.log('4');
        Todos.bind('all', this.render);
        console.log('5');
        Todos.fetch();
        return console.log('end initialize');
      };

      AppView.prototype.render = function() {
        var done, element;
        done = Todos.done().length;
        element = $.tmpl(this.statsTemplate, {
          total: Todos.length,
          done: Todos.done().length,
          remaining: Todos.remaining().length
        });
        return this.$('#todo-stats').html(element);
      };

      AppView.prototype.addOne = function(todo) {
        var view;
        view = new TodoView({
          model: todo
        });
        return this.$("#todo-list").append(view.render().el);
      };

      AppView.prototype.addAll = function() {
        return Todos.each(this.addOne);
      };

      AppView.prototype.createOnEnter = function(e) {
        var value;
        if (e.keyCode !== 13) {
          return;
        }
        value = this.input.val();
        if (!value) {
          return;
        }
        Todos.create({
          content: value
        });
        return this.input.val('');
      };

      AppView.prototype.clearCompleted = function() {
        _.each(Todos.done(), function(todo) {
          return todo.destroy();
        });
        return false;
      };

      return AppView;

    })(Backbone.View);
    Todos = new TodoList;
    console.log('new Todos');
    App = new AppView;
    return console.log('new App');
  });

}).call(this);
