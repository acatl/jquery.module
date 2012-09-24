jquery.tile plugin
==================

jQuery plugin that helps encapsulate javascript snippets to a specific element - keeps code organized.




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
Attatch the snippet to your document element:

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

