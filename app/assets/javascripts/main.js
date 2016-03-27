function initConsts(){
    wow.owners = [];
    for (var i = 0; i < wow.companies.length; i++) {
        if ($.inArray(wow.companies[i].owner, wow.owners) === -1){
            wow.owners.push(wow.companies[i].owner);
        }
    }
}

function getItemsData() {
    $.ajax({
        method: "GET",
        url: "/main/search_items",
        data: { "word": wow.myTags },
        dataType: "json"
    }).done(function (data) {
        console.log(data);
        wow.myItemsData = data;
        initGraph();
    });
}

function setTags(){
    var options = {
        edit: true,
        align: {y: 'top'},
        offset: {top: 10},
        handlers: {click: 'toggle'}
    };
    var data = [];
    wow.taggd = $('.taggd').taggd( options, data );

    wow.taggd.on('change', function() {
        resetMyTags();
    });
}

function resetMyTags(){
    wow.myTags = [];
    for (var i = 0; i < wow.taggd.data.length; i++) {
        if (wow.taggd.data[i].text!==""){
            wow.myTags.push(wow.taggd.data[i].text);
        }
    }
    if (wow.myTags.length){
        console.log(wow.myTags);
    }
}

function changeFridge(page,destPage){
    $.mobile.changePage("#"+page, { transition: "slideup", changeHash: true });
    $(page).ready(function(){
        setTimeout(function(){ createTags(page,destPage); }, 250);
    });
}

function fbs_click(media,url) {
    var width=850;
    var height=600;
    var leftPosition, topPosition;
    //Allow for borders.
    leftPosition = (window.screen.width / 2) - ((width / 2) + 10);
    //Allow for title and status bars.
    topPosition = (window.screen.height / 2) - ((height / 2) + 50);
    var windowFeatures = "status=no,height=" + height + ",width=" + width + ",resizable=yes,left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ",toolbar=no,menubar=no,scrollbars=no,location=no,directories=no";
    u=location.href;
    t=document.title;
    window.open(media+url+'&t='+encodeURIComponent(t),'sharer', windowFeatures);
    return false;
}

$(document).ready(function(){
    initConsts();
    $("#startApp").click(function (event) {
        $.mobile.changePage("#menu", { transition: "slideup", changeHash: true });
    });

    $("#addFridge").on("click", function (event) {
        // startCamera();
        setTimeout(function(){
            setTags();
            $("#myFridge").append(wow.datalist);
        }, 500);
        $.mobile.changePage("#myFridge", { transition: "slideup", changeHash: true });
        // $.mobile.changePage("#page3", { transition: "slideup", changeHash: true });
    });

    $("#fridgeFamliy").on("click", function (event) {
        changeFridge("family","fridgeFamliyTags");
    });

    $("#fridgeStudent").on("click", function (event) {
        changeFridge("student","fridgeStudentTags");
    });

    $("#fridgeCouple").on("click", function (event) {
        changeFridge("couple","fridgeCoupleTags");
    });

    $(".submitToGraphs").on("click", function (event) {
        setTimeout(function(){
            getItemsData();
        }, 500);
        $.mobile.changePage("#graph", { transition: "slideup", changeHash: true });
    });

    $(".whatsapp").on("click", function(){
        window.location="whatsapp://send?text=Where is our money? - http://wow-food.herokuapp.com"
    });

    $(".fbShare").on("click", function(){
        fbs_click('http://www.facebook.com/sharer.php?u=','http://wow-food.herokuapp.com');
    });

    $(".email").on("click", function(){
        window.location.href = "mailto:info@shenkar.ac.il?Subject=Where is my money?&Body=http://wow-food.herokuapp.com";
    });
    // -----------------------------------
    //listen to iphone
    // $("#iphoneSnap").on("change",gotPic);
});