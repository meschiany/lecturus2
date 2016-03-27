// Put event listeners into place
function startCamera(){
    
    // Put video listeners for Android
    window.canvas = document.getElementById("canvas"),
        context = canvas.getContext("2d"),
        video = document.getElementById("video"),
        videoObj = { "video": true },
        errBack = function (error) {
            console.log("Video capture error: ", error.code);
        };
   
    if (navigator.getUserMedia) { // Standard
        navigator.getUserMedia(videoObj, function (stream) {
            video.src = stream;
            video.play();
        }, errBack);
    } else if (navigator.webkitGetUserMedia) { // WebKit-prefixed
        navigator.webkitGetUserMedia(videoObj, function (stream) {
            video.src = window.URL.createObjectURL(stream);
            video.play();
        }, errBack);
    }
    else if (navigator.mozGetUserMedia) { // Firefox-prefixed
        navigator.mozGetUserMedia(videoObj, function (stream) {
            video.src = window.URL.createObjectURL(stream);
            video.play();
        }, errBack);
    }
//Definitions-photo-css

    $("#canvas").css("display", "none");
    $("#SubmitToGraphs").css("display", "none");

    // Get-Save Snapshot - image 
    $("#snap").click(function () {
        gotPic();
        $('img').css("width", "100%");
        $('img').css("height", "100%");
        $("#myTags").css("display", "block");
        dataProduct();
        $("#SubmitToGraphs").css("display", "block");
        $("#snap").hide();
        
    });

    // reset - clear - to Capture New Photo
    $("#snapAgain").click(function () {
        $("#video").fadeIn("slow");
        $("img").remove();
        $("#canvas").fadeOut("slow");
        $("#snap").show();
        $("#snapAgain").show();
        $("#myTags").css("display", "none");
        $("#SubmitToGraphs").css("display", "none");
    });
}

// Converts canvas to an image 
// callback from drawImage
function convertCanvasToImage(canvas) {
    
    window.lastFrig = Date.now();
    var can = document.getElementById('canvas');
    $.ajax({
        type: "POST",
        url: "/main/save_img",
        data: {"imgBase64": can.toDataURL(),"name":lastFrig}
    }).done(function(o) {
        var img = $('<img id="dynamic">'); //Equivalent: $(document.createElement('img'))
        img.attr('src', "/assets/"+lastFrig+".png");
        img.appendTo('#CamreShoot');
        console.log('saved');
    });
}

function gotPic(event) {
    context.drawImage(video, 0, 0, 640, 480);
    // convertCanvasToImage();
    $("#video").fadeOut("slow");
}