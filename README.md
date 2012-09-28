jquery.tile plugin
==================

jQuery plugin that helps encapsulate javascript snippets to a specific element - keeps code organized.

Each snippet acts as a [decorator](http://addyosmani.com/blog/decorator-pattern/), with the following signature: 

```js
function (element, options) { /*implement*/ };
```

`element` is a reference to the DOM element to which the snippet is being attached to.

`options` object which may be passed when attaching the plugin to your jquery element (see **Passing options**).

Each execution of a class is wrapped on a `try..catch` statement so, if an error 
occurs, the plugin will continue to the next class or element found.


## Situation: 

You have a site that has a bunch JS blocks of code that do not relate to each 
other and are only implemented to specific elements in the DOM.

## Problem: 
You end up with a huge JS file with a bunch of unrelated code. and maybe more
than one  point of entry.

## Solution:

### Step 1.
You write your snippet:

```js
window.MySnippet = function (element) {
    element.text("hello world!")
}
```

### Step 2.
Attatch the snippet to your document element by asigning the name of your 
snippet to the element's custom `data-tile-class` attriute:

```html
<div class="tile-me" data-tile-class="MySnippet">I'm being snippnetized</div>
```

### Step 3. 
run the plugin:

```js
$(function() {
    $(".tile-me").tile();
});
```

### Namespaced tiles
To keep things even more organized you may want to namespace your snippets:

```html
<form class="client-form" data-tile-class="domain.app.ClientForm"></form>
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
    $(".tile-me").tile({name: "Darek"});
});
```

### Passing more than one class
You may attatch more than one class to your jquery element, attatchment will 
occur in the order from left to right: 

*note: each class should be separated by a `,`.

```html
<form class="client-form" data-tile-class="domain.app.ClientForm, domain.app.ValidateForm"></form>
```