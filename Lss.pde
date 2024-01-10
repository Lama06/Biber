import java.io.IOException;
import java.net.CookieManager;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

String url = "https://www.leitstellenspiel.de", name = "Wehner.123", passwort = "Pommes";
//String url = "https://www.missionchief.com", name = "WeberGMBH", passwort = "Taschentuch";

Leitstellenspiel lss;
String letzteNachricht;

void listeAbrufen() {
  try {
    if (lss == null) {
       lss = new Leitstellenspiel(); 
       lss.login();
       letzteNachricht = lss.holNachricht();
       return;
    }
    
    String text = lss.holNachricht();
    if (text.equals(letzteNachricht)) return;
    einkaufen.anfuegen(text);
    letzteNachricht = text;
  } catch (Exception e) {
    e.printStackTrace();
  }
}

class Leitstellenspiel {
    HttpClient internetz;
    String schluessel;

    Leitstellenspiel() {
        internetz = HttpClient.newBuilder().cookieHandler(new CookieManager()).build();
    }

    String holSchluessel() throws IOException, InterruptedException {
        if (schluessel != null) return schluessel;
        String html = internetz.send(HttpRequest.newBuilder().uri(URI.create(url + "/impressum")).build(), HttpResponse.BodyHandlers.ofString()).body();
        for (String zeile : html.split("\n")) {
            if (!zeile.contains("csrf-token")) continue;
            schluessel = zeile.substring(15).split("\"")[0];
            return schluessel;
        }
        throw new IllegalStateException();
    }

    String datenZuText(Map<String, String> daten) throws IOException, InterruptedException {
        daten = new HashMap<>(daten);
        daten.put("utf8", "✓");
        daten.put("authenticity_token", holSchluessel());
        StringBuilder formBodyBuilder = new StringBuilder();
        for (Map.Entry<String, String> singleEntry : daten.entrySet()) {
            if (formBodyBuilder.length() > 0) {
                formBodyBuilder.append("&");
            }
            formBodyBuilder.append(URLEncoder.encode(singleEntry.getKey(), StandardCharsets.UTF_8));
            formBodyBuilder.append("=");
            formBodyBuilder.append(URLEncoder.encode(singleEntry.getValue(), StandardCharsets.UTF_8));
        }
        return formBodyBuilder.toString();

    }

    void login() throws IOException, InterruptedException {
        internetz.send(
                HttpRequest.newBuilder()
                        .POST(HttpRequest.BodyPublishers.ofString(datenZuText(Map.of(
                                "user[email]", name,
                                "user[password]", passwort,
                                "user[remember_me]", "0",
                                "commit", "Einloggen"
                        ))))
                        .uri(URI.create(url + "/users/sign_in"))
                        .build(),
                HttpResponse.BodyHandlers.ofString()
        ).body();
    }

    String holNachricht() throws IOException, InterruptedException {
        String html = internetz.send(HttpRequest.newBuilder().uri(URI.create(url + "/alliance_chats")).GET().build(),
                HttpResponse.BodyHandlers.ofString()).body();
        String[] zeilen = html.split("\n");
        for (int i = 0; i < zeilen.length; i++) {
            if (!zeilen[i].contains("data-message-time")) continue;
            i += 6;
            return zeilen[i].substring(6, zeilen[i].length()-4);
        }
        throw new IllegalStateException();
    }
}
