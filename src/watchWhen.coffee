wrap = (listener, toDo, invokeAlways, isDefined) ->
	return _.wrap toDo, (originalFn, value, args...)->
		valueIsDefined = isDefined(value)
		# allow for the watch callback to defer until the value is defined
		if not invokeAlways and not valueIsDefined then return
		originalFn.call(this, value, args...)
		if valueIsDefined then listener.cleanup() # clear the watch

angular.module('ngWatchWhen', [])
.constant 'ngWatchWhenRegEx', /^\:\:([^\:]+)(\:\:[^\:]+)$/
.value 'ngWatchWhenCloneExpression', (getter)->
	clone = -> getter.apply @, arguments
	return _.merge(clone, getter)
.config ($provide)->
	$provide.decorator '$parse', ($delegate, ngWatchWhenRegEx, ngWatchWhenDelegateFactory, ngWatchWhenCloneExpression)->
		return _.wrap $delegate, ($parse, exp, interceptor)->
			if angular.isString(exp) and match = exp.match(ngWatchWhenRegEx)
				[exp, whenStr, onceStr] = match
				whenExp = $parse.apply(@, [whenStr])
				# clone the expression because of the $parse cache
				onceExp = ngWatchWhenCloneExpression($parse.apply(@, [onceStr, interceptor])) 
				onceExp.$$watchDelegate = ngWatchWhenDelegateFactory(whenExp, onceExp)
				return onceExp
			else
				args = [exp]
				if interceptor? then args.push interceptor
				return $parse.apply(@, args)

.value 'ngWatchWhenDelegateFactory', (whenExp, onceExp)->
	return _.wrap onceExp.$$watchDelegate, 
		(originalWatchDelegate, scope, listener, objectEquality, parsedExpression)->
			onceWatch = null
			registerOnceWatch = ()->
				onceWatch = {}
				onceWatch.deregister = originalWatchDelegate.call(@, scope, listener, objectEquality, parsedExpression)
				onceWatch.watcher = _.first(scope.$$watchers) # watchers are 'unshifted' on to the $$watchers array

			registerOnceWatch()
			whenWatch = scope.$watch(whenExp, ()->
				if not _.contains(scope.$$watchers, onceWatch.watcher)
					registerOnceWatch()
			)

			# Returns a de-register forever 'unwatch' function
			return ()->
				whenWatch()
				if _.contains(scope.$$watchers, onceWatch.watcher)
					onceWatch.deregister()
