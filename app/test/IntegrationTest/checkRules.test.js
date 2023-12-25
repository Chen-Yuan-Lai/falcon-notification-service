import 'dotenv/config.js';
import path from 'path';
import { test, describe, expect, beforeAll, afterAll } from 'vitest';
import fastify from 'fastify';
import postgres from '@fastify/postgres';
import * as TestModel from '../initTestDatabase/testModels.js';
import checkRulesPlugin from '../../utils/checkRules.js';
import runCommand from '../initTestDatabase/initTestData.js';

describe('Integration test for checkRules', () => {
  let app;
  let eventData;
  let channels;

  beforeAll(async () => {
    try {
      // get the absolute path for the sql file
      const filePath = path.join(process.cwd(), 'test/initTestDatabase/personal_project_test_2023-12-24.sql');

      // initialize test database
      await runCommand(filePath, process.env.POSTGRESQL_PASSWORD);

      app = fastify();
      const { POSTGRESQL_HOST, POSTGRESQL_USER, POSTGRESQL_PASSWORD, POSTGRESQL_PORT } = process.env;
      const ssl = {
        rejectUnauthorized: false, // Set to false if you want to bypass server certificate validation
      };
      const connectionString = `postgresql://${POSTGRESQL_USER}:${POSTGRESQL_PASSWORD}@${POSTGRESQL_HOST}:${POSTGRESQL_PORT}/personal_project_test`;
      await app.register(checkRulesPlugin);
      await app.register(postgres, { connectionString, ssl });

      eventData = {
        userId: 3,
        projectId: 7,
        name: 'Error',
        message: 'hii is not defined',
        stack: 'ReferenceError: hii is not defined\napp.js:98:1\node:internal/process/task_queues:95:5',
        osType: 'Linux',
        osRelease: '5.15.133.1-microsoft-standard-WSL2',
        architecture: 'x64',
        nodeVersion: 'v20.9.0',
        rss: 71131136,
        heapTotal: 18059264,
        heapUsed: 11147680,
        external: 4041474,
        arrayBuffers: 73038,
        uptime: 2611,
        timestamp: new Date().toUTCString(),
        fingerprints: 'KVhDGJff9qSfASXRAYjbqgyy4gDwaf21goOI6CggTOX=',
        workspacePath: '/home/ian/appWorkSchool/targetProject',
      };

      channels = [
        {
          userId: 3,
          type: 'line',
          token: '9Idjs8pouWobptIvBmMYzgSF0xEH2iea6VByh7mCrbu',
        },
      ];
    } catch (err) {
      console.error(err);
    }
  });

  test('trigger the alert when a new issue is created', async () => {
    const client = await app.pg.connect();
    try {
      const triggers = [
        {
          triggerTypeId: 1,
          threshold: null,
          timeWindow: null,
        },
      ];
      await TestModel.createEvent(client, eventData);
      const { id } = await TestModel.createAlert(client, 7, 'any', '1m', 'test alert', true);
      await TestModel.createTriggers(client, id, triggers);
      await TestModel.createChannels(client, id, channels);

      const isFire = await app.checkRules(client, id);

      expect(isFire).toBe(true);
    } catch (err) {
      console.error(err);
    } finally {
      client.release();
    }
  });

  test('trigger the alert when a issue occurred times > 5 from past 10 mins', async () => {
    const client = await app.pg.connect();
    try {
      const triggers = [
        {
          triggerTypeId: 2,
          threshold: 5,
          timeWindow: '10m',
        },
        {
          triggerTypeId: 2,
          threshold: 6,
          timeWindow: '10m',
        },
        {
          triggerTypeId: 2,
          threshold: 7,
          timeWindow: '10m',
        },
      ];
      const promises = new Array(6).fill(null).map(() => TestModel.createEvent(client, eventData));
      await Promise.all(promises);

      const { id } = await TestModel.createAlert(client, 7, 'any', '1m', 'test alert2', true);
      await TestModel.createTriggers(client, id, triggers);
      await TestModel.createChannels(client, id, channels);

      const isFire = await app.checkRules(client, id);

      expect(isFire).toBe(true);
    } catch (err) {
      console.error(err);
    } finally {
      client.release();
    }
  });
});
