# Sidekiq Scheldule test

## Setup

	$ docker-compose up
	$ bundle exec rackup -p 8808

  Redis Comander: http://localhost:8081

  Sidekiq web: http://localhost:8808

## Server

	$ bundle exec sidekiq -q default -q reports -r ./sidekiq_server.rb

## Client

	$ bundle console
	irb(main):001:0> require_relative './sidekiq_client'

## Raise Jobs
  [Review Workers](https://github.com/malotor/sidekiq_demo/blob/master/workers.rb)

	Worker.perform_async('Manel')
  
	Worker.perform_in(60, 'Manel', 'random')

  http://localhost:8808/scheduled

## Errors

	Worker.perform_async('Manel', 'error')

  http://localhost:8808/scheduled

  http://localhost:8808/retries

## Queues

	20.times {|i| Worker.perform_async('Manel', 'random')}

  http://localhost:8808/busy

  http://localhost:8808/queues/default

## Scheduler

	Sidekiq.set_schedule('scheduled_worker', { 'every' => ['1m'], 'class' => 'Worker', 'args' => ['Manel', 'random'] })

  http://localhost:8808/recurring-jobs

## API

### Setup
	require 'sidekiq/api'

### Queues
	Sidekiq::Queue.all
	reports = Sidekiq::Queue.new("default")

### Jobs in queue
	20.times {|i| Worker.perform_async('Manel', 'hard')}
	default = Sidekiq::Queue.new("default")
	default.size
	default.each {|j| puts j.inspect }

### Delete jobs
	job_id = '2a00a99f81f99dd82604ffd2'
	default.each {|j| j.delete } if j.jid == job_id
	default.find_job(job_id)

### Clear queues
	default.clear

### Scheduled Set
	ss = Sidekiq::ScheduledSet.new
	ss.each {|j| puts j.inspect }

### Retry Set
	rs = Sidekiq::RetrySet.new
	Sidekiq::RetrySet.new.each {|j| puts j.inspect }
	Sidekiq::RetrySet.new.clear

### Dead Set
	ds = Sidekiq::DeadSet.new
	ds.each {|j| puts j.inspect }

### ProcessSet
	ps = Sidekiq::ProcessSet.new
	ps.each(&:quiet)
	ps.each(&:stop)

### Workers
	workers = Sidekiq::Workers.new
	workers.each {|w| puts w.inspect }

### Stats
	Sidekiq::Stats.new

### Scheduler
	Sidekiq.get_schedule
	Sidekiq.get_all_schedules.each { |s| s.inspect }

# Signals

	$ ps ax | grep sidekiq
	23518 s002  S+     0:01.35 sidekiq 5.2.2  [0 of 10 busy]
	$ kill -TTIN 23518
	$ kill -USR1 23518
	$ kill -TERM 23518  
	$ sidekiqctl stop ~/tmp/sidekiq.pid