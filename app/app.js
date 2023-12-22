import 'dotenv/config.js';
import createServer from './utils/server.js';
import { disconnectConsumer, connectConsumer } from './utils/kafka.js';
import sendNotification from './utils/sendNotification.js';
import * as AlertModels from './utils/AlertRules.js';

const PORT = process.env.PORT;

async function gracefulShutdown(app) {
  console.log('Graceful shutdown');

  await app.close();
  await disconnectConsumer();

  process.exit(1);
}

async function main() {
  const app = await createServer();

  const emitter = await connectConsumer('notification');
  emitter.on('message', async ruleId => {
    const client = await app.pg.connect();
    try {
      if (await app.checkRules(client, ruleId)) {
        const tokens = await AlertModels.getTokens(client, ruleId);
        await AlertModels.createAlertHistory(client, ruleId);
        await sendNotification('出事了阿伯', tokens);
      }
    } catch (err) {
      console.error(err);
    }
  });

  app.listen({
    port: PORT,
  });

  const signals = ['SIGINT', 'SIGTERM', 'SIGQUIT'];

  signals.forEach(signal => {
    process.on(signal, () => gracefulShutdown(app));
  });

  console.log(`Notification service ready at http://localhost:${PORT}`);
}

main();
