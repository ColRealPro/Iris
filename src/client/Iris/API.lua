local Types = require(script.Parent.Types)

return function(Iris: Types.Iris)
    -- basic wrapper for nearly every widget, saves space.
    local function wrapper(name: string): (arguments: Types.WidgetArguments?, states: Types.States?) -> Types.Widget
        return function(arguments: Types.WidgetArguments?, states: Types.States?): Types.Widget
            return Iris.Internal._Insert(name, arguments, states)
        end
    end

    --[[
        ----------------------------
            [SECTION] Window API
        ----------------------------
    ]]
    --[=[
        @class Window
        
        Windows are the fundamental widget for Iris. Every other widget must be a descendant of a window.

        ```lua
        Iris.Window({ "Example Window" })
            Iris.Text({ "This is an example window!" })
        Iris.End()
        ```

        If you do not want the code inside a window to run unless it is open then you can use the following:
        ```lua
        local window = Iris.Window({ "Many Widgets Window" })

        if window.state.isOpened.value and window.state.isUncollapsed.value then
            Iris.Text({ "I will only be created when the window is open." })
        end
        Iris.End() -- must always call Iris.End(), regardless of whether the window is open or not.
        ```
    ]=]

    --[=[
        @prop Window Iris.Window
        @within Window
        @tag Widget
        @tag HasChildren
        @tag HasState
        
        The top-level container for all other widgets to be created within.
        Can be moved and resized across the screen. Cannot contain embedded windows.
        Menus can be appended to windows creating a menubar.
        
        ```lua
        hasChildren = true
        hasState = true
        Arguments = {
            Title: string,
            NoTitleBar: boolean? = false,
            NoBackground: boolean? = false, -- the background behind the widget container.
            NoCollapse: boolean? = false,
            NoClose: boolean? = false,
            NoMove: boolean? = false,
            NoScrollbar: boolean? = false, -- the scrollbar if the window is too short for all widgets.
            NoResize: boolean? = false,
            NoNav: boolean? = false, -- unimplemented.
            NoMenu: boolean? -- whether the menubar will show if created.
        }
        Events = {
            opened: () -> boolean, -- once when opened.
            closed: () -> boolean, -- once when closed.
            collapsed: () -> boolean, -- once when collapsed.
            uncollapsed: () -> boolean, -- once when uncollapsed.
            hovered: () -> boolean -- fires when the mouse hovers over any of the window.
        }
        States = {
            size = State<Vector2>?,
            position = State<Vector2>?,
            isUncollapsed = State<boolean>?,
            isOpened = State<boolean>?,
            scrollDistance = State<number>? -- vertical scroll distance, if too short.
        }
        ```
    ]=]
    Iris.Window = wrapper("Window")

    --[=[
        @function SetFocusedWindow
        @within Iris
        @param window Types.Widget -- the window to focus.

        Sets the focused window to the window provided, which brings it to the front and makes it active.
    ]=]
    Iris.SetFocusedWindow = Iris.Internal.SetFocusedWindow

    --[=[
        @prop Tooltip Iris.Tooltip
        @within Window
        @tag Widget

        Displays a text label next to the cursor
        
        ```lua
        hasChildren = false
        hasState = false
        Arguments = {
            Text: string
        }
        ```
    ]=]
    Iris.Tooltip = wrapper("Tooltip")

    --[[
        ---------------------------------
            [SECTION] Menu Widget API
        ---------------------------------
    ]]
    --[=[
        @class Menu
        Menu API
    ]=]

    --[=[
        @prop MenuBar Iris.MenuBar
        @within Menu
        @tag Widget
        @tag HasChildren
        
        Creates a MenuBar for the current window. Must be called directly under a Window and not within a child widget.
        :::info
            This does not create any menus, just tells the window that we going to add menus within.
        :::
        
        ```lua
        hasChildren = true
        hasState = false
        ```
    ]=]
    Iris.MenuBar = wrapper("MenuBar")

    --[=[
        @prop Menu Iris.Menu
        @within Menu
        @tag Widget
        @tag HasChildren
        @tag HasState
        
        Creates an collapsable menu. If the Menu is created directly under a MenuBar, then the widget will
        be placed horizontally below the window title. If the menu Menu is created within another menu, then
        it will be placed vertically alongside MenuItems and display an arrow alongside.

        The opened menu will be a vertically listed box below or next to the button.

        :::info
        There are widgets which are designed for being parented to a menu whilst other happens to work. There is nothing
        preventing you from adding any widget as a child, but the behaviour is unexplained and not intended, despite allowed.
        :::
        
        ```lua
        hasChildren = true
        hasState = true
        Arguments = {
            Text: string -- menu text.
        }
        Events = {
            clicked: () -> boolean,
            opened: () -> boolean, -- once when opened.
            closed: () -> boolean, -- once when closed.
            hovered: () -> boolean
        }
        States = {
            isOpened: State<boolean>? -- whether the menu is open, including any sub-menus within.
        }
        ```
    ]=]
    Iris.Menu = wrapper("Menu")

    --[=[
        @prop MenuItem Iris.MenuItem
        @within Menu
        @tag Widget
        
        Creates a button within a menu. The optional KeyCode and ModiferKey arguments will show the keys next
        to the title, but **will not** bind any connection to them. You will need to do this yourself.
        
        ```lua
        hasChildren = false
        hasState = false
        Arguments = {
            Text: string,
            KeyCode: Enum.KeyCode? = nil, -- an optional keycode, does not actually connect an event.
            ModifierKey: Enum.ModifierKey? = nil -- an optional modifer key for the key code.
        }
        Events = {
            clicked: () -> boolean,
            hovered: () -> boolean
        }
        ```
    ]=]
    Iris.MenuItem = wrapper("MenuItem")

    --[=[
        @prop MenuToggle Iris.MenuToggle
        @within Menu
        @tag Widget
        @tag HasState
        
        Creates a togglable button within a menu. The optional KeyCode and ModiferKey arguments act the same
        as the MenuItem. It is not visually the same as a checkbox, but has the same functionality.
        
        ```lua
        hasChildren = false
        hasState = true
        Arguments = {
            Text: string,
            KeyCode: Enum.KeyCode? = nil, -- an optional keycode, does not actually connect an event.
            ModifierKey: Enum.ModifierKey? = nil -- an optional modifer key for the key code.
        }
        Events = {
            checked: () -> boolean, -- once on check.
            unchecked: () -> boolean, -- once on uncheck.
            hovered: () -> boolean
        }
        States = {
            isChecked: State<boolean>?
        }
        ```
    ]=]
    Iris.MenuToggle = wrapper("MenuToggle")

    --[[
        -----------------------------------
            [SECTION] Format Widget Iris
        -----------------------------------
    ]]
    --[=[
        @class Format
        Format API
    ]=]

    --[=[
        @prop Separator Iris.Separator
        @within Format
        @tag Widget

        A vertical or horizonal line, depending on the context, which visually seperates widgets.
        
        ```lua
        hasChildren = false
        hasState = false
        ```
    ]=]
    Iris.Separator = wrapper("Separator")

    --[=[
        @prop Indent Iris.Indent
        @within Format
        @tag Widget
        @tag HasChildren
        
        Indents its child widgets.
        
        ```lua
        hasChildren = true
        hasState = false
        Arguments = {
            Width: number? = Iris._config.IndentSpacing -- indent width ammount.
        }
        ```
    ]=]
    Iris.Indent = wrapper("Indent")

    --[=[
        @prop Sameline Iris.Sameline
        @within Format
        @tag Widget
        @tag HasChildren
        
        Positions its children in a row, horizontally.
        
        ```lua
        hasChildren = true
        hasState = false
        Arguments = {
            Width: number? = Iris._config.ItemSpacing.X, -- horizontal spacing between child widgets.
            VerticalAlignment: Enum.VerticalAlignment? = Enum.VerticalAlignment.Center -- how widgets are aligned to the widget.
        }
        ```
    ]=]
    Iris.SameLine = wrapper("SameLine")

    --[=[
        @prop Group Iris.Group
        @within Format
        @tag Widget
        @tag HasChildren
        
        Layout widget which contains its children as a single group.
        
        ```lua
        hasChildren = true
        hasState = false
        ```
    ]=]
    Iris.Group = wrapper("Group")

    --[[
        ---------------------------------
            [SECTION] Text Widget API
        ---------------------------------
    ]]
    --[=[
        @class Text
        Text Widget API
    ]=]

    --[=[
        @prop Text Iris.Text
        @within Text
        @tag Widget
        
        A text label to display the text argument.
        The Wrapped argument will make the text wrap around if it is cut off by its parent.
        The Color argument will change the color of the text, by default it is defined in the configuration file.

        ```lua
        hasChildren = false
        hasState = false
        Arguments = {
            Text: string,
            Wrapped: boolean? = false, -- whether the text will wrap around inside the parent container.
            Color: Color3? = Iris._config.TextColor -- the colour of the text.
        }
        Events = {
            hovered: () -> boolean
        }
        ```
    ]=]
    Iris.Text = wrapper("Text")

    --[=[
        @prop TextWrapped Iris.Text
        @within Text
        @tag Widget
        
        An alias for [Iris.Text](Text#Text) with the Wrapped argument set to true, and the text will wrap around if cut off by its parent.

        ```lua
        hasChildren = false
        hasState = false
        Arguments = {
            Text: string,
        }
        Events = {
            hovered: () -> boolean
        }
        ```
    ]=]
    Iris.TextWrapped = function(arguments: Types.WidgetArguments): Types.Widget
        arguments[2] = true
        return Iris.Internal._Insert("Text", arguments)
    end

    --[=[
        @prop TextColored Iris.Text
        @within Text
        @tag Widget
        
        An alias for [Iris.Text](Text#Text) with the color set by the Color argument.

        ```lua
        hasChildren = false
        hasState = false
        Arguments = {
            Text: string,
            Color: Color3 -- the colour of the text.
        }
        Events = {
            hovered: () -> boolean
        }
        ```
    ]=]
    Iris.TextColored = function(arguments: Types.WidgetArguments): Types.Widget
        arguments[3] = arguments[2]
        arguments[2] = nil
        return Iris.Internal._Insert("Text", arguments)
    end

    --[=[
        @prop SeparatorText Iris.SeparatorText
        @within Text
        @tag Widget
        
        Similar to [Iris.Separator](Format#Separator) but with a text label to be used as a header
        when an [Iris.Tree](Tree#Tree) or [Iris.CollapsingHeader](Tree#CollapsingHeader) is not appropriate.

        Visually a full width thin line with a text label clipping out part of the line.
        
        ```lua
        hasChildren = false
        hasState = false
        Arguments = {
            Text: string
        }
        ```
    ]=]
    Iris.SeparatorText = wrapper("SeparatorText")

    --[=[
        @prop InputText Iris.InputText
        @within Text
        @tag Widget
        @tag HasState

        A field which allows the user to enter text.        
        
        ```lua
        hasChildren = false
        hasState = true
        Arguments = {
            Text: string? = "InputText",
            TextHint: string? = "" -- a hint to display when the text box is empty.
        }
        Events = {
            textChanged: () -> boolean, -- whenever the textbox looses focus and a change was made.
            hovered: () -> boolean
        }
        States = {
            text: State<string>?
        }
        ```
    ]=]
    Iris.InputText = wrapper("InputText")

    --[[
        ----------------------------------
            [SECTION] Basic Widget API
        ----------------------------------
    ]]
    --[=[
        @class Basic
        Basic Widget API
    ]=]

    --[=[
        @prop Button Iris.Button
        @within Basic
        @tag Widget
        
        A clickable button the size of the text with padding. Can listen to the `clicked()` event to determine if it was pressed.

        ```lua
        hasChildren = false
        hasState = false
        Arguments = {
            Text: string,
        }
        Events = {
            clicked: () -> boolean,
            rightClicked: () -> boolean,
            doubleClicked: () -> boolean,
            ctrlClicked: () -> boolean, -- when the control key is down and clicked.
            hovered: () -> boolean
        }
        ```
    ]=]
    Iris.Button = wrapper("Button")

    --[=[
        @prop SmallButton Iris.SmallButton
        @within Basic
        @tag Widget
        
        A smaller clickable button, the same as a [Iris.Button](Basic#Button) but without padding. Can listen to the `clicked()` event to determine if it was pressed.

        ```lua
        hasChildren = false
        hasState = false
        Arguments = {
            Text: string,
        }
        Events = {
            clicked: () -> boolean,
            rightClicked: () -> boolean,
            doubleClicked: () -> boolean,
            ctrlClicked: () -> boolean, -- when the control key is down and clicked.
            hovered: () -> boolean
        }
        ```
    ]=]
    Iris.SmallButton = wrapper("SmallButton")

    --[=[
        @prop Checkbox Iris.Checkbox
        @within Basic
        @tag Widget
        @tag HasState
        
        A checkable box with a visual tick to represent a boolean true or false state.

        ```lua
        hasChildren = false
        hasState = true
        Arguments = {
            Text: string
        }
        Events = {
            checked: () -> boolean, -- once when checked.
            unchecked: () -> boolean, -- once when unchecked.
            hovered: () -> boolean
        }
        State = {
            isChecked = State<boolean>? -- whether the box is checked.
        }
        ```
    ]=]
    Iris.Checkbox = wrapper("Checkbox")

    --[=[
        @prop RadioButton Iris.RadioButton
        @within Basic
        @tag Widget
        @tag HasState
        
        A circular selectable button, changing the state to its index argument. Used in conjunction with multiple other RadioButtons sharing the same state to represent one value from multiple options.
        
        ```lua
        hasChildren = false
        hasState = true
        Arguments = {
            Text: string,
            Index: any -- the state object is set to when clicked.
        }
        Events = {
            selected: () -> boolean,
            unselected: () -> boolean,
            active: () -> boolean, -- if the state index equals the RadioButton's index.
            hovered: () -> boolean
        }
        State = {
            index = State<any>? -- the state set by the index of a RadioButton.
        }
        ```
    ]=]
    Iris.RadioButton = wrapper("RadioButton")

    --[[
        ---------------------------------
            [SECTION] Tree Widget API
        ---------------------------------
    ]]
    --[=[
        @class Tree
        Tree Widget API
    ]=]

    --[=[
        @prop Tree Iris.Tree
        @within Tree
        @tag Widget
        @tag HasChildren
        @tag HasState
        
        A collapsable container for other widgets, to organise and hide widgets when not needed. The state determines whether the child widgets are visible or not. Clicking on the widget will collapse or uncollapse it.
        
        ```lua
        hasChildren: true
        hasState: true
        Arguments = {
            Text: string,
            SpanAvailWidth: boolean? = false, -- the tree title will fill all horizontal space to the end its parent container.
            NoIndent: boolean? = false -- the child widgets will not be indented underneath.
        }
        Events = {
            collapsed: () -> boolean,
            uncollapsed: () -> boolean,
            hovered: () -> boolean
        }
        State = {
            isUncollapsed: State<boolean>? -- whether the widget is collapsed.
        }
        ```
    ]=]
    Iris.Tree = wrapper("Tree")

    --[=[
        @prop CollapsingHeader Iris.CollapsingHeader
        @within Tree
        @tag Widget
        @tag HasChildren
        @tag HasState
        
        The same as a Tree Widget, but with a larger title and clearer, used mainly for organsing widgets on the first level of a window.
        
        ```lua
        hasChildren: true
        hasState: true
        Arguments = {
            Text: string
        }
        Events = {
            collapsed: () -> boolean,
            uncollapsed: () -> boolean,
            hovered: () -> boolean
        }
        State = {
            isUncollapsed: State<boolean>? -- whether the widget is collapsed.
        }
        ```
    ]=]
    Iris.CollapsingHeader = wrapper("CollapsingHeader")

    --[[
        ----------------------------------
            [SECTION] Input Widget API
        ----------------------------------
    ]]
    --[=[
        @class Input
        Input Widget API

        Input Widgets are textboxes for typing in specific number values. See [Drag], [Slider] or [Other Input] for more input types.

        Iris provides a set of specific inputs for the datatypes:
        Number,
        [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2),
        [Vector3](https://create.roblox.com/docs/reference/engine/datatypes/Vector3),
        [UDim](https://create.roblox.com/docs/reference/engine/datatypes/UDim),
        [UDim2](https://create.roblox.com/docs/reference/engine/datatypes/UDim2),
        [Rect](https://create.roblox.com/docs/reference/engine/datatypes/Rect),
        [Color3](https://create.roblox.com/docs/reference/engine/datatypes/Color3)
        and the custom [Color4](https://create.roblox.com/docs/reference/engine/datatypes/Color3).
        
        Each Input widget has the same arguments:
        1. Text: string? = "Input{type}" -- the text to be displayed to the right of the textbox.
        2. Increment: number? = nil, -- the increment argument determines how a value will be rounded once the textbox looses focus.
        
    ]=]

    --[=[
        @prop InputNum Iris.InputNum
        @within Input
        @tag Widget
        @tag HasState
        
        An input box for numbers. The numbers can be either integers or floats and is determined by the Increment,
        and Min, Max arguments.
        
        ```lua
        hasChildren = false
        hasState = true
        Arguments = {
            Text: string? = "InputNum",
            Increment: number? = nil,
            Min: number? = nil,
            Max: number? = nil,
            Format: string? | { string }? = "%d" or "%.{}f", -- Iris will dynamically generate an approriate format.
            NoButtons: boolean? = false -- whether to display + and - buttons next to the input box.
        }
        Events = {
        }
        States = {
        }
        ```
    ]=]
    Iris.InputNum = wrapper("InputNum")
    Iris.InputVector2 = wrapper("InputVector2")
    Iris.InputVector3 = wrapper("InputVector3")
    Iris.InputUDim = wrapper("InputUDim")
    Iris.InputUDim2 = wrapper("InputUDim2")
    Iris.InputRect = wrapper("InputRect")
    Iris.InputColor3 = wrapper("InputColor3")
    Iris.InputColor4 = wrapper("InputColor4")

    --[[
        ---------------------------------
            [SECTION] Drag Widget API
        ---------------------------------
    ]]
    --[=[
        @class Drag
        Drag Widget API
    ]=]

    --[=[
        @prop DragNum Iris.DragNum
        @within Drag
        @tag Widget
        @tag HasState
        
        
        ```lua
        hasChildren = false
        hasState = true
        Arguments = {
        }
        Events = {
        }
        States = {
        }
        ```
    ]=]
    Iris.DragNum = wrapper("DragNum")
    Iris.DragVector2 = wrapper("DragVector2")
    Iris.DragVector3 = wrapper("DragVector3")
    Iris.DragUDim = wrapper("DragUDim")
    Iris.DragUDim2 = wrapper("DragUDim2")
    Iris.DragRect = wrapper("DragRect")

    --[[
        -----------------------------------
            [SECTION] Slider Widget API
        -----------------------------------
    ]]
    --[=[
        @class Slider
        Slider Widget API
    ]=]

    --[=[
        @prop SliderNum Iris.SliderNum
        @within Slider
        @tag Widget
        @tag HasState
        
        
        ```lua
        hasChildren = false
        hasState = true
        Arguments = {
        }
        Events = {
        }
        States = {
        }
        ```
    ]=]
    Iris.SliderNum = wrapper("SliderNum")
    Iris.SliderVector2 = wrapper("SliderVector2")
    Iris.SliderVector3 = wrapper("SliderVector3")
    Iris.SliderUDim = wrapper("SliderUDim")
    Iris.SliderUDim2 = wrapper("SliderUDim2")
    Iris.SliderRect = wrapper("SliderRect")
    Iris.SliderEnum = wrapper("SliderEnum")

    --[[
        ----------------------------------
            [SECTION] Combo Widget API
        ----------------------------------
    ]]
    --[=[
        @class Combo
        Combo Widget API
    ]=]

    --[=[
        @prop Selectable Iris.Selectable
        @within Combo
        @tag Widget
        @tag HasState
        
        An object which can be selected.
        
        ```lua
        hasChildren = false
        hasState = true
        Arguments = {
            Text: string,
            Index: any, -- index of selectable value.
            NoClick: boolean? = false -- prevents the selectable from being clicked by the user.
        }
        Events = {
            selected: () -> boolean,
            unselected: () -> boolean,
            active: () -> boolean,
            clicked: () -> boolean,
            rightClicked: () -> boolean,
            doubleClicked: () -> boolean,
            ctrlClicked: () -> boolean,
            hovered: () -> boolean,
        }
        States = {
            index: State<any> -- a shared state between all selectables.
        }
        ```
    ]=]
    Iris.Selectable = wrapper("Selectable")

    --[=[
        @prop Combo Iris.Combo
        @within Combo
        @tag Widget
        @tag HasChildren
        @tag HasState
        
        A selection box to choose a value from a range of values.
        
        ```lua
        hasChildren = true
        hasState = true
        Arguments = {
            Text: string,
            NoButton: boolean? = false, -- hide the dropdown button.
            NoPreview: boolean? = false -- hide the preview field.
        }
        Events = {
            opened: () -> boolean,
            clsoed: () -> boolean,
            clicked: () -> boolean,
            hovered: () -> boolean
        }
        States = {
            index: State<any>,
            isOpened: State<boolean>?
        }
        ```
    ]=]
    Iris.Combo = wrapper("Combo")

    --[=[
        @prop ComboArray Iris.Combo
        @within Combo
        @tag Widget
        @tag HasChildren
        @tag HasState
        
        A selection box to choose a value from an array.
        
        ```lua
        hasChildren = true
        hasState = true
        Arguments = {
            Text: string,
            NoButton: boolean? = false, -- hide the dropdown button.
            NoPreview: boolean? = false -- hide the preview field.
        }
        Events = {
            opened: () -> boolean,
            clsoed: () -> boolean,
            clicked: () -> boolean,
            hovered: () -> boolean
        }
        States = {
            index: State<any>,
            isOpened: State<boolean>?
        }
        Extra = {
            selectionArray: { any } -- the array to generate a combo from.
        }
        ```
    ]=]
    Iris.ComboArray = function(arguments: Types.WidgetArguments, states: Types.WidgetStates?, selectionArray: { any })
        local defaultState
        if states == nil then
            defaultState = Iris.State(selectionArray[1])
        else
            defaultState = states
        end
        local thisWidget = Iris.Internal._Insert("Combo", arguments, defaultState)
        local sharedIndex: Types.State = thisWidget.state.index
        for _, Selection in selectionArray do
            Iris.Internal._Insert("Selectable", { Selection, Selection }, { index = sharedIndex } :: Types.States)
        end
        Iris.End()

        return thisWidget
    end

    --[=[
        @prop ComboEnum Iris.Combo
        @within Combo
        @tag Widget
        @tag HasChildren
        @tag HasState
        
        A selection box to choose a value from an Enum.
        
        ```lua
        hasChildren = true
        hasState = true
        Arguments = {
            Text: string,
            NoButton: boolean? = false, -- hide the dropdown button.
            NoPreview: boolean? = false -- hide the preview field.
        }
        Events = {
            opened: () -> boolean,
            clsoed: () -> boolean,
            clicked: () -> boolean,
            hovered: () -> boolean
        }
        States = {
            index: State<any>,
            isOpened: State<boolean>?
        }
        Extra = {
            enumType: Enum -- the enum to generate a combo from.
        }
        ```
    ]=]
    Iris.ComboEnum = function(arguments: Types.WidgetArguments, states: Types.WidgetStates?, enumType: Enum)
        local defaultState
        if states == nil then
            defaultState = Iris.State(enumType[1])
        else
            defaultState = states
        end
        local thisWidget = Iris.Internal._Insert("Combo", arguments, defaultState)
        local sharedIndex = thisWidget.state.index
        for _, Selection in enumType:GetEnumItems() do
            Iris.Internal._Insert("Selectable", { Selection.Name, Selection }, { index = sharedIndex } :: Types.States)
        end
        Iris.End()

        return thisWidget
    end
    Iris.InputEnum = Iris.ComboEnum

    --[[
        ----------------------------------
            [SECTION] Table Widget API
        ----------------------------------
    ]]
    --[=[
        @class Table
        Table Widget API
    ]=]

    --[=[
        @prop Table Iris.Table
        @within Table
        @tag Widget
        @tag HasChildren
        
        
        ```lua
        hasChildren = true
        hasState = false
        Arguments = {
        }
        Events = {
        }
        States = {
        }
        ```
    ]=]
    Iris.Table = wrapper("Table")

    --[=[
        @function NextColumn
        @within Table
    ]=]
    Iris.NextColumn = function()
        Iris.Internal._GetParentWidget().RowColumnIndex += 1
    end

    --[=[
        @function SetColumnIndex
        @within Table 
        
        ```lua
        hasChildren = false
        hasState = false
        Arguments = {
            Title: string,
        }
        Events = {
        }
        States = {
        }
        ```
    ]=]
    Iris.SetColumnIndex = function(columnIndex: number)
        local ParentWidget: Types.Widget = Iris.Internal._GetParentWidget()
        assert(columnIndex >= ParentWidget.InitialNumColumns, "Iris.SetColumnIndex Argument must be in column range")
        ParentWidget.RowColumnIndex = math.floor(ParentWidget.RowColumnIndex / ParentWidget.InitialNumColumns) + (columnIndex - 1)
    end

    --[=[
        @function NextRow
        @within Table
        
        ```lua
        hasChildren = false
        hasState = false
        Arguments = {
            Title: string,
        }
        Events = {
        }
        States = {
        }
        ```
    ]=]
    Iris.NextRow = function()
        -- sets column Index back to 0, increments Row
        local ParentWidget = Iris.Internal._GetParentWidget()
        local InitialNumColumns = ParentWidget.InitialNumColumns
        local nextRow = math.floor((ParentWidget.RowColumnIndex + 1) / InitialNumColumns) * InitialNumColumns
        ParentWidget.RowColumnIndex = nextRow
    end
end