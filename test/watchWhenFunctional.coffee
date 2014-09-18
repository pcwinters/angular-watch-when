describe 'ngWatchWhen:func', ->

	describe 'using $scope.$watch', ->

		beforeEach ->
			module 'ngWatchWhen'
			inject (@$rootScope)->
			
			@$scope = @$rootScope.$new()
			spyOn(@$scope, '$watch').andCallThrough()
			@listener = jasmine.createSpy('$watch listener')			

		it "should register 2 watches, for the 'when' and '::once' expressions", ->
			expect(@$scope.$$watchers).toBeNull()
			@$scope.$watch('::when::once', @listener)
			expect(@$scope.$watch.callCount).toEqual(3)
			expect(@$scope.$$watchers.length).toEqual(2)

		it 'should deregister all watches if the listener is cleaned up (unwatched)', ->
			expect(@$scope.$$watchers).toBeNull()
			unwatch = @$scope.$watch('::when::once', @listener)
			expect(@$scope.$watch.callCount).toEqual(3)
			expect(@$scope.$$watchers.length).toEqual(2)

			unwatch()
			expect(@$scope.$$watchers.length).toEqual(0)
			@$scope.$digest()
			expect(@listener).not.toHaveBeenCalled()


		# Just a sanity check on the ng '::once' behavior
		it 'should fire the listener until the value is defined', ->
			@$scope.$watch('::when::once', @listener)
			@$scope.$digest()
			expect(@listener).toHaveBeenCalled()
			expect(@listener.callCount).toEqual(1)

			@$scope.once = 'once'
			@$scope.$digest()
			expect(@listener.callCount).toEqual(2)

			@$scope.once = 'twice'
			@$scope.$digest()
			expect(@listener.callCount).toEqual(2)
			

		it 'should only fire the listener once if the value is defined', ->
			@$scope.once = 'once'
			@$scope.$watch('::when::once', @listener)
			@$scope.$digest()
			expect(@listener).toHaveBeenCalled()
			expect(@listener.callCount).toEqual(1)

			@$scope.once = 'twice'
			@$scope.$digest()
			expect(@listener.callCount).toEqual(1)

		it "should re-cycle the listener if the value of the 'when' expression has changed", ->
			@$scope.when = 'when'
			@$scope.once = 'once'
			@$scope.$watch('::when::once', @listener)
			@$scope.$digest()
			expect(@listener).toHaveBeenCalled()
			expect(@listener.callCount).toEqual(1)

			@$scope.once = 'twice'
			@$scope.$digest()
			expect(@listener.callCount).toEqual(1)

			@$scope.when = 'again'
			@$scope.$digest()
			expect(@listener.callCount).toEqual(2)

			@$scope.once = 'thrice'
			@$scope.$digest()
			expect(@listener.callCount).toEqual(2)

