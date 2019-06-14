var esCuadrado = true;
var altura = 10;
var anchura = 10;
var nivel = 0;
var coordsSalida;
var coordsMeta;

var estableceSalida = false;
var estableceMeta = false;
var pintando = false;
var goma = false;
var borrando = false;

$(document).ready(function(){
	$("#alturaTablero").val(altura);
	$("#anchuraTablero").val(anchura);

	$("#alturaTablero").on("change", function(){
		altura = parseInt($(this).val());
		if(esCuadrado){
			$("#anchuraTablero").val(parseInt($(this).val()));
			anchura = altura;
		}
	});

	$("#anchuraTablero").on("change", function(){
		anchura = parseInt($(this).val());
		if(esCuadrado){
			$("#alturaTablero").val(parseInt($(this).val()));
			altura = anchura;
		}
	});

	$("#nivelTablero").on("change", function(){
		nivel = parseInt($(this).val());
	});

	$("#checkIgualar").on("change", function(){
		if(this.checked){
			esCuadrado = true;
			$("#anchuraTablero").val(parseInt($("#alturaTablero").val()));
		}else{
			esCuadrado = false;
		}
	});

	$("#checkBorrar").on("change", function(){
		if(this.checked){
			goma = true;
		}else{
			goma = false;
		}
	});

	$("#contenedorTablero").on("mousedown", ".celda", function(){
		if(goma){
			borrando = true;
			$(this).removeClass("muro salida meta");
			$(this).addClass("vacio");
		}else if(estableceSalida){
			$(".salida").removeClass("salida").addClass("vacio");
			$(this).removeClass("muro vacio meta");
			$(this).addClass("salida");
			estableceSalida = false;
		}else if(estableceMeta){
			$(".meta").removeClass("meta").addClass("vacio");
			$(this).removeClass("muro vacio salida");
			$(this).addClass("meta");
			estableceMeta = false;
		}else{
			pintando = true;
			$(this).removeClass("vacio salida meta");
			$(this).addClass("muro");
		}
	});

	$("html body").on("mouseup", function(){
		pintando = false;
		borrando = false;
	});

	$("#contenedorTablero").on("mouseover", ".celda", function(){
		if(goma && borrando){
			$(this).removeClass("muro");
			$(this).addClass("vacio");
		}else if(pintando){
			$(this).removeClass("vacio salida meta");
			$(this).addClass("muro");
		}
	});

});

$(document).on("mouseleave",function () {
   	pintando = false;
	borrando = false;
});

function generarTablero(){
	if(altura > 0 && anchura > 0){
		$("#contenedorTablero").empty();
		for(let i=0;i<altura;i++){
			let curFila = "f" + i;
			$("#contenedorTablero").append("<div id='" + curFila + "' class='fila' data-nfila='"+i+"'></div>");
			for(let j=0;j<anchura;j++){
				let curColum = "c_" + i + "_" + j;
				$("#" +curFila+ "").append("<div id='" + curColum + "' class='celda vacio' data-nfila='"+i+"' data-ncol='"+j+"'></div>");
			}
		}
	}
}

function limpiar(){
	$(".celda").removeClass('muro salida meta').addClass('vacio');
	$("#areaMatriz").hide()
}

function activaStart(){
	estableceSalida = true;
}

function activaEnd(){
	estableceMeta = true;
}

function generarMatriz(){
	var matriz = "levels["+nivel+"] = {\n";
	matriz = matriz + "\tname = \"Level " + nivel + "\",\n"
	matriz = matriz + "\tmap = {\n\t\t{"
	for(var i=0;i<anchura + 2;i++){
		if(i == anchura+1){
			matriz = matriz + " 4},\n";
		}else{
			matriz = matriz + " 4,";
		}
	}
	
	$('.celda').each(function(i, obj) {
		if($(this).data("ncol") == 0){
			matriz = matriz + "\t\t{ 4, ";
		}
    	if($(this).hasClass('muro')){
    		matriz = matriz + "1, ";
    	}else if($(this).hasClass('vacio')){
    		matriz = matriz + "0, ";
    	}else if($(this).hasClass('salida')){
    		matriz = matriz + "2, ";
    		coordsSalida = ($(this).data('ncol') + 2) + ", " + ($(this).data('nfila') +2);
    	}else if($(this).hasClass('meta')){
    		matriz = matriz + "3, ";
    	}
    	if($(this).data("ncol") == anchura-1){
			matriz = matriz + "4},\n";
		}
	});

	for(var j=0;j<anchura + 2;j++){
		if(j==0){
			matriz = matriz + "\t\t{ 4,";
		}else if(j == anchura+1){
			matriz = matriz + " 4}\n\t},\n";
		}else{
			matriz = matriz + " 4,";
		}
	}

	matriz = matriz + "\tstart = {"+coordsSalida+"}\n}"

	$("#areaMatriz").show().text(matriz);
	$("#areaMatriz").focus();
	$("#areaMatriz").select();
	$("#areaMatriz").blur();
	document.execCommand('copy');
	console.log(matriz)
}