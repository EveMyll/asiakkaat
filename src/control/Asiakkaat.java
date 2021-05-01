package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;
import model.Asiakas;
import model.dao.Dao;

@WebServlet("/asiakkaat/*")
public class Asiakkaat extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public Asiakkaat() {
      super();
      System.out.println("Asiakkaat.Asiakkaat()");
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doGet()");
		String pathInfo = request.getPathInfo();	//haetaan kutsun polkutiedot, esim. /seppo			
		System.out.println("polku: "+pathInfo);	
		Dao dao = new Dao();
		ArrayList<Asiakas> asiakkaat;
		String strJSON="";
		if(pathInfo==null) { //Haetaan kaikki asiakkaat 
			asiakkaat = dao.listaaAsiakkaat();
			strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString();	
		}else if(pathInfo.indexOf("haeyksi")!=-1) {		
			int asiakas_id= Integer.parseInt(pathInfo.replace("/haeyksi/", ""));	
			Asiakas asiakas = dao.etsiAsiakas(asiakas_id);
			JSONObject JSON = new JSONObject();		
			JSON.put("etunimi", asiakas.getEtunimi());
			JSON.put("sukunimi", asiakas.getSukunimi());
			JSON.put("puhelin", asiakas.getPuhelin());
			JSON.put("sposti", asiakas.getSposti());
			JSON.put("asiakas_id", asiakas.getAsiakas_id());
			strJSON = JSON.toString();	
		}else{ //Haetaan hakusanan mukaiset asiakkaat
			String hakusana = pathInfo.replace("/", "");
			asiakkaat = dao.listaaAsiakkaat(hakusana);
			strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString();	
		}	
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		out.println(strJSON);	
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("asiakkaat.doPost()");
		JSONObject jsonObj = new JsonStrToObj().convert(request); //Muutetaan kutsun mukana tuleva json-string json-objektiksi			
		Asiakas asiakas = new Asiakas();
		asiakas.setEtunimi(jsonObj.getString("etunimi"));
		asiakas.setSukunimi(jsonObj.getString("sukunimi"));
		asiakas.setPuhelin(jsonObj.getString("puhelin"));
		asiakas.setSposti(jsonObj.getString("sposti"));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.lisaaAsiakas(asiakas)){ //metodi palauttaa true/false
			out.println("{\"response\":1}");  //Asiakkaan lis‰‰minen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //Asiakkaan lis‰‰minen ep‰onnistui {"response":0}
		}		
	}
	

	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doPut()");
		JSONObject jsonObj = new JsonStrToObj().convert(request); //Muutetaan kutsun mukana tuleva json-string json-objektiksi			
		int asiakas_id = jsonObj.getInt("asiakas_id");
		Asiakas asiakas = new Asiakas();
		asiakas.setAsiakas_id(Integer.parseInt(jsonObj.getString("asiakas_id")));
		asiakas.setEtunimi(jsonObj.getString("etunimi"));
		asiakas.setSukunimi(jsonObj.getString("sukunimi"));
		asiakas.setPuhelin(jsonObj.getString("puhelin"));
		asiakas.setSposti(jsonObj.getString("sposti"));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.muutaAsiakas(asiakas, asiakas_id)){
			out.println("{\"response\":1}");  //Asiakkaan muuttaminen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //Asiakkaan muuttaminen ep‰onnistui {"response":0}
		}
	}

	
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doDelete()");
		String pathInfo = request.getPathInfo();	//haetaan kutsun polkutiedot, esim. /asiakas_id		
		int asiakas_id = Integer.parseInt(pathInfo.replace("/", ""));;		
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.poistaAsiakas(asiakas_id)){ //metodi palauttaa true/false
			out.println("{\"response\":1}");  //Asiakkaan poistaminen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //Asiakkaan poistaminen ep‰onnistui {"response":0}
		}
	}

}
