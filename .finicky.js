module.exports = {
  defaultBrowser: "Brave Browser",
  handlers: [
    {
      match: ["gitlab.okg.com*", "*.metcoin.app*" , "test*.okg.com*", "*okex.svc.test.local*"],
      browser: "/users/gordonlee/meili/gordon.lee_dacs_at_okg.com/applications/110/google chrome.app"
    },
    {
      match: ["sublot-io.sg.larksuite.com*"],
      browser: "Brave Browser Beta"
    },
  ]
};
