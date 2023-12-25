export const createEvent = async (client, eventData) => {
  const {
    userId,
    projectId,
    name,
    message,
    stack,
    osType,
    osRelease,
    architecture,
    nodeVersion,
    rss,
    heapTotal,
    heapUsed,
    external,
    arrayBuffers,
    uptime,
    timestamp,
    fingerprints,
    workspacePath,
  } = eventData;
  const query = {
    text: `INSERT INTO events(
          user_id, 
          project_id,
          name,
          message,
          stack,
          os_type,
          os_release,
          architecture,
          version,
          mem_rss,
          mem_heap_total,
          mem_heap_used,
          mem_external,
          mem_array_buffers,
          up_time,
          created_at,
          fingerprints,
          work_space_path
          ) VALUES($1, $2, $3, $4, $5, $6,$7, $8, $9,$10, $11, $12, $13, $14, $15,$16, $17, $18) RETURNING *`,
    values: [
      userId,
      projectId,
      name,
      message,
      stack,
      osType,
      osRelease,
      architecture,
      nodeVersion,
      rss,
      heapTotal,
      heapUsed,
      external,
      arrayBuffers,
      uptime,
      timestamp,
      fingerprints,
      workspacePath,
    ],
  };

  const res = await client.query(query);
  return res.rows[0];
};

export const createAlert = async (client, projectId, filter, actionInterval, name, active) => {
  const query = {
    text: `INSERT INTO alert_rules(project_id,filter, action_interval, name, active)
          VALUES($1, $2, $3, $4, $5) RETURNING *`,
    values: [projectId, filter, actionInterval, name, active],
  };

  const res = await client.query(query);
  return res.rows[0];
};

export const createChannels = async (client, ruleId, channels) => {
  const modifyChannels = channels.flatMap(el => [ruleId, el.userId, el.type, el.token]);

  const placeholders = channels
    .map((_, index) => `($${index * 4 + 1}, $${index * 4 + 2}, $${index * 4 + 3}, $${index * 4 + 4})`)
    .join(', ');
  const queryText = `INSERT INTO channels(rule_id, user_id, type, token) VALUES ${placeholders} RETURNING *`;
  const res = await client.query(queryText, modifyChannels);

  return res.rows;
};

export const createTriggers = async (client, ruleId, triggers) => {
  const modifyTriggers = triggers.flatMap(el => {
    const trigger = [ruleId, el.triggerTypeId];
    if (el.triggerTypeId === 1) {
      trigger.push(null, null);
    } else {
      trigger.push(el.threshold, el.timeWindow);
    }
    return trigger;
  });
  const placeholders = triggers
    .map((_, index) => `($${index * 4 + 1}, $${index * 4 + 2}, $${index * 4 + 3}, $${index * 4 + 4})`)
    .join(', ');
  const queryText = `INSERT INTO triggers(rule_id, trigger_type_id, threshold, time_window) VALUES ${placeholders} RETURNING *`;
  const res = await client.query(queryText, modifyTriggers);

  return res.rows;
};
