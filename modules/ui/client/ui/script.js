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
