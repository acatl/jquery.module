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
    attatchModules = function(element, modules, options) {
      var api, argDecl, args, e, fnText, module, newModule, nsClass;

      if (!modules) {
        return;
      }
      if (typeof modules === "string") {
        modules = modules.replace(/\s/g, "").split(",");
      }
      if (!jQuery.isArray(modules)) {
        modules = [modules];
      }
      while (modules.length !== 0) {
        nsClass = modules.shift();
        module = typeof nsClass === "string" ? getNS(nsClass) : nsClass;
        try {
          api = element.data("" + nsClass + ".api") || {};
          if (typeof module === "function") {
            fnText = module.toString();
            argDecl = fnText.match(/^function\s*[^\(]*\(\s*([^\)]*)\)/m)[1].replace(/\s+/g, '').split(',');
            args = [api, element, options];
            if (argDecl[0] !== "api") {
              args.shift();
            }
            module.apply(module, args);
          } else {
            newModule = {
              element: {},
              options: {}
            };
            $.extend(newModule, module);
            newModule.api = api;
            newModule.element = element;
            $.extend(newModule.options, options || {});
            if (newModule.init) {
              newModule.init();
            }
          }
          element.data("" + nsClass + ".api", api);
        } catch (_error) {
          e = _error;
          if (window.console) {
            console.info("module error on: [" + nsClass + "]", e.message);
          }
        }
      }
      return element;
    };
    Plugin = function(element, options) {
      this.element = $(element);
      this.options = options;
      this._name = pluginName;
      this.init();
      return this;
    };
    Plugin.prototype.init = function() {
      return this.add(this.element.data("module"), this.options);
    };
    Plugin.prototype.add = function(module, options) {
      return attatchModules(this.element, module, options);
    };
    return $.fn[pluginName] = function(method, trace) {
      var callArgs;

      callArgs = arguments;
      traceClasses = trace;
      return this.each(function() {
        var pluginInstance, pluginMethod;

        pluginInstance = $.data(this, "plugin_" + pluginName);
        if (pluginInstance) {
          pluginMethod = pluginInstance[method] || pluginInstance.init;
          return pluginMethod.apply(pluginInstance, Array.prototype.slice.call(callArgs, 1));
        } else {
          return $.data(this, "plugin_" + pluginName, new Plugin(this, method));
        }
      });
    };
  })(jQuery, window);

}).call(this);
