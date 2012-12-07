# jquery.module plugin
*"Separate DOM structure from application logic"*

```html
<form data-module-class="domain.app.FormValidation">
    ...
</form>

<script>
    domain.app.FormValidation = function (element, options) {
        // add logic.
    }

    $(function() {
        $("[data-module-class]").module();
    });
</script>
```

## Is this you?

+ Code is attached to element ids or classes which make your code depend on the DOM structure.
+ Unrelated pices of code only affecting certain parts of your DOM. 
+ Many JS blocks of code that do not relate to each other.
+ Too many uncecesary points of entry.

## How to use:

Attatch javascript snippets directly to your jquery elements.

Each snippet acts as a [decorator](http://addyosmani.com/blog/decorator-pattern/), with the following signature: 

```js
function (element, options) { /*implement*/ };
```

`element` is a reference to the DOM element to which the snippet is being attached to.

`options` object which may be passed when attaching the plugin to your jquery element (see **Passing options**).

Each execution of a class is wrapped on a `try..catch` statement so, if an error 
occurs, the plugin will continue to the next class or element found.

## EXAMPLE:

[jsFiddle demo](http://jsfiddle.net/acatl/YhJ74/)

### Step 1.
You may write your snippet as a function:

```js
// @param element reference to DOM object to which module is attached
// @param options Object passed to the plugin with custom options
window.MySnippet = function (element, options) {
    element.text("hello world!")
}
```
Or you may also write it as an Object. 

```js
window.MyObject = {
    // default options
    options: {
        text: "hello world!"
    },
    // module plugin will look for a init() method
    // to initialize your module.
    init: function () {
        // this.element is a reference to DOM object
        this.element.text(this.options.text);
    }
}
```

Note: When an object you can access the `element` through `this.element`.


### Step 2.
Attatch the snippet to your document element by asigning the name of your 
snippet to the element's custom `data-module-class` attribute:

```html
<div class="module-me" data-module-class="MySnippet">
    I'm being snippnetized
</div>
```

### Step 3. 
run the plugin:

```js
$(function() {
    $(".module-me").module();
});
```

### Namespaced modules
To keep things even more organized you may want to namespace your snippets:

```html
<form class="client-form" data-module-class="domain.app.ClientForm">
</form>
```

```js
window.domain = {
    app: {
        ClientForm: function (element) {
            element.on("submit", function () { /* do something */ } );
        }
    }
}
```

### Passing options

```js
window.MySnippet = function (element, options) {
    element.text("hello " + options.name + "!")
}

$(function() {
    $(".module-me").module({name: "Darek"});
});
```

### Passing more than one class

You may attatch more than one class to your jquery element, attatchment will 
occur in the order from left to right: 

*note: each class should be separated by a `,`.

```html
<form class="client-form" 
      data-module-class="domain.app.ClientForm, domain.app.ValidateForm">
</form>
```

### Adding modules at runtime

To add a module to a jquery element at runtime you can do it by using the method 
`add`:

```js
// initialize plugin
$(".client-form").module();

// Option 1
$(".client-form").module("add", domain.app.ConfirmSubmit);

// Option 2 (module can be a string, let the plugin
// look for the namespace)
$(".client-form").module("add", "domain.app.ConfirmSubmit");

// Option 3 You may add multiple modules passing an array
$(".client-form").module("add", ["domain.app.ConfirmSubmit", domain.app.ValidateForm]);

```

To pass **options** to your module: 

```js
$(".client-form").module("add", domain.app.ConfirmSubmit, {title:"Please Confirm"});
```

### Tracing to console classes being attached

Note: 
* only use it for debuging
* only works for string declared classes

Passing a second parameter with `true` to the plugin will output to the console 
the classes beign attached.

```html
<form class="client-form" 
      data-module-class="domain.app.ClientForm, domain.app.ValidateForm">
</form>
```

```js
$(function() {
    $(".client-form").module({}, true);
});
```

output: 

```
module: domain.app.ClientForm
module: domain.app.ValidateForm
```



