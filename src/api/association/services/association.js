'use strict';

/**
 * association service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::association.association');
