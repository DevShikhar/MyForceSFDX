public with sharing class PrettyResponse {
    public PrettyResponse() {

    }
    public String type;	//menuItem
	public cls_menuItems[] menuItems;
	public Integer offset;	//0
	//public Integer number;	//4
	public Integer totalMenuItems;	//11447
	public Integer processingTimeMs;	//121
	public Long expires;	//1677003941413
	public class cls_menuItems {
		public Integer id;	//424566
		public String title;	//Chicken Jr
		public String image;	//https://images.spoonacular.com/file/wximages/424566-312x231.png
		public String imageType;	//png
		public String restaurantChain;	//Burger King
		public cls_servings servings;
	}
	public class cls_servings {
		//public Integer number;	//1
		public Double size;
		public String unit;
	}
	
	public static PrettyResponse parse(String json){
		return (PrettyResponse) System.JSON.deserialize(json, PrettyResponse.class);
	}
}