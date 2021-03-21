const express = require('express');
const uuidv4 = require('uuid').v4;
const app = express();


// generate array for this database's data:
const arr = [uuidv4(),uuidv4(),uuidv4(),uuidv4()]

app.get("/database", (req, res) => {
    return res.send(JSON.stringify({
      data: arr
    }))
})

app.listen(process.env.PORT, () =>
console.log(`database listening on port ${process.env.PORT}`)
);
