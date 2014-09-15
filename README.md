angular-watch-when
=============
'Watch when' feature for AngularJS expressions that builds upon the ng 1.3 bind once expression syntax.
Bind once is great, but sometimes you need your bindings to be a little smarter and get fired *occasionally*.

For example, you might not expect an id property on some selected entity to change; but what if the selected entity changes? You might like your bindings, links, etc. to reflect the changed reference, re-fire, and go away again. If used properly, this can significantly reduce the number of active watchers (like regular bind-once), while keeping the app reactive to the data you expect to change.

__TODO__
This is a big todo. In order to actually make this a reduction in $watches, the 'when' listener needs to be overloaded and used by
all 'once' expressions. Possible solutions are to look on your immediate scope for other listeners, or to walk up the $parent heirarchy. It could be the responsibility of a particular controller/scope to register itself as the highest scope responsible for a model. This could be done programmatically with a service, or via a directive similar to the [bindonce](https://github.com/Pasvaz/bindonce) directive.

### Usage

```bower install angular-watch-when```

Add ```'ngWatchWhen'``` to your application or module.

##### Expression syntax
The expression syntax is baked into $parse and can be used in $scope.$watch[*], templates, and directives.
```
$scope.$watch('::myModel::myModel.id', function(){
	// called until 'myModel.id' is defined, for every new value of 'myModel'
})
```
