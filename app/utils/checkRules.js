import fp from 'fastify-plugin';
import * as AlertModels from './AlertRules';

const checkRulesPlugin = fp(async fastify => {
  fastify.decorate('checkRules', async (client, ruleId) => {
    const alert = await AlertModels.getAlertRule(client, ruleId);
    const { filter, action_interval: actionInterval, project_id: projectId } = alert;
    const triggers = await AlertModels.getTriggers(client, ruleId);

    const issuesInterval = await AlertModels.getIssues(client, +projectId, actionInterval);
    let isFire = false;
    for (let i = 0; i < triggers.length; i++) {
      if (+triggers[i].trigger_type_id === 1) {
        if (issuesInterval.issue.length > 0) isFire = true;
      } else {
        const t = await AlertModels.getIssues(client, +projectId, triggers[i].time_window);
        if (t.find(el => +el.event_num > +triggers[i].threshold)) isFire = true;
      }

      if (filter === 'any') break;
    }

    return isFire;
  });
});

export default checkRulesPlugin;
