<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
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
<body onkeydown="tutkiKey(event)">
	<table id="listaus">
		<thead>
		
		<tr>
		
		<th colspan="4" id="ilmo"></th>
			<th><a id="uusiAsiakas" href="lisaaasiakas.jsp">Lis�� uusi asiakas</a></th>
		
		</tr>
		
			<tr>
				<th class="oikealle">Hakusana:</th>
				<th colspan="3"><input type="text" id="hakusana"></th>
				<th><input type="button" value="Hae" id="hakunappi" onclick="haeTiedot()"></th>
			</tr>
			<tr>
				
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sposti</th>
				<th></th>
				
			</tr>
		</thead>
		<tbody id="tbody">
		</tbody>
	</table>
	<script>
	haeTiedot();	
	document.getElementById("hakusana").focus();//vied��n kursori hakusana-kentt��n sivun latauksen yhteydess�

	function tutkiKey(event){
		if(event.keyCode==13){//Enter
			haeTiedot();
		}		
	}
	//Funktio tietojen hakemista varten
	//GET   /asiakkaat/{hakusana}
	function haeTiedot(){	
		document.getElementById("tbody").innerHTML = "";
		fetch("asiakkaat/" + document.getElementById("hakusana").value,{//L�hetet��n kutsu backendiin
		      method: 'GET'
		    })
		.then(function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
			return response.json()	
		})
		.then(function (responseJson) {//Otetaan vastaan objekti responseJson-parametriss�		
			var asiakkaat = responseJson.asiakkaat;	
			var htmlStr="";
			for(var i=0;i<asiakkaat.length;i++){			
	        	htmlStr+="<tr>";
	        	htmlStr+="<td>"+asiakkaat[i].etunimi+"</td>";
	        	htmlStr+="<td>"+asiakkaat[i].sukunimi+"</td>";
	        	htmlStr+="<td>"+asiakkaat[i].puhelin+"</td>";  
	        	htmlStr+="<td>"+asiakkaat[i].sposti+"</td>";
	        	htmlStr+="<td><a href='muutaasiakas.jsp?asiakas_id="+asiakkaat[i].asiakas_id+"'>Muuta</a>&nbsp;";
	        	htmlStr+="<span class='poista' onclick=poista('"+asiakkaat[i].asiakas_id+"')>Poista</span></td>";
	        	htmlStr+="</tr>";        	
			}
			document.getElementById("tbody").innerHTML = htmlStr;		
		})	
	}

	//Funktio tietojen poistamista varten. Kutsutaan backin DELETE-metodia ja v�litet��n poistettavan tiedon id. 
	//DELETE /asiakkaat/id
	function poista(asiakas_id){
		if(confirm("Poista asiakas " + asiakas_id +"?")){	
			fetch("asiakkaat/"+ asiakas_id,{//L�hetet��n kutsu backendiin
			      method: 'DELETE'		      	      
			    })
			.then(function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
				return response.json()
			})
			.then(function (responseJson) {//Otetaan vastaan objekti responseJson-parametriss�		
				var vastaus = responseJson.response;		
				if(vastaus==0){
					document.getElementById("ilmo").innerHTML= "Asiakkaan poisto ep�onnistui.";
		        }else if(vastaus==1){	        	
		        	document.getElementById("ilmo").innerHTML="Asiakkaan " + asiakas_id +" poisto onnistui.";
					haeTiedot();        	
				}	
				setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
			})		
		}	
	}
	</script>
	</body>
	</html>
