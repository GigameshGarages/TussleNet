const { Requester, Validator } = require('@chainlink/external-adapter')
const dotenv = require('dotenv');
dotenv.config();
// Define custom error scenarios for the API.
// Return true for the adapter to retry.
const customError = (data) => {
  if (data.Response === 'Error') return true
  return false
}


//Stormglass endpoint: https://api.stormglass.io/v2/tide/sea-level/point?lat={latitude}&lng={longitude}&start={start}&end={end} 

// Define custom parameters to be used by the adapter.
// Extra parameters can be stated in the extra object,
// with a Boolean value indicating whether or not they
// should be required.
const customParams = {
  latitude: ['lat', 'latitude'],
  longitude: ['lng', 'longitude'],
  endpoint: false
}

const createRequest = (input, callback) => {
  // The Validator helps you validate the Chainlink request data
  const validator = new Validator(callback, input, customParams)
  const jobRunID = validator.validated.id
  const endpoint = validator.validated.data.endpoint || 'point'
  const url = `https://api.stormglass.io/v2/tide/sea-level/${endpoint}`

  const lat = validator.validated.data.latitude
  const lng = validator.validated.data.longitude

  const apiKey = process.env.API_KEY;
  const today = new Date()
  const yesterday = new Date()
  yesterday.setDate(today.getDate() - 1)
  const todayString = today.toISOString().split('T')[0];
  const yesterdayString = yesterday.toISOString().split('T')[0];

  const params = {
    lat,
    lng,
    start: yesterdayString,
    end : todayString
  }

  const headers = {
    "Authorization": apiKey
  }

  const config = {
    url,
    params,
    headers
  }

  // The Requester allows API calls be retry in case of timeout
  // or connection failure
  Requester.request(config, customError)
    .then(response => {
      // It's common practice to store the desired value at the top-level
      // result key. This allows different adapters to be compatible with
      // one another.
      const sortedData = response.data.data.sort((a,b) => 
        { const aDate = new Date(a.time); const bDate = new Date(b.time); return bDate - aDate; } )
      response.data.data = sortedData;
      response.data.result = Requester.validateResultNumber(response.data, ['data','0','sg'])
      callback(response.status, Requester.success(jobRunID, response))
    })
    .catch(error => {
      callback(500, Requester.errored(jobRunID, error))
    })
}

// This is a wrapper to allow the function to work with
// GCP Functions
exports.gcpservice = (req, res) => {
  createRequest(req.body, (statusCode, data) => {
    res.status(statusCode).send(data)
  })
}

// This is a wrapper to allow the function to work with
// AWS Lambda
exports.handler = (event, context, callback) => {
  createRequest(event, (statusCode, data) => {
    callback(null, data)
  })
}

// This is a wrapper to allow the function to work with
// newer AWS Lambda implementations
exports.handlerv2 = (event, context, callback) => {
  createRequest(JSON.parse(event.body), (statusCode, data) => {
    callback(null, {
      statusCode: statusCode,
      body: JSON.stringify(data),
      isBase64Encoded: false
    })
  })
}

// This allows the function to be exported for testing
// or for running in express
module.exports.createRequest = createRequest
