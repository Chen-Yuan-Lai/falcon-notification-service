import { exec } from 'child_process';

const execShellCommend = async (cmd, env) => {
  const p = new Promise((resolve, reject) => {
    exec(cmd, { env }, (error, stdout, stderr) => {
      if (error) {
        reject(error);
      } else {
        resolve({ stdout, stderr });
      }
    });
  });

  return p;
};

const runCommand = async (filePath, password) => {
  const command = `psql -h localhost -p 5432 -U postgres -f ${filePath}`;
  const env = { ...process.env, PGPASSWORD: password };
  const { stdout } = await execShellCommend(command, env);
  // The command has completed, you can do the next thing here
  console.log('initialize completed.');
};

export default runCommand;
