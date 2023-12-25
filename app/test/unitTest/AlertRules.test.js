import 'dotenv/config.js';
import path from 'path';
import { test, describe, expect, beforeAll, afterAll } from 'vitest';
import fastify from 'fastify';
import postgres from '@fastify/postgres';
import * as AlertModels from '../../utils/AlertRules.js';
import runCommand from '../initTestDatabase/initTestData.js';

describe('Alert model functions test', () => {
  let client;
  beforeAll(async () => {
    // get the absolute path for the sql file
    const filePath = path.join(process.cwd(), 'test/initTestDatabase/personal_project_test_2023-12-24.sql');

    // initialize test database
    await runCommand(filePath, process.env.POSTGRESQL_PASSWORD);

    const app = fastify();
    const { POSTGRESQL_HOST, POSTGRESQL_USER, POSTGRESQL_PASSWORD, POSTGRESQL_PORT } = process.env;
    const ssl = {
      rejectUnauthorized: false, // Set to false if you want to bypass server certificate validation
    };
    const connectionString = `postgresql://${POSTGRESQL_USER}:${POSTGRESQL_PASSWORD}@${POSTGRESQL_HOST}:${POSTGRESQL_PORT}/personal_project_test`;
    await app.register(postgres, { connectionString, ssl });
    client = await app.pg.connect();
  });

  afterAll(async () => {
    await client.release();
  });

  test('getIssues (return right object properties)', async () => {
    const projectId = 7;
    const res = await AlertModels.getIssues(client, projectId);

    expect(res).toBeInstanceOf(Array);
    res.forEach(el => {
      expect(el).toBeInstanceOf(Object);
      expect(el).toHaveProperty('issue');
      expect(el).toHaveProperty('users_num');
      expect(el).toHaveProperty('event_num');
      expect(typeof el.issue).toBe('string');
      expect(typeof el.event_num).toBe('string');
      expect(typeof el.users_num).toBe('string');
    });
  });

  test('getIssues (return empty array when no data)', async () => {
    const projectId = -1;
    const res = await AlertModels.getIssues(client, projectId);

    expect(res).toBeInstanceOf(Array);
  });
});
