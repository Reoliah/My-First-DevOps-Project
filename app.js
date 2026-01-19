const express = require('express');
const app = express()
const port = 3000

app.get('/', (req, res) => {
    res.send('Hello! This is version 1 of my DevOps Project')
})

app.listen(port, () => {
    console.log(`App running on port ${port}`)
})