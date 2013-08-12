$ ->
    ###################################################################
    # Todo Model
    # Our basic Todo model has `content` and `done` attributes.
    ###################################################################
    class Todo extends Backbone.Model
        defaults:->
            done: false

        toggle:->
            this.save
                done: !this.get("done")

    ###################################################################
    # TodoList Collection
    ###################################################################
    class TodoList extends Backbone.Collection
        model: Todo

        # Save all of the todo items under the `"todos"` namespace.
        localStorage: new Store("todos")

        # Filter down the list of all todo items that are finished.
        done:->
            @filter (todo)-> todo.get('done')

        remaining:->
            @without.apply(this, @done())

    ###################################################################
    # TodoView View
    ###################################################################
    class TodoView extends Backbone.View

        #... is a list tag.
        tagName:  "li"

        # Cache the template function for a single item.
        template: $("#item-template").template()

        events:
            "change   .check"        : "toggleDone",
            "dblclick .todo-content" : "edit",
            "click    .todo-destroy" : "destroy",
            "keypress .todo-input"   : "updateOnEnter",
            "blur     .todo-input"   : "close"

        initialize:->
            _.bindAll(this, 'render', 'close', 'remove', 'edit')
            this.model.bind('change', this.render)
            this.model.bind('destroy', this.remove)

        render:->
            console.log 'call render'
            console.log "#{this.model.toJSON()}"
            element = $.tmpl(this.template, this.model.toJSON())
            $(this.el).html(element)
            this.input = this.$(".todo-input")
            return this

        toggleDone:->
            console.log 'call toggleDone'
            this.model.toggle()

        # Switch this view into `"editing"` mode, displaying the input field.
        edit:->
            $(this.el).addClass("editing")
            this.input.focus()

        # Close the `"editing"` mode, saving changes to the todo.
        close:->
            this.model.save({content: this.input.val()})
            $(this.el).removeClass("editing")

        # If you hit `enter`, we're through editing the item.
        updateOnEnter:(e)->
            if e.keyCode is 13
                e.target.blur()

        remove:->
            $(this.el).remove()

        destroy:->
            this.model.destroy()

    ###################################################################
    # AppView View
    ###################################################################
    # Our overall **AppView** is the top-level piece of UI.
    class AppView extends Backbone.View

        # Instead of generating a new element, bind to the existing skeleton of
        # the App already present in the HTML.
        el: $("#todoapp")

        statsTemplate: $("#stats-template").template()

        events:
            "keypress #new-todo":  "createOnEnter",
            "click .todo-clear a": "clearCompleted"

        # At initialization we bind to the relevant events on the `Todos`
        # collection, when items are added or changed. Kick things off by
        # loading any preexisting todos that might be saved in *localStorage*.
        initialize:->
            console.log 'call initialize'
            _.bindAll(this, 'addOne', 'addAll', 'render')
            console.log '1'
            this.input    = this.$("#new-todo")
            console.log '2'
            Todos.bind('add',     this.addOne)
            console.log '3'
            Todos.bind('refresh', this.addAll)
            console.log '4'
            Todos.bind('all',     this.render)
            console.log '5'
            Todos.fetch()
            console.log 'end initialize'

        # Re-rendering the App just means refreshing the statistics -- the rest
        # of the app doesn't change.
        render:->
            done = Todos.done().length;
            element = $.tmpl(this.statsTemplate, {
                total:      Todos.length,
                done:       Todos.done().length,
                remaining:  Todos.remaining().length
            })
            this.$('#todo-stats').html(element)
            
        #render: =>
        #    console.log "Todos.length=#{Todos.length}"
        #    console.log "Todos.done().length=#{Todos.done().length}"
        #    console.log "Todos.remaining().length=#{Todos.remaining().length}"
        #    this.$('#todo-stats').html( @statsTemplate({
        #        total:      Todos.length,
        #        done:       Todos.done().length,
        #        remaining:  Todos.remaining().length
        #    }))

        # Add a single todo item to the list by creating a view for it, and
        # appending its element to the `<ul>`.
        addOne:(todo)->
            view = new TodoView({model: todo})
            this.$("#todo-list").append(view.render().el)

        # Add all items in the **Todos** collection at once.
        addAll:->
            Todos.each(this.addOne)

        # If you hit return in the main input field, create new **Todo** model
        createOnEnter:(e)->
            if (e.keyCode isnt 13)
                return

            value = this.input.val()
            if ( !value )
                return

            Todos.create({content: value})
            this.input.val('')

        #clearCompleted:->
        #    _.each(Todos.done(), (todo)->
        #        todo.destroy()
        #    )
        #        return false

        clearCompleted: ->
            _.each(Todos.done(), (todo) ->
                todo.destroy()
            )
            return false

    # Create our global collection of Todos.
    Todos = new TodoList
    console.log 'new Todos'
    # Finally, we kick things off by creating the **App**.
    App = new AppView
    console.log 'new App'
