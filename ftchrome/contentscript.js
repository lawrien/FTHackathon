/*
 * Copyright (c) 2010 The Chromium Authors. All rights reserved.  Use of this
 * source code is governed by a BSD-style license that can be found in the
 * LICENSE file.
 */

var head = "<!-- FTHACK Code --> \
 <script src='http://localhost:9292/js/fthack.js'></script> \
    <style> \
        #ftHackSharePanel { \
            display: none; \
        } \
        #ftHackSharePanel .contents { \
            padding: 10px; \
        } \
        #ftHackSharePanel h5 { \
            font-size: 1.1em; \
            margin: 1em 0; \
        } \
        #ftHackSharePanel .shareButtons { \
            padding: 0 10px; \
        } \
        #ftHackSharePanel p { \
            margin-bottom: 1em; \
        } \
        .container .editorialSection p.fade, \
        .container .editorialSection p.fade a { \
            color: #ccc; \
        } \
        .ftLogin-loggedIn { \
            display: block !important; \
        } \
        .ftLogin-loggedOut { \
            display: none !important; \
        } \
    </style>";

    var panel = "<!-- FTHACK --> \
    <div id='ftHackSharePanel'> \
        <div class='comp-header'> \
            <h3 class='comp-header-title'> \
                SHARE \
            </h3> \
        </div> \
        <div class='contents'> \
            <h4 class='title'></h4> \
            <h5 class='subtitle'></h5> \
            <div class='paras'></div> \
        </div> \
        <div class='shareButtons'> \
            <img class='fb-share' src='img/fb-share.png'/> \
            <img class='twitter-share' src='img/twitter-share.png'/> \
            <img class='gplus-share' src='img/gplus-share.png'/> \
        </div> \
    </div>";

  $('head').append(head);
  $('railMiniVideo').replace(panel);
  $('.twitter').attr('id','ftHackShare');
  $('.twitter a').remove();
  $('.twitter').append('<a href="javascript:share()"');
