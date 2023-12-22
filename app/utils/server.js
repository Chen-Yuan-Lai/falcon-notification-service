import fastify from 'fastify';
import postgres from '@fastify/postgres';
import checkRulesPlugin from './checkRules.js';

export default function createServer() {
  const app = fastify({
    logger: true,
  });

  const { POSTGRESQL_HOST, POSTGRESQL_USER, POSTGRESQL_DATABASE, POSTGRESQL_PASSWORD, POSTGRESQL_PORT } = process.env;

  const ssl = {
    rejectUnauthorized: false, // Set to false if you want to bypass server certificate validation
  };

  const connectionString = `postgresql://${POSTGRESQL_USER}:${POSTGRESQL_PASSWORD}@${POSTGRESQL_HOST}:${POSTGRESQL_PORT}/${POSTGRESQL_DATABASE}`;

  app.register(postgres, { connectionString, ssl });
  app.register(checkRulesPlugin);
  return app;
}
