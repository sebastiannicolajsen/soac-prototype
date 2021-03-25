

const express = require('express');
const app = express();
const request = require('request');


/* transform input data (from env.services):
 * parse object
 */

console.log(process.env.services)

const dict = JSON.parse(process.env.services);
const proxies = Object.keys(dict).reduce(function(map, k){
                      map[k] = dict[k].endpoint
                      return map;
                  }, {})

app.get("*", (req, res) => {
    const e = req.query.endpoint;
    if(!e) return res.status(404).end('missing `endpoint`');
    const ip = proxies[e];
    if(!ip) return res.status(404).end('unknown service');
    const addr = `http://${ip}` + req.url;
    console.log("forwarding to: " + addr);
    req.pipe(request(addr)).pipe(res);
})

app.listen(process.env.PORT, () =>
console.log(`proxy listening on port ${process.env.PORT} `)
);
