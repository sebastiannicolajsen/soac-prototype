const express = require('express');
const app = express();
const axios = require('axios').default;


const url = `http://${process.env.DB}/database`

app.get("/api-endpoint", (req, res) => {
    axios.get(url)
         .then((response) => res.send(JSON.stringify(response.data)))
})

app.listen(process.env.PORT, () =>
console.log(`api-endpoint listening on port ${process.env.PORT} with db ${url}`)
);
