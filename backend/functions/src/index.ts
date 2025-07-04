/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {setGlobalOptions} from "firebase-functions";
import {onRequest} from "firebase-functions/https";
import * as logger from "firebase-functions/logger";
import app from './app';

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });

/**
 * Main API function that handles all HTTP requests
 * Deployed to: https://us-central1-{project-id}.cloudfunctions.net/api
 */
export const api = onRequest(
  {
    cors: true,
    // Increase timeout for longer operations
    timeoutSeconds: 60,
    // Allocate more memory for better performance
    memory: '256MiB',
  },
  (req, res) => {
    // Log request for monitoring
    logger.info(`${req.method} ${req.url}`, {
      method: req.method,
      url: req.url,
      userAgent: req.get('User-Agent'),
      timestamp: new Date().toISOString(),
    });

    // Handle the request with our Express app
    app(req, res);
  }
);

/**
 * Health check function for monitoring
 * Deployed to: https://us-central1-{project-id}.cloudfunctions.net/health
 */
export const health = onRequest((req, res) => {
  res.status(200).json({
    success: true,
    message: 'WittyCar API is healthy',
    timestamp: new Date().toISOString(),
    version: '1.0.0',
  });
});

// Log deployment information
logger.info('WittyCar API Functions deployed successfully', {
  timestamp: new Date().toISOString(),
  environment: process.env.NODE_ENV || 'development',
});
