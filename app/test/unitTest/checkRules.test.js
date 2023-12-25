import { test, describe, expect, afterEach, beforeEach, vi } from 'vitest';
import fastify from 'fastify';
import checkRulesPlugin from '../../utils/checkRules.js';
import * as AlertModels from '../../utils/AlertRules.js';

vi.mock('../../utils/AlertRules.js', () => ({
  getAlertRule: vi.fn(),
  getTriggers: vi.fn(),
  getIssues: vi.fn(),
}));

describe('checkRules test (interval: 1m, filter: all)', () => {
  let app;
  beforeEach(async () => {
    app = fastify();
    await app.register(checkRulesPlugin);

    AlertModels.getAlertRule.mockImplementation((client, ruleId) =>
      Promise.resolve({
        id: 1,
        project_id: '1',
        filter: 'all',
        action_interval: '1m',
        name: 'demo alert',
        active: true,
        created_at: '2023-12-09 14:01:40.657165+08',
        delete: false,
      }),
    );
  });
  afterEach(async () => {
    await app.close();
    AlertModels.getTriggers.mockClear();
  });

  test('1 trigger, no issue, no hit', async () => {
    AlertModels.getTriggers.mockImplementation((client, ruleId) =>
      Promise.resolve([
        {
          id: 1,
          rule_id: '1',
          trigger_type_id: '1',
          threshold: null,
          time_window: null,
        },
      ]),
    );
    AlertModels.getIssues.mockImplementation((client, projectId, time_window) => Promise.resolve([]));

    const client = '';
    const ruleId = 1;
    expect(await app.checkRules(client, ruleId)).toBe(false);

    AlertModels.getIssues.mockClear();
    AlertModels.getIssues.mockClear();
  });

  test('1 trigger, 1 hit', async () => {
    AlertModels.getTriggers.mockImplementation((client, ruleId) =>
      Promise.resolve([
        {
          id: 1,
          rule_id: '1',
          trigger_type_id: '1',
          threshold: null,
          time_window: null,
        },
      ]),
    );
    AlertModels.getIssues.mockImplementation((client, projectId, time_window) =>
      Promise.resolve([
        {
          issue: '3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=',
          users_num: '3',
          event_num: '4',
        },
      ]),
    );

    const client = '';
    const ruleId = 1;
    expect(await app.checkRules(client, ruleId)).toBe(true);

    AlertModels.getIssues.mockClear();
    AlertModels.getIssues.mockClear();
  });

  test('1 trigger (id = 2), no issue,no hit', async () => {
    AlertModels.getTriggers.mockImplementation((client, ruleId) =>
      Promise.resolve([
        {
          id: 1,
          rule_id: '1',
          trigger_type_id: '2',
          threshold: '5',
          time_window: '1m',
        },
      ]),
    );
    AlertModels.getIssues.mockImplementation((client, projectId, time_window) =>
      Promise.resolve([
        {
          issue: '3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=',
          users_num: '3',
          event_num: '4',
        },
      ]),
    );

    const client = '';
    const ruleId = 1;
    expect(await app.checkRules(client, ruleId)).toBe(false);

    AlertModels.getIssues.mockClear();
    AlertModels.getIssues.mockClear();
  });

  test('1 trigger (id =2), 1 issue, no hit', async () => {
    AlertModels.getTriggers.mockImplementation((client, ruleId) =>
      Promise.resolve([
        {
          id: 1,
          rule_id: '1',
          trigger_type_id: '2',
          threshold: '5',
          time_window: '1m',
        },
      ]),
    );
    AlertModels.getIssues.mockImplementation((client, projectId, time_window) =>
      Promise.resolve([
        {
          issue: '3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=',
          users_num: '5',
          event_num: '4',
        },
      ]),
    );

    const client = '';
    const ruleId = 1;
    expect(await app.checkRules(client, ruleId)).toBe(false);

    AlertModels.getIssues.mockClear();
    AlertModels.getIssues.mockClear();
  });

  test('1 trigger (id = 2), 2+ issues, no hit', async () => {
    AlertModels.getTriggers.mockImplementation((client, ruleId) =>
      Promise.resolve([
        {
          id: 1,
          rule_id: '1',
          trigger_type_id: '2',
          threshold: '5',
          time_window: '1m',
        },
      ]),
    );
    AlertModels.getIssues.mockImplementation((client, projectId, time_window) =>
      Promise.resolve([
        {
          issue: '3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=',
          users_num: '5',
          event_num: '4',
        },
        {
          issue: ' KVhDGJff9qSfASXRAYjbqgWW3gDwaf21goOI6CggTOY=',
          users_num: '4',
          event_num: '4',
        },
        {
          issue: 'nF8CIvO9OkV8aSxvbCZgVJnVlPVj/JOQlWr3opj4/Pk=',
          users_num: '3',
          event_num: '4',
        },
      ]),
    );

    const client = '';
    const ruleId = 1;
    expect(await app.checkRules(client, ruleId)).toBe(false);

    AlertModels.getIssues.mockClear();
    AlertModels.getIssues.mockClear();
  });

  test('1 trigger (id = 2), 2+ issues, hit', async () => {
    AlertModels.getTriggers.mockImplementation((client, ruleId) =>
      Promise.resolve([
        {
          id: 1,
          rule_id: '1',
          trigger_type_id: '2',
          threshold: '5',
          time_window: '1m',
        },
      ]),
    );
    AlertModels.getIssues.mockImplementation((client, projectId, time_window) =>
      Promise.resolve([
        {
          issue: '3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=',
          users_num: '2',
          event_num: '6',
        },
        {
          issue: ' KVhDGJff9qSfASXRAYjbqgWW3gDwaf21goOI6CggTOY=',
          users_num: '6',
          event_num: '6',
        },
        {
          issue: 'nF8CIvO9OkV8aSxvbCZgVJnVlPVj/JOQlWr3opj4/Pk=',
          users_num: '6',
          event_num: '6',
        },
      ]),
    );

    const client = '';
    const ruleId = 1;
    expect(await app.checkRules(client, ruleId)).toBe(true);

    AlertModels.getIssues.mockClear();
    AlertModels.getIssues.mockClear();
  });

  test('1 trigger (id = 3), 2+ issues, hit', async () => {
    AlertModels.getTriggers.mockImplementation((client, ruleId) =>
      Promise.resolve([
        {
          id: 1,
          rule_id: '1',
          trigger_type_id: '3',
          threshold: '5',
          time_window: '1m',
        },
      ]),
    );
    AlertModels.getIssues.mockImplementation((client, projectId, time_window) =>
      Promise.resolve([
        {
          issue: '3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=',
          users_num: '5',
          event_num: '6',
        },
        {
          issue: ' KVhDGJff9qSfASXRAYjbqgWW3gDwaf21goOI6CggTOY=',
          users_num: '6',
          event_num: '6',
        },
        {
          issue: 'nF8CIvO9OkV8aSxvbCZgVJnVlPVj/JOQlWr3opj4/Pk=',
          users_num: '6',
          event_num: '6',
        },
      ]),
    );

    const client = '';
    const ruleId = 1;
    expect(await app.checkRules(client, ruleId)).toBe(true);

    AlertModels.getIssues.mockClear();
    AlertModels.getIssues.mockClear();
  });
});
