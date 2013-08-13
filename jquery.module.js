/*
    jquery.module.js

    Copyright 2013, Acatl Pacheco
    Licensed under the MIT License.
*/


(function() {
  (function($, window) {
    var Plugin, attatchModules, getNS, pluginName, traceClasses;

    pluginName = "module";
    traceClasses = false;
    getNS = function(namespaceStr) {
      var currNSObj, i, splitNS, splitNSLength;

      splitNS = namespaceStr.split(".");
      currNSObj = window;
      splitNSLength = void 0;
      i = 0;
      splitNSLength = splitNS.length;
      if (traceClasses && window.console) {
        console.log("module: " + namespaceStr);
      }
      while (i < splitNSLength && currNSObj !== null) {
        currNSObj = (currNSObj[splitNS[i]] = currNSObj[splitNS[i]] || null);
        i++;
      }
      return currNSObj;
    };
    attatchModules = function(element, modules, api) {
      var argDecl, args, e, fnText, module, moduleUnified, modulesAttached, newModule, nsClass;

      if (!modules) {
        return;
      }
      if (typeof modules === "string") {
        modules = modules.replace(/\s/g, "").split(",");
      }
      if (!jQuery.isArray(modules)) {
        modules = [modules];
      }
      modulesAttached = element.data('modules-attached');
      modulesAttached = modulesAttached ? modulesAttached.split(',') : [];
      while (modules.length !== 0) {
        nsClass = modules.shift();
        moduleUnified = nsClass.replace(/\./g, "");
        module = typeof nsClass === "string" ? getNS(nsClass) : void 0;
        if (modulesAttached.indexOf(moduleUnified) !== -1) {
          if (!api.multiple) {
            throw "module '" + nsClass + "' already instantianted";
          }
          continue;
        }
        try {
          api = element.data("" + nsClass + ".api") || api || {};
          if (typeof module === "function") {
            fnText = module.toString();
            argDecl = fnText.match(/^function\s*[^\(]*\(\s*([^\)]*)\)/m)[1].replace(/\s+/g, '').split(',');
            args = [api, element];
            if (argDecl[0] !== "api") {
              args.shift();
            }
            module.apply(module, args);
          } else {
            newModule = {
              element: {}
            };
            $.extend(newModule, module);
            newModule.api = api;
            newModule.element = element;
            if (newModule.init) {
              newModule.init();
            }
          }
          element.data("" + nsClass + ".api", api);
          modulesAttached.push(moduleUnified);
        } catch (_error) {
          e = _error;
          if (window.console) {
            console.info("module error on: [" + nsClass + "]", e.message);
          }
        }
      }
      element.data('modules-attached', modulesAttached.join(','));
      return element;
    };
    Plugin = function(element, api) {
      this.element = $(element);
      this.api = api;
      this._name = pluginName;
      this.init(api);
      return this;
    };
    Plugin.prototype.init = function(api) {
      if (api == null) {
        api = {};
      }
      return this.add(this.element.data("module"), api);
    };
    Plugin.prototype.add = function(module, api) {
      return attatchModules(this.element, module, api);
    };
    return $.fn[pluginName] = function(method, trace) {
      var callArgs;

      callArgs = arguments;
      traceClasses = trace;
      return this.each(function() {
        var pluginInstance;

        pluginInstance = $.data(this, "plugin_" + pluginName);
        if (pluginInstance) {
          return pluginInstance.init.apply(pluginInstance, callArgs);
        } else {
          return $.data(this, "plugin_" + pluginName, new Plugin(this, method));
        }
      });
    };
  })(jQuery, window);

}).call(this);
