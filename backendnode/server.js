const express = require('express');
const bodyParser = require('body-parser');

//app configuration
const app = express();

const port = 3000;

//middleware configuration
app.use(bodyParser.json());

//define item list (simulating a simple in-memory database)
let itemList = [
  { id: 1, name: "my name dinesh" },
];

//api routes
app.get('/api/v1/items', (req, res) => {
  return res.json(itemList);
});

app.post('/api/v1/items', (req, res) => {
  let newItem = {
    id: itemList.length + 1,
    name: req.body.name,
  }
  itemList.push(newItem);
  res.status(201).json(newItem);
});

app.put('/api/v1/items/:id', (req, res) => {
  let itemId = +req.params.id;
  let updatedItem = {
    id: itemId,
    name: req.body.name
  };
  let index = itemList.findIndex(item => item.id === itemId);

  if (index !== -1) {
    itemList[index] = updatedItem;
    res.json(updatedItem);
  } else {
    res.status(404).json({ message: "Item not found" });
  }
});

app.delete('/api/v1/items/:id', (req, res) => {
  let itemId = +req.params.id;
  let index = itemList.findIndex(item => item.id === itemId);

  if (index !== -1) {
    let deletedItem = itemList.splice(index, 1);
    res.json(deletedItem[0]);
  } else {
    res.status(404).json({ message: "Item not found" });
  }
});

//listener
app.listen(port, () => {
  console.log(`Listening on port ${port}`);
});
