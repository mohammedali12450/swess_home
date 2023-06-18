const String proNetBaseUrl = "https://backend-v2.swesshome.com/api/v2/";
const String proNetImagesUrl = "https://backend-v2.swesshome.com/storage/";
const String hostingerBaseUrl = "http://swesshomerealestate.com/";
const String hostingerImagesBaseUrl = "http://swesshomerealestate.com/";
const String hostingerTestUrl = "https://swessoffice.com/public/";
const String hostingerTestImageUrl = "https://swessoffice.com/storage/";
String baseUrl = hostingerTestUrl;
String imagesBaseUrl = hostingerTestImageUrl;
const fetchBaseUrlUrl = "api/fetchBaseUrl";

//new api

const userRegisterURL = "customer/register";
const userLoginURL = "customer/login";
const userSocialLogin = "";
const userDataURL = "customer/details";
const userEditDataURL = "customer/update";
const governoratesURL = "customer/governorates";
const getAllOfficesURL = "estate-offices";
const getOfficeDetailsURL = "estate-offices/";
const getOfficeDetailsWithAuthURL = "estate-offices/auth-customers/";
const priceDomainURL = "price-domains";
const getReportsTypesURL = "report-types";
const getPeriodTypesURL = "period-types";
const sendReportURL = "report";
const areaUnitsURL = "area-units";
const estateOfferTypesURL = "offer-types";
const estateTypesURL = "estate-types";
const interiorStatusesURL = "interior-statuses";
const ownershipTypesURL = "ownership-types";
const searchResultEstateURL = "estate/search";
const newestEstateURL = "estate/newest";
const mostViewEstateURL = "estate/most-viewed";
const specialEstateURL = "estate/special";
const sendMessageURL = "send-message";
const getMessagesURL = "view-messages";
const addRentEstateURL = "estate/rented-estates";
const getRentEstatesURL = "estate/rented-estates"; //did not use
const getMyRentEstatesURL = "estate/rented-estates/customer-estates";
const deleteMyRentEstatesURL = "estate/rented-estates/customer-estates/";
const filterRentEstateURL = "estate/rented-estates/filter";
const lastVisitedEstateURL = "estate/last-visited";
const shareCountEstateURL = "estate/share";
const createEstateOrderURL = "estate-orders/create";
const getEstateOrderURL = "estate-orders";
const deleteEstateOrderURL = "estate-orders/";
const termsAndConditionsURL = "termsandconditions/get/";
const createEstateOfferURL = "estate/create";
const getEstateOfferURL = "estate/customer-estates";
const deleteUserEstateOfferURL = "estate/delete/";
const visitOfficeURL = "office/visit";
const visitEstateURL = "estate/visit";
const getSavedEstatesURL = "saves";
const likeEstateURL = "like/estate";
const likeOfficeURL = "like/office";
const unlikeEstateURL = "unlike/estate";
const unlikeOfficeURL = "unlike/office";
const saveEstateURL = "saves";
const unSaveEstateURL = "saves";
const callEstateURL = "estate/call";
const fcmTokenURL = "fcm-token/create";
const ratingURL = "app-rate/create";
const systemVariablesURL = "system-var";
const sendCodeURL = "customer/send-code";
const resendCodeURL = "customer/code/resend";
const checkCodeURL = "customer/code/check";
const verificationCodeURL = "customer/check-forget-password";
const deleteUserURL = "customer/delete";
const logoutURL = "customer/logout";
const resetPasswordURL = "customer/reset-password";
const changePasswordURL = "customer/change-password";
const searchOfficeLocURL = "estate-offices/search-by-region";
const notificationsURL = "notifications";
const getRegionsURL = "locations/regions";
const getLocationURL = "locations/sub-locations";
const multiLoginURL = "customer/check-login-code";
const getEstateDetailsURL = "estate/details/";
const downloadURL = "download-url";

/// added new
const sendDirectMessageURL = "messages/store";

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
