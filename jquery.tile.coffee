###
    jquery.tile.js

    Copyright 2012, Acatl Pacheco
    Licensed under the MIT License.
###

(($, window) ->    
    pluginName = "tile"
    
    defaults = {}

    getNS = (namespaceStr) ->
        splitNS = namespaceStr.split(".")
        currNSObj = window
        splitNSLength = undefined
        i = undefined
        i = 0
        splitNSLength = splitNS.length

        while i < splitNSLength and currNSObj isnt null
            currNSObj = (currNSObj[splitNS[i]] = currNSObj[splitNS[i]] or null)
            i++
        currNSObj

    Plugin = (element, options) ->
        @element = $(element)
        
        @options = $.extend({}, defaults, options)
        @_defaults = defaults
        @_name = pluginName
        @init()
        @

    Plugin::init = -> 
        $el = @element
        tileClass = $el.data("tile-class")
        if tileClass
            nsObject = getNS(tileClass)
            try
                nsObject $el
            catch e
                console.log "Tile error on: [" + tileClass + "]", e


    Plugin::aMethod = (d)->
        console.log "aMethod", d, this, @element
        @element.text(@element.text() + @element.data("tile-something"));

    # A really lightweight plugin wrapper around the constructor, 
    # preventing against multiple instantiations
    $.fn[pluginName] = (options) ->
        callArgs = arguments
        @each ->
            pluginInstance = $.data(this, "plugin_" + pluginName)
            if pluginInstance
                if pluginInstance[options]
                    pluginInstance[options].apply( pluginInstance, Array.prototype.slice.call( callArgs, 1 ))
            else
                $.data this, "plugin_" + pluginName, new Plugin(this, options)

) jQuery, window




$(".tile").tile()

$(".tile").tile("aMethod", 2)
