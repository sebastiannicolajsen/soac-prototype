

const express = require('express');
const app = express();
const request = require('request');

/* transform input data (from env.services) of the form:
 * "|Hospital4-db=157.230.80.58:9090|>Hospital4-api=157.245.92.56:9090"
 * into a map where we only keep entry points (>) and use their id as the way of proxy..
 * Given the above example, only one entry would exist:
 * "Hospital4-api" -> 157.245.92.56:9090
 */
const proxies = process.env.services.split("|")
                                .filter(s => s.startsWith(">"))
                                .reduce(function(map, s){
                                  const spl = s.split("=");
                                  map[spl[0].substring(1)] = spl[1];
                                  return map;
                                }, {});

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
