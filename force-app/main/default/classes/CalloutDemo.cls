public with sharing class CalloutDemo {
    public CalloutDemo() {

    }

    public static void getReciep() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('https://api.spoonacular.com/food/menuItems/search?apiKey=d14cf20a427c462697d2c720d3ea239e&query=pasta&number=4');
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            
            PrettyResponse result = PrettyResponse.parse(res.getBody());
            if (result.menuItems.size() > 0) {
                for (PrettyResponse.cls_menuItems item : result.menuItems) {
                    System.debug(item.title);
                    System.debug(item.restaurantChain);
                    System.debug(item.servings.size);
                }
            }
        }



    }
}