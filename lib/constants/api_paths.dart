const String proNetBaseUrl = "https://backend.swesshome.com/";
const String proNetImagesUrl = "https://backend.swesshome.com/storage/";
const String hostingerBaseUrl = "http://swesshomerealestate.com/";
const String hostingerImagesBaseUrl = "http://swesshomerealestate.com/";
const String hostingerTestUrl = "http://swessoffice.com/public/";
const String hostingerTestImageUrl = "http://swessoffice.com/storage/";
String baseUrl = hostingerTestUrl;
String imagesBaseUrl = hostingerTestImageUrl;
const fetchBaseUrlUrl = "api/fetchBaseUrl";
//new api
const userRegisterURL = "api/v2/customer/register";
const userLoginURL = "api/v2/customer/login";
const userDataURL = "api/v2/customer/details";
const userEditDataURL = "api/v2/customer/update";
const governoratesURL = "api/v2/customer/governorates";
const getAllOfficesURL = "api/v2/estate-offices";
const getOfficeDetailsURL = "api/v2/estate-offices/";
const getOfficeDetailsWithAuthURL = "api/v2/estate-offices/auth-customers/";
const priceDomainURL = "api/v2/price-domains";
const getReportsTypesURL = "api/v2/report-types";
const getPeriodTypesURL = "api/v2/period-types";
const sendReportURL = "api/v2/report";
const areaUnitsURL = "api/v2/area-units";
const estateOfferTypesURL = "api/v2/offer-types";
const estateTypesURL = "api/v2/estate-types";
const interiorStatusesURL = "api/v2/interior-statuses";
const ownershipTypesURL = "api/v2/ownership-types";
const searchResultEstateURL = "api/v2/estate/search";
const newestEstateURL = "api/v2/estate/newest";
const mostViewEstateURL = "api/v2/estate/most-viewed";
const specialEstateURL = "api/v2/estate/special";
const sendMessageURL = "api/v2/send-message";
const getMessagesURL = "api/v2/view-messages";
const addRentEstateURL = "api/v2/estate/rented-estates";
const getRentEstatesURL = "api/v2/estate/rented-estates";
const filterRentEstateURL = "api/v2/estate/rented-estates/filter";
const lastVisitedEstateURL = "api/v2/estate/last-visited";
const shareCountEstateURL = "api/v2/estate/share";
const createEstateOrderURL = "api/v2/estate-orders/create";
const getEstateOrderURL = "api/v2/estate-orders";
const deleteEstateOrderURL = "api/v2/estate-orders";
const termsAndConditionsURL = "api/v2/termsandconditions/get/";
const createEstateOfferURL = "api/v2/estate/create";
const getEstateOfferURL = "api/v2/estate/customer-estates";
const deleteUserEstateOfferURL = "api/v2/estate/delete/";
const visitOfficeURL = "api/v2/office/visit";
const visitEstateURL = "api/v2/estate/visit";
const getSavedEstatesURL = "api/v2/saves";
const likeEstateURL = "api/v2/like/estate";
const likeOfficeURL = "api/v2/like/office";
const unlikeEstateURL = "api/v2/unlike/estate";
const unlikeOfficeURL = "api/v2/unlike/office";
const saveEstateURL = "api/v2/saves";
const unSaveEstateURL = "api/v2/saves";
const callEstateURL = "api/v2/estate/call";
const fcmTokenURL = "api/v2/fcm-token/create";
const ratingURL = "api/v2/app-rate/create";
const systemVariablesURL = "api/v2/system-var";
const sendCodeURL = "api/v2/customer/send-code";
const resendCodeURL = "api/v2/customer/code/resend";
const checkCodeURL = "api/v2/customer/code/check";
const verificationCodeURL = "api/v2/customer/check-forget-password";
const deleteUserURL = "api/v2/customer/delete";
const logoutURL = "api/v2/customer/logout";
const resetPasswordURL = "api/v2/customer/reset-password";
const searchOfficeLocURL = "api/v2/estate-offices/search-by-region";
const notificationsURL = "api/v2/notifications";
const getRegionsURL = "api/v2/locations/regions";
const getLocationURL = "api/v2/locations/sub-locations";
const multiLoginURL = "api/v2/customer/check-login-code";
const getEstateDetailsURL = "api/v2/estate/details/";
const downloadURL = "api/v2/download-url";


//old api
// const userRegisterUrl = "api/user/register";
// const userLoginUrl = "api/login1"; //login1 can't access with multi login   //login can access with multi login
// const ownershipTypesUrl = "api/ownershipTypes";
// const estateTypesUrl = "api/estateTypes";
// const interiorStatusesUrl = "api/interiorStatuses";
// const estateOfferTypesUrl = "api/estateOfferTypes";
// const periodTypesUrl = "api/periodTypes";
// const areaUnitsUrl = "api/areaUnits";
// const priceDomainsUrl = "api/priceDomains";
// const locationsUrl = "api/locations";
// const searchUrl = "api/estate/search";
//const advancedSearchUrl = "api/estate/advancedSearch";
//const sendEstateUrl = "api/user/newEstate";
//const sendEstateOrderUrl = "api/estateOrder/newEstateOrder";
//const logoutUrl = "api/logout";
// const searchEstateOfficeByNameUrl = "api/office/searchByNamenew";
// const searchEstateOfficeByLocationIdUrl = "api/office/searchByRegions";
//const getOfficeEstatesUrl = "api/getOfficeAcceptedEstates";
//const systemVariablesUrl = "api/systemVariables";
//const notificationTypesUrl = "api/notificationTypes";
//const notificationsUrl = "api/notification/getAll";
//const clearNotificationsUrl = "api/notifications";
//const fcmTokenUrl = "api/office/FCM_token";
//const getRecentEstatesOrdersUrl = "api/user/recentEstateOrders";
//const getUserEstatesUrl = "api/user/estates";
// const getSavedEstatesUrl = "api/user/saves";
// const likeEstateUrl = "api/estate/like";
// const likeOfficeUrl = "api/office/like";
// const unlikeEstateUrl = "api/estate/unlike";
// const unlikeOfficeUrl = "api/office/unlike";
// const saveEstateUrl = "api/estate/save";
// const unSaveEstateUrl = "api/estate/unSave";
//const visitEstateUrl = "api/estate/visit";
//const visitOfficeUrl = "api/office/visit";
//const callEstateUrl = "api/estate/call";
// const getReportsTypesUrl = "api/reportTypes";
// const sendReportUrl = "api/report";
//const ratingUrl = "api/applicationRating";
//const checkConfirmationCode = "api/code/check";
//const forgetPasswordUrl = "api/forgetUserPasswordSendCode";
//const resetPasswordUrl = "api/ResetUserPassword";

//const verificationUrl = "api/forgetUserPasswordCheck";
// const allregionsUrl = "api/allregions";
// const allLocationUrl = "api/getallsublocations";
// const newSearchUrl = "api/estate/searchEstateByregionsByestatefeatures";
//const searchByregionUrl = "api/office/searchByRegions";
//const resendConfirmationCode = "api/code/resend";
//const deleteUserUrl = "api/user/deleteUserInformation";
//const multiLoginUrl = "api/checklogincode";
//const termsAndConditionsUrl = "api/termsandconditions/";
//const deleteEstateOrderUrl = "api/delete/estateorder";
//const deleteUserNewEstateUrl = "api/delete/usernewestate";
// const getOfficeDetailsUrl = "api/getOfficeByID1";

const isUpdatedForIosUrl = "api/isUpdatedForIos";
const isUpdatedForAndroidUrl = "api/isUpdatedForAndroid";

