function createCanvas(divName) {
	
	var div = document.getElementById(divName);
	var canvas = document.createElement('canvas');
	
	div.appendChild(canvas);
	if (typeof G_vmlCanvasManager != 'undefined') {
		canvas = G_vmlCanvasManager.initElement(canvas);
	}	
	var ctx = canvas.getContext("2d");
	return ctx;
}

function getOwnerByCompID(company_id){
	for (var i = 0; i < wow.companies.length; i++) {
		if (company_id == wow.companies[i].id){
			return wow.companies[i].owner;
		}
	}
}

function calcMoney(){
	wow.results = new Object;
	for (var i = 0; i < wow.myItemsData.length; i++) {
		var curItem = wow.myItemsData[i][0]
		var owner = getOwnerByCompID(curItem.company_id);
		if (wow.results[owner] === undefined){
			wow.results[owner] = parseFloat(curItem.price);
		}else{
			wow.results[owner] += parseFloat(curItem.price);
		}
	};
}

function initGraph(){
	calcMoney();
	var obj = wow.results;
	var keysFiltered = Object.keys(obj).filter(function(item){return !(item == "Ndb_No" || obj[item] == undefined)});
    var valuesFiltered = keysFiltered.map(function(item) {return obj[item]});
    var totalMoney = 0;
	$.each(valuesFiltered,function() {
		totalMoney += this;
	});

    for (var i = 0; i < valuesFiltered.length; i++) {
		valuesFiltered[i] = (valuesFiltered[i]*100)/totalMoney;
    }

	var ctx = createCanvas("resGraph");
	
	var graph = new BarGraph(ctx);
	
	graph.maxValue = 100;
	graph.margin = 2;
	graph.colors = ["#ff0035", "#ff0035", "#ff0035", "#ff0035"];
	graph.xAxisLabelArr = keysFiltered;
	graph.update(Array.apply(null, Array(Object.keys(wow.results).length)).map(Number.prototype.valueOf,0));
	document.querySelector("canvas").style="100%";
	setTimeout(function () {
		graph.update(valuesFiltered);
	}, 1500);
}