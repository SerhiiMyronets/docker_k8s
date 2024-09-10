import express from 'express'
import os from 'os'

const app = express()
app.use(express.json())
const PORT = 3000

app.get("/", (req, res) => {
    const helloMessage = `<h1>Hello from the ${os.hostname()}</h1>`
    console.log(helloMessage)
    res.send(helloMessage)
})

app.get("/nginx", async (req, res) => {
    const url = 'http://nginx'
    const response = await fetch(url);
    const body = await response.text();
    res.send(body)
})

app.get("/jsonplaceholder", async (req, res) => {
    const response = await fetch('https://jsonplaceholder.typicode.com/posts')
        .then(res => res.json())
        .then(json => res.send(json))
    ;
})

app.listen(PORT, () => {
    console.log(`Web server is listening at port ${PORT}`)
})