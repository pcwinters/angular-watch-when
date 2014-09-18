angular-watch-when
=============
'Watch when' feature for AngularJS expressions that builds upon the ng 1.3 bind once expression syntax.
Bind once is great, but sometimes you need your bindings to be a little smarter and get fired **occasionally**. This purposefully builds on [angular-watch-require](https://github.com/pcw216/angular-watch-require) to recycle and reuse existing watches, but could be used in isolation if desired.

For example, you might not expect an id property on some selected entity to change; but what if the selected entity changes? You might like your bindings, links, etc. to reflect the changed reference, re-fire, and go away again. If used properly, this can significantly reduce the number of active watchers (like regular bind-once), while keeping the app reactive to the data you expect to change.

[JSFiddle](http://jsfiddle.net/95e2xnqf/)

### Usage

```bower install angular-watch-when```

Add ```'ngWatchWhen'``` to your application or module dependencies.

##### Expression syntax
The expression syntax is baked into $parse and can be used in $scope.$watch[*], templates, and directives. It's similar to the 'one-time' expressions described in the AngularJS 1.3 guide on expressions, [One-time Binding](https://code.angularjs.org/1.3.0-rc.1/docs/guide/expression).

```::myModel::myModel.id``` will return a one-time expression on ```::myModel.id``` that re-registers whenever the value of the expression ```myModel``` changes.

```
var unwatch = $scope.$watch('::myModel::myModel.id', function(){
	// called until 'myModel.id' is defined, for every new value of 'myModel'
});

unwatch(); 
// Will unregister everything, this watch listener will never be called again
```

### Performance Gains
The simplistic, above example wouldn't result in a performance gains via a reduction in watches. In fact, it could only result in more or the same, considering the ```myModel``` watch lives forever. This module is designed to be used with [angular-watch-require](https://github.com/pcw216/angular-watch-require) with an expression like the following ```::?^myModel::myModel.id```. This will attempt to re-use a ```myModel``` watcher, which will likely be used by many 'one-time' bindings. Make sure to import the module ```'ngWatchRequire'``` before ```'ngWatchWhen'```

### See also
[angular-watch-require](https://github.com/pcw216/angular-watch-require) - Reuse watches by extending expression syntax to require and recycle existing watches.

