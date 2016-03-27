function createTags(fridgeType,destPage){
    var options = {
        align: {x: 'center', y: 'center'},
        offset: {left: 0,top: 12},
        handlers: {
            click: function (e) {
                this; // the DOM Node
                e;    // the Event
            },
            mouseenter: 'show',
            mouseleave: 'hide'
        }
    };
    
    var pos;

    switch (fridgeType){
        case "family":
        case "couple":
        case "student":
            pos = [
                {x:0.2,y:0.4},
                {x:0.2,y:0.7},
                {x:0.4,y:0.8},
                {x:0.34,y:0.36},
                {x:0.29,y:0.46},
                {x:0.15,y:0.81},
                {x:0.61,y:0.8},
                {x:0.6,y:0.66},
                {x:0.63,y:0.37},
            ];
        break;
    }
    
    var data = [];
    wow.myTags = [];
    for (var i = 0; i < wow[fridgeType].length; i++) {
        obj = {
            x:pos[i].x,
            y:pos[i].y,
            text: wow[fridgeType][i].name,
            attributes:{
                price: wow[fridgeType][i].price,
                companyName: wow[fridgeType][i].name
            }
        };
        data.push(obj);
        wow.myTags.push(wow[fridgeType][i].name);
    }
    $("#"+destPage).taggd(options, data);
}