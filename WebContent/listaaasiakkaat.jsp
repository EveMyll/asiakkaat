<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<title>Listaus</title>
<style>
.oikealle {
	text-align: center;
	font-family: 'Times New Roman', Times, serif;
	font-size: 14px;
}
label {
	display: block;
	width: 60px;
	float:center;
}
input {
	margin-bottom: 5px;
}
table {
	border: 1px, solid black;
	padding: 10px;
	text-align: center;
}
tr {
	background-color: orange;
}
td {
	text-align: center;
	background-color: lightblue;
	padding: 25px;
}
}
</style>

</head>
<body>
	<table id="listaus">
		<thead>
		
		<tr>
		
		<th colspan="5" class="oikealle"><span id="uusiAsiakas">Lisää uusi asiakas</span></th>
		
		</tr>
		
			<tr>
				<th class="oikealle">Hakusana:</th>
				<th colspan="3"><input type="text" id="hakusana"></th>
				<th><input type="button" value="Hae" id="hakunappi"></th>
			</tr>
			<tr>
	
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sposti</th>
				<th></th>
				
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	<script>
		$(document).ready(function() {
			
			$("#uusiAsiakas").click(function(){
				document.location="lisaaasiakas.jsp";
			});
			
			$(document.body).on("keydown", function(event){
				  if(event.which==13){ //Enteriä painettu, ajetaan haku
					  haeAsiakkaat();
				  }
			});	
			$("#hae").click(function(){	
				haeAsiakkaat();
			});
			$("#hakusana").focus();//viedään kursori hakusana-kenttään sivun latauksen yhteydessä
			haeAsiakkaat();
		});
		function haeAsiakkaat() {
			$("#listaus tbody").empty();
			$.ajax({
				url : "asiakkaat/" + $("#hakusana").val(),
				type : "GET",
				dataType : "json",
				success : function(result) {//Funktio palauttaa tiedot json-objektina		
					$.each(result.asiakkaat, function(i, field) {
						var htmlStr;
						htmlStr+="<tr id='rivi_"+field.asiakas_id+"'>";
						htmlStr += "<td>" + field.etunimi + "</td>";
						htmlStr += "<td>" + field.sukunimi + "</td>";
						htmlStr += "<td>" + field.puhelin + "</td>";
						htmlStr += "<td>" + field.sposti + "</td>";
			        	htmlStr+="<td><a href='muutaasiakas.jsp?asiakas_id="+field.asiakas_id+"'>Muuta</a>&nbsp;"; 
			        	htmlStr+="<span class='poista' onclick=poista('"+field.asiakas_id+"','"+field.etunimi+"','"+field.sukunimi+"')>Poista</span></td>";
			        	htmlStr+="</tr>";
			        	$("#listaus tbody").append(htmlStr);
			        });	
			    }});
			}
		function poista(asiakas_id, etunimi, sukunimi){
			if(confirm("Poista asiakas " + etunimi +" "+ sukunimi +"?")){
				$.ajax(
						{url:"asiakkaat/" +asiakas_id,
							type:"DELETE", 
							dataType:"json", 
							success:function(result) { //result on joko {"response:1"} tai {"response:0"}
			        if(result.response==0){
			        	$("#ilmo").html("Asiakkaan poisto epäonnistui.");
			        }else if(result.response==1){
			        	alert("Asiakkaan " + etunimi +" "+ sukunimi +" poisto onnistui.");
						haeAsiakkaat();        	
					}
			    }});
			}
		}
	</script>
</body>
</html>