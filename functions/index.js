/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

const functions = require('firebase-functions');
const axios = require('axios');

exports.proxyRequest = functions.https.onRequest((req, res) => {
    const url = req.query.url || req.body.url;
  
    if (!url) {
      res.status(400).send('URL parameter is required');
      return;
    }
  
    axios.get(url)
      .then(response => {
        res.set('Access-Control-Allow-Origin', '*');
        res.json(response.data);
      })
      .catch(error => {
        res.status(500).send(error);
      });
  });
