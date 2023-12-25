import fp from 'fastify-plugin';
import * as AlertModels from './AlertRules.js';

const checkRulesPlugin = fp(async fastify => {
  fastify.decorate('checkRules', async (client, ruleId) => {
    const alert = await AlertModels.getAlertRule(client, ruleId);
    const { filter, action_interval: actionInterval, project_id: projectId } = alert;
    const triggers = await AlertModels.getTriggers(client, ruleId);

    const issuesInterval = await AlertModels.getIssues(client, +projectId, actionInterval);
    const hitCount = new Array(4).fill(0);
    for (let i = 0; i < triggers.length; i += 1) {
      const triggerId = Number(triggers[i].trigger_type_id);
      const threshold = Number(triggers[i].threshold);
      const issuesByTrigger = await AlertModels.getIssues(client, +projectId, triggers[i].time_window);
      const checkThreshold = type => issuesByTrigger.find(el => Number(el[type]) > threshold);

      if (triggerId === 1 && issuesInterval.length > 0) hitCount[1] += 1;
      if (triggerId === 2 && Boolean(checkThreshold('event_num'))) hitCount[2] += 1;
      if (triggerId === 3 && Boolean(checkThreshold('users_num'))) hitCount[3] += 1;
    }
    const countSum = hitCount.reduce((acc, curr) => acc + curr, 0);
    if (countSum === triggers.length && filter === 'all') return true;
    if (countSum <= triggers.length && filter === 'any') return true;
    return false;
  });
});

export default checkRulesPlugin;
