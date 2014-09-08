# https://github.com/defunkt/unicorn
working_directory "/home/daniel/develop/ccarter/appointments"
pid "/home/daniel/develop/ccarter/appointments/tmp/pids/unicorn.pid"
stderr_path "/home/daniel/develop/ccarter/appointments/log/unicorn.stderr.log"
stdout_path "/home/daniel/develop/ccarter/appointments/log/unicorn.stdout.log"

listen "/tmp/sockets/unicorn.sock"
worker_processes 2
timeout 30
