# Eye self-configuration section
Eye.config do
  logger '/home/system/FoodMall/log/eye.log'
end

# Adding application
Eye.application 'FoodMall' do
  # All options inherits down to the config leafs.
  # except `env`, which merging down

  # uid "user_name" # run app as a user_name (optional) - available only on ruby >= 2.0
  # gid "group_name" # run app as a group_name (optional) - available only on ruby >= 2.0

  working_dir File.expand_path(File.join(File.dirname(__FILE__), %w[ .. ]))
  stdall 'log/trash.log' # stdout,err logs for processes by default
  env 'APP_ENV' => 'development' # global env for each processes
  trigger :flapping, times: 10, within: 1.minute, retry_in: 10.minutes
  check :cpu, every: 10.seconds, below: 100, times: 3 # global check for all processes

 # puma process, self daemonized
  process :puma do
    pid_file 'tmp/pids/server.pid'
    start_command 'puma -C config/puma.rb -p 8000 --pidfile tmp/pids/server.pid -d'
    stop_signals [:QUIT, 10.seconds, :TERM, 5.seconds, :KILL]

#    check :http, url: 'http://127.0.0.1:8000',
 #                every: 60.seconds, times: [2, 3], timeout: 10.second
  end

 # redis process, self daemonized
    process :redis do
      pid_file 'tmp/pids/redis-server.pid'
      start_command 'redis-server config/redis.conf'
      stop_command 'redis-cli shutdown'

      # ensure the memory is below 300Mb the last 3 times checked
      check :memory, every: 20.seconds, below: 300.megabytes, times: 3
  end
end
