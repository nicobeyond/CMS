﻿angular.module('article-list',['resource.articles'])

.config(["$routeProvider", ($routeProvider) ->
  $routeProvider
    .when "/list/:channel/:group/tag/:tag",
      templateUrl: "/Content/app/article/list/article-list.tpl.html"
      controller: 'ArticleListCtrl'
      resolve:
        articles: ['$route','$q','Article',($route,$q,Article)->
          deferred = $q.defer()
          Article.queryOnce
            $filter:"""
            IsDeleted eq false 
            and Group/Channel/Url eq '#{$route.current.params.channel}' 
            and Tags/any(tag:tag/Name eq '#{$route.current.params.tag}')
            """
            $skip:($route.current.params.p ? 1)*10 - 10
          , (data)->
            deferred.resolve data
          deferred.promise
        ]
    .when "/list/:channel/:group",
      templateUrl: "/Content/app/article/list/article-list.tpl.html"
      controller: 'ArticleListCtrl'
      resolve:
        articles: ['$route','$q','Article',($route,$q,Article)->
          deferred = $q.defer()
          Article.queryOnce
            $filter:"""
            IsDeleted eq false 
            and Group/Channel/Url eq '#{$route.current.params.channel}' 
            and Group/Url eq '#{$route.current.params.group}'
            """
            $skip:($route.current.params.p ? 1)*10 - 10
          , (data)->
            deferred.resolve data
          deferred.promise
        ]
    .when "/list/:channel",
      templateUrl: "/Content/app/article/list/article-list.tpl.html"
      controller: 'ArticleListCtrl'
      resolve:
        articles: ['$route','$q','Article',($route,$q,Article)->
          deferred = $q.defer()
          Article.queryOnce
            $filter:"""
            IsDeleted eq false 
            and Group/Channel/Url eq '#{$route.current.params.channel}'
            """
            $skip:($route.current.params.p ? 1)*10 - 10
          , (data)->
            deferred.resolve data
          deferred.promise
        ]
    .when "/search/:key",
      templateUrl: "/Content/app/article/list/article-list.tpl.html"
      controller: 'ArticleListCtrl'
      resolve:
        articles: ['$route','$q','Article',($route,$q,Article)->
          deferred = $q.defer()
          Article.queryOnce
            $filter:"""
            IsDeleted eq false 
            and indexof(Title, '#{$route.current.params.key}') gt -1
            """
            $skip:($route.current.params.p ? 1)*10 - 10
          , (data)->
            deferred.resolve data
          deferred.promise
        ]
])

.controller('ArticleListCtrl',
["$scope","$window","$routeParams","$location","articles"
($scope,$window,$routeParams,$location,articles) ->
  scroll(0,0)
  $scope.$parent.showBanner=false
  $scope.$parent.title=$routeParams.tag ? $routeParams.group ? $routeParams.channel ? "Search Result '#{$scope.key}'"
  $scope.list = articles
  $scope.params=$routeParams

  $scope.setPage = (pageNo) ->
    $location.search({p: pageNo})

  $scope.edit = (item) ->
    $window.location.href="/admin/article('#{item.PostId}')"
])