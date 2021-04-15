class AppApis{
  static String BASE_URL = 'https://bstwebdemo.co.in/client/development/demolight/';
  static String LOGIN_USER = BASE_URL+'users/login';
  static String GET_PROFILE = BASE_URL+'users/profile';
  static String UPDATE_PROFILE = BASE_URL+'users/updateProfile';
  static String SAVE_DRIVER_INFO = BASE_URL+'users/driver_info';
  static String DRIVER_INFO_LIST = BASE_URL+'users/driver_list';
  static String FORGET_PASSWORD = BASE_URL+'users/forgot_password';
  static String UPDATE_PASSWORD = BASE_URL+'users/update_password';
  static String IMAGE_BASE_URL = 'https://bstwebdemo.co.in/client/development/demolight/uploads/';
  static String GET_MAKE = 'https://vpic.nhtsa.dot.gov/api/vehicles/GetMakesForManufacturerAndYear/mer?year=';
  static String GET_MODEL = 'https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformakeyear/make/';

//https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformakeyear/make/honda/modelyear/2015?format=json
//https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformakeyear/make/FULMER%20FABRICATIONS/modelyear/2015?format=json
}