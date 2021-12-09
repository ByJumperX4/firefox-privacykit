/*** MY OVERRIDES ***/
user_pref("_user.js.parrot", "overrides section syntax error");

/* override recipe: enable session restore ***/
user_pref("browser.startup.page", 3); // 0102
  // user_pref("browser.privatebrowsing.autostart", false); // 0110 required if you had it set as true
  // user_pref("places.history.enabled", true); // 0862 required if you had it set as false
  // user_pref("browser.sessionstore.privacy_level", 0); // 1021 optional [to restore extras like cookies/formdata]
user_pref("privacy.clearOnShutdown.history", false); // 2803
  // user_pref("privacy.clearOnShutdown.cookies", false); // 2803 optional
  // user_pref("privacy.clearOnShutdown.formdata", false); // 2803 optional
user_pref("privacy.cpd.history", false); // 2804 to match when you use Ctrl-Shift-Del
  // user_pref("privacy.cpd.cookies", false); // 2804 optional
  // user_pref("privacy.cpd.formdata", false); // 2804 optional

/* enable search in URL bar ***/
user_pref("keyword.enabled", true);

/* enable WebRTC peer connections ***/
user_pref("media.peerconnection.enabled", true);

/* break font fingerprinting ***/
user_pref("browser.display.use_document_fonts", 0);

/* disable pocket and firefox account */
user_pref("extensions.pocket.enabled", false);
user_pref("identity.fxaccounts.enabled", false);

/* disable Geolocation */
user_pref("geo.enabled", false);

/* enable userChrome.css */
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

user_pref("_user.js.parrot", "overrides section successful");
