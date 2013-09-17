###
    jquery.module.js

    Copyright 2013, Acatl Pacheco
    Licensed under the MIT License.
###

do($=jQuery, window=window) ->

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

    attatchModules = (element, modules, api) ->
        return unless modules

        modules = modules.replace(/\s/g, "").split(",") if typeof modules is "string" 
        modules = [modules] unless jQuery.isArray modules

        modulesAttached = (element.data 'modules-attached')
        modulesAttached = if modulesAttached then modulesAttached.split(',') else []
        allowMultiple = api.multiple is true

        until modules.length is 0
            nsClass = modules.shift()
            moduleUnified = nsClass.replace(/\./g, "")
            module = if typeof nsClass is "string" then getNS(nsClass)

            if !Array.prototype.indexOf 
                alreadyAttached = jQuery.inArray(moduleUnified, modulesAttached) isnt -1
            else 
                alreadyAttached = modulesAttached.indexOf(moduleUnified) isnt -1
            
            if alreadyAttached and not allowMultiple
                # fail silently for now
                continue 
            try
                api = element.data("#{nsClass}.api") or api or {}

                if typeof(module) is "function"
                    fnText = module.toString();
                    argDecl = fnText.match(/^function\s*[^\(]*\(\s*([^\)]*)\)/m)[1].replace(/\s+/g,'').split(',')
                    args = [api, element]
                    # for now only basic support
                    args.shift() if argDecl[0] isnt "api"
                    module.apply(module, args) 
                else 
                    newModule = 
                        element:{}

                    $.extend newModule, module
                    
                    newModule.api = api
                    newModule.element = element

                    newModule.init() if newModule.init

                element.data "#{nsClass}.api", api
                modulesAttached.push moduleUnified unless alreadyAttached 

            catch e
                 console.info "module error on: [" + nsClass + "]", e.message if window.console

        element.data 'modules-attached', modulesAttached.join ','
        element
                
    Plugin = (element, api) ->
        @element = $(element)
        
        @api = api
        @_name = pluginName
        @init(api)
        @

    Plugin::init = (api={})-> 
        @add @element.data("module"), api
        
    Plugin::add = (module, api) -> 
        attatchModules @element, module, api
        
    $.fn[pluginName] = (method, trace) ->
        callArgs = arguments
        traceClasses = trace
        @each ->
            pluginInstance = $.data(this, "plugin_" + pluginName)

            if pluginInstance 
                pluginInstance.init.apply(pluginInstance, callArgs)
            else
                $.data this, "plugin_" + pluginName, new Plugin(this, method)
