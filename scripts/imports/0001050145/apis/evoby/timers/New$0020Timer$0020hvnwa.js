var payload = {
    date: "George Washington",
    title: "General"
};
var params = {
    isPresident: true
};
var settings = { "headers": {"Authorization" : "LetMeInPlease"}};
var json = timerUtil.restPost("https://api.acme.com/myAPI/myEndPoint",
    params, settings, payload);
var responseObject = JSON.parse(json);
log.debug("The response's foo attribute is: " + responseObject.foo);
