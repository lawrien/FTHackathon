$(function() {

    var shareLink = '';
    var chosenParaIndexes = [0,1,2];

    function init() {

        $('#ftHackShare').click(function() {

            share();

        });

        $('#ftHackSharePanel .twitter-share').click(function() {

            fetchSharableLink();

        });

    }
    init();

    function share() {

        updateSharePanel();

        updateFades();

        $('.container .editorialSection p').mouseover(function() {

            var paraIndex = $('#storyContent').find('p').index(this);

            chosenParaIndexes = [paraIndex, paraIndex+1, paraIndex+2];

            updateSharePanel();
            updateFades();

        });

        $($sharePanelEl).show();

        $('#ftHackDefaultPanel').hide();

    }

    function updateSharePanel() {

        var title = document.title;
        var subtitle = $('.standfirst').length > 0 ? $('.standfirst')[0] : $('.byline span')[0];

        var parasHtml = '';

        for( var i=0; i < chosenParaIndexes.length; i++ ) {

            var paraIndex = chosenParaIndexes[i];
            parasHtml += '<p>' + $('#storyContent p:eq('+ paraIndex + ')').html() + '</p>';

        }

        $sharePanelEl = $('#ftHackSharePanel');
        $contentsEl = $('#ftHackSharePanel .contents');

        $('.title', $contentsEl).html(document.title);

        $('.subtitle', $contentsEl).html(subtitle);

        $('.paras', $contentsEl).html(parasHtml);

    }

    /*
    function updateShareButtons() {

        $('.twitter-share-button', $sharePanelEl).attr('href', 'https://twitter.com/share?count=none&text='+' original: ');

        setupTwitterButton();

    }

    function setupTwitterButton() {

        !function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");

    }
    */

    function updateFades() {

        $('#storyContent p').addClass('fade');

        for( var i=0; i < chosenParaIndexes.length; i++ ) {

            var paraIndex = chosenParaIndexes[i];
            $('#storyContent p:eq('+ paraIndex + ')').removeClass('fade');

        }

    }

    function fetchSharableLink() {

        var dataValues = {
            'articleId': articleUUID,
            'paras': chosenParaIndexes
        };

        $.ajax({
            url: '/share',
            type: 'post',
            data: dataValues,
            success: function(data) {

                shareLink = data;
                twitterShare();

            },
            error: function() {
                alert('Error');
            }
        });

    }

    function twitterShare() {

        var width = 550,
            height = 520,
            left = Math.round( screen.width / 2 - width / 2 ),
            top = 0;

        window.open('https://twitter.com/intent/tweet?original_referer=&text=%20original%3A…%2F%2Fwww.ft.com%2Fcms%2Fs%2F0%2Ff65828a6-c0c9-11e2-aa8e-00144feab7de.html', // URL
            undefined, // window name
            'width='+width+',height='+height+',left='+left+',top='+top ); // window features

        //'https://twitter.com/intent/tweet?original_referer=&text=%20original%3A…%2F%2Fwww.ft.com%2Fcms%2Fs%2F0%2Ff65828a6-c0c9-11e2-aa8e-00144feab7de.html'

    }

});