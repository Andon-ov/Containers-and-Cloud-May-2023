const express = require('express');
require('dotenv').config();
const port = process.env.PORT || "8000";
require('./models/users.model')
const usersRoute = require('./routes/routes.js');

const app = express();
app.use(express.urlencoded({ extended: false }));
app.use(express.json());

//connecting to mongo databse
const mongoose = require('mongoose');

const dbURI = process.env.DB_URI;

module.exports.connection = mongoose
	.connect(dbURI, {
		useNewUrlParser: true,
		useUnifiedTopology: true,
	})
	.then(() => console.log("Database Connected"))
	.catch((err) => console.log(err));

//using connect-mongo and express session to store user sessions which is used by passport for authentication
const MongoStore = require('connect-mongo');

const session = require('express-session');
  
app.use(session({
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  store: MongoStore.create({mongoUrl: process.env.DB_URI})
}))

//initializing passport
var passport = require('passport');

require('./config/passport-config');
app.use(passport.initialize());
app.use(passport.session());

app.use('/', usersRoute);

module.exports = app;

app.listen(port, () => {
    console.log(`Listening to requests on http://localhost:${port}`);
  });