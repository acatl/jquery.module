###
    jquery.module.js

    Copyright 2013, Acatl Pacheco
    Licensed under the MIT License.
###

(($, window) ->
    pluginName = "module"    
    traceClasses = false
    getNS = (namespaceStr) ->
        splitNS = namespaceStr.split(".")
        currNSObj = window
        splitNSLength = undefined
        i = 0
        splitNSLength = splitNS.length
        console.log "module: #{namespaceStr}" if traceClasses and window.console
        while i < splitNSLength and currNSObj isnt null
            currNSObj = (currNSObj[splitNS[i]] = currNSObj[splitNS[i]] or null)
            i++
        currNSObj

    attatchModules = (element, modules, options) ->
        return unless modules

        modules = modules.replace(/\s/g, "").split(",") if typeof modules is "string" 
        modules = [modules] unless jQuery.isArray modules

        until modules.length is 0
            nsClass = modules.shift()
            module = if typeof nsClass is "string" then getNS(nsClass) else nsClass
            try
                api = element.data("#{nsClass}.api") or {}

                if typeof(module) is "function"
                    fnText = module.toString();
                    argDecl = fnText.match(/^function\s*[^\(]*\(\s*([^\)]*)\)/m)[1].replace(/\s+/g,'').split(',')
                    args = [api, element, options]
                    # for now only basic support
                    args.shift() if argDecl[0] isnt "api"
                    module.apply(module, args) 
                else 
                    newModule = 
                        element:{}
                        options:{}

                    $.extend newModule, module
                    
                    newModule.api = api
                    newModule.element = element
                    $.extend(newModule.options, options or {})

                    newModule.init() if newModule.init

                element.data "#{nsClass}.api", api

            catch e
                 console.info "module error on: [" + nsClass + "]", e.message if window.console
        element
                
    Plugin = (element, options) ->
        @element = $(element)
        
        @options = options
        @_name = pluginName
        @init()
        @

    Plugin::init = -> 
        @add @element.data("module"), @options
        
    Plugin::add = (module, options) -> 
        attatchModules @element, module, options
        
    $.fn[pluginName] = (method, trace) ->
        callArgs = arguments
        traceClasses = trace
        @each ->
            pluginInstance = $.data(this, "plugin_" + pluginName)

            if pluginInstance 
                pluginMethod = pluginInstance[method] or pluginInstance.init
                pluginMethod.apply( pluginInstance, Array.prototype.slice.call( callArgs, 1 ))
            else
                $.data this, "plugin_" + pluginName, new Plugin(this, method)

) jQuery, window