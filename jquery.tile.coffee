###
    jquery.tile.js

    Copyright 2012, Acatl Pacheco
    Licensed under the MIT License.
###

(($, window) ->    
    pluginName = "tile"    
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
        
        @options = options
        @_name = pluginName
        @init()
        @

    Plugin::init = -> 
        $el = @element
        tileClass = $el.data("tile-class")
        if tileClass
            nsObject = getNS(tileClass)
            try
                nsObject $el, @options
            catch e
                console.log "Tile error on: [" + tileClass + "]", e

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