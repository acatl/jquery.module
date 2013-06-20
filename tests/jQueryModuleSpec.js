'use strict';

describe("jquery.Module", function() {
    var element;
    


    beforeEach(function() {
        element = $("<div data-module=\"domain.MyModule\"></div>");
        window.domain = window.domain || {};
        window.domain.MyModule = function(api, element, options) {
            api.someValue = 1; 
            api.doSomething = function () {
                return 2;
            };
            api.addClassTest = function () {
                element.addClass("some-class");
            };
            api.removeClassTest = function () {
                element.removeClass("some-class");
            };
            api.addClassTest();
        };
    });

    it("should be accesible globally", function () {
        expect($.fn.module).not.toBeUndefined();
    });

    describe("implement", function () {
        it("should get plugin attached", function() {
            element.module();
            expect(element.data("plugin_module")).not.toBeUndefined();
        });

        it("should get class attached", function() {
            element.module();
            expect(element.data("domain.MyModule.api")).not.toBeUndefined();
        });

        it("should pass in api", function() {
            element.module();
            expect(element.data("domain.MyModule.api").someValue).toBe(1);
            expect(typeof element.data("domain.MyModule.api").doSomething).toBe("function");
        });

        it("should execute correctly the scope of api methods when ran", function() {
            element.module();
            expect(element.hasClass("some-class")).toBe(true);
            element.data("domain.MyModule.api").removeClassTest();
            expect(element.hasClass("some-class")).toBe(false);
        });
        it("should accepct legacy arguments", function() {
            window.domain.MyModule = function(element, options) {
                element.addClass("some-class");
            };
            element.module();
            expect(element.hasClass("some-class")).toBe(true);
        });
    });
});





