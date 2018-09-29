## VanillaJS and jQuery - Minimal HTML Directives

JavaScript (coupled with the DOM) is so flexible and powerful that you can do many things using just Vanilla JS or jQuery.

(As a side note, I am talking about jQuery and vanilla interchangeably here because what I really mean is "without big-ass framework/libs", and whatever jQuery you use for syntatic compactness could rather easily be rewritten using just vanilla, if necessary.)

It is worth digressing over this because frameworks come and go and Vanilla will be here forever. (jQuery also seems like it will be here forever. I'm only half joking.) It is important to learn the fundamentals well; it is often overlooked how simple and elegant (and maintainable) they can be.

### Example: Self-validating Inputs

In my app I have forms and I want to validate some of their fields. But I want this validation to be declarative and immediate (e.g. not only upon submission) - whenever there is an error in the input, I want the input itself to take care of it. 

One could think of many ways to access this problem using heavy guns - most popularly today people would use React or some other functional library making the view a function of the state, and then syncing the input's value with some model and syncing additional view parts (e.g. an error message, other indication of error, default value, etc) to the model as well. 

This often results in a lot of code and despite the aesthetical benefit of a 'pure' view, I'd argue that just a couple lines of JS can give the equivalent of a 'directive' - but much leaner than, say, Angular. 

Let's choose for example to force-populate a default value in each such self-correcting input. The following code could suffice for that: 

~~~ html
<input data-default-val='my default val'>

<script>
function resetOnEmpty(event) {  
  var elem = event.target;
  if (!elem.value) { 
    elem.value = elem.dataset['defaultVal'];
  }
}

$('[data-default-val]').on('blur', resetOnEmpty)
</script>
~~~ 

It's very minimal, readable, maintainable. Anyone who knows JS should be fine working with it. The minimal jQuery could be rewritten in Vanilla, if so desired. Suppose we wanted to add additional validation logic rather than just an empty value (say, check that the value is long enough), or additional behaviour (e.g. alert the user the field can't be empty). It's clear how to add or read this piece of code. 

Most importantly, it is self-contained, and you do not need to understand anything else. 

Let's modify/repeat this exercise: This time we'll create inputs that show a red border when cleared. In additional to Vanilla JS (and yes, jQuery for succinctness) we'll throw in some vanilla CSS. 

~~~ html
<input class='warnOnEmpty'>

<style>
  .error-border { 
    border:1px solid red;
  }
</style>

<script>

function warnOnEmptyInput(selectorStr) {
  var elems = $(selectorStr);
  elems.focus(function(){ $(this).removeClass('error-border') });
  elems.blur(function(){ 
    if (!this.value.length) { 
      $(this).addClass('error-border') 
    }
  });
}

warnOnEmptyInput('.warnOnEmpty')
</script>
~~~

That's it, we now have a small directive of an input that adds a friendly error border when cleared. Again it is easy to see where and how to add or modify the error indicator - we could even add a message right after the input, if we wanted to. 

You'll note in both examples we used 'blur' to trigger the error-handling only after the user has left the input, since that's the UX I think is best. Alternatively we could trigger it when the empty value first appears, during the editing (i.e. 'onkeyup' rather than 'onblur'). These kind of nuances would be hard to discern using a framework - you'd have to dig to get to it (if possible). But using Vanilla you're at the base level and making such modifications is trivial. 

You can see both examples at this jsFiddle: <a href='https://jsfiddle.net/4o6npv3s/'>https://jsfiddle.net/4o6npv3s/</a>.

### Partials 

Using the above technique, you effectively now have HTML 'partials' that behave as independent components (directives). The above is a relatively trivial example, but now any time you render  `<input data-default-val='foo'>`  you get a component that maintains its own state with its own data. You can extend this technique, of course, to more complicated constructs - but most importantly, you can use it for standard stuff, and keep your code tiny, shiny, mean, and lean. 

### Summary

JavaScript is powerful. VanillaJS and jQuery go a long way. Coupled with the DOM, you can define powerful, lean, independent directives - without needing frameworks.