# PM2 Ecosystem Configuration
# This file can be used for advanced PM2 configuration
# Usage: pm2 start ecosystem.config.js

module.exports = {
  apps: [{
    name: 'micorCourses-backend',
    script: 'src/server.js',
    instances: 1, // Use 'max' for cluster mode
    exec_mode: 'fork', // 'fork' or 'cluster'
    watch: false,
    max_memory_restart: '500M',
    env: {
      NODE_ENV: 'production',
      PORT: 4001
    },
    error_file: './logs/pm2-error.log',
    out_file: './logs/pm2-out.log',
    log_file: './logs/pm2-combined.log',
    time: true,
    autorestart: true,
    max_restarts: 10,
    min_uptime: '10s',
    listen_timeout: 10000,
    kill_timeout: 5000,
    wait_ready: true,
    instance_var: 'INSTANCE_ID'
  }]
};

