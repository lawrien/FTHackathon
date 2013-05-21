/*
 * Copyright (c) 2010 The Chromium Authors. All rights reserved.  Use of this
 * source code is governed by a BSD-style license that can be found in the
 * LICENSE file.
 */

  // The regular expression produced a match, so notify the background page.
  var apiURLRoot = "http://api.ft.com/content/items/v1/";
  var apiKey = "74ceebd2d62ad1e882862db317e2fb95";
  var apiUUID = $('body').data('article-uid');
  var apiURL = apiURLRoot + apiUUID + '?apiKey=' + apiKey;

	$.getJSON(apiURL, function() {
	console.log( "success" );
	})
	.done(function(jqxhr) {
		// get organisations and people, limited to 5
		var organisations = jqxhr.item.metadata.organisations;
		var people = jqxhr.item.metadata.people;

		$(".insideArticleShare").append('Organisations to follow');

		for (var i = 0; i < organisations.length; i++) {
			$(".insideArticleShare").append('<li class="js-link-follow" data-follow="' + organisations[i].term.name + '">' + organisations[i].term.name + '</li>');
		}

		$(".insideArticleShare").append('People to follow');

		for (i = 0; i < people.length; i++) {
			$(".insideArticleShare").append('<li>' + people[i].term.name + '</li>');
		}

		// Add click handler
		document.querySelector('.js-link-follow').addEventListener('click', clickHandler);


		chrome.extension.sendRequest({}, function(response) {});
	})
	.fail(function() { console.log( "error" ); });


// Reset height
$('.insideArticleShare').css( "height", "100%" );


function clickHandler(e) {
  alert('Following');
}


