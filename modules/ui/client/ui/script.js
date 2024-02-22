/**
 * When true, callbacks will not be triggered. Should be used when
 * viewing in browser.
 */
const testMode = true;

/**
 * When true, will print debug messages to the console.
 */
const debugMode = true;

/**
 * All the translations for this UI, have to be loaded from the client, before using.
 */
const translations = {}

/**
 * uses console.log to print to the console, but only if debugMode is true.
 * @see debugMode
 * @see console.log
 * @param  {*} data the data to log
 */
function debug(...data) {
    // make sure debug mode is active
    if (!debugMode) return;

    // print to console
    console.log(str);
}

/**
 * Trigger a NUI callback on the client.
 * @param {string} type the type of this callback e.g. 'closeUI'. 
 * @param {json} data the data of this callback as json object. 
 * @param {function} cb the callback function, triggered, when the response got received.
 */
function triggerCallback(type, data, cb) {
    // debug
    debug(`FETCH ${type}(${JSON.stringify(data)})`);

    // make sure testMode is not active
    if (testMode) return;
    
    // fetch
    fetch(`https://${GetParentResourceName()}/${type}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify(data)
    }).then(resp => resp.json()).then(resp => cb(resp));
}

/**
 * A list of message handlers.
 */
const messageHandlers = {
    translate: (data) => {
        translations = data.translations;
        document.querySelectorAll('[content]').forEach(element => {
            let content = element.getAttribute("content");
            Object.keys(translations).forEach(key => {
                if (content.includes(`{${key}}`)) {
                    content = content.replace(`{${key}}`, translations[key]);
                }
            });
            element.innerHTML = content;
        });
    },
    color: (data) => {
        document.body.style.setProperty("--COLOR-DARK", data.dark);
        document.body.style.setProperty("--COLOR-NORMAL", data.normal);
        document.body.style.setProperty("--COLOR-LIGHT", data.light);
    }
}

addEventListener('message', (event) => {
    let message = event.data;
    messageHandlers[message.name](message.data);
})