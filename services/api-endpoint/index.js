const express = require('express');
const app = express();


const url = `${process.env.DB}/database`

app.get("/api-endpoint", (req, res) => {
    axios.get(url)
         .then((response) => res.send(JSON.stringify(response)))
})

app.listen(process.env.PORT, () =>
console.log(`api-endpoint listening on port ${process.env.PORT}`)
);
