require 'sidekiq'

class Worker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(name, type = nil)
    case type
    when 'error'
      raise 'Error!!!!!'
    when 'random'
      n = rand(50)
      sleep(n)
      puts "#{name} has worked #{n}s"
    when 'looper'
      while true do
        sleep(5)
        puts "#{name} is still working :("
      end
    when 'hard'
      sleep(50)
      puts "#{name} has worked 60s"
    else
      sleep(10)
      puts "NO CHANGE #{name} has worked 10s"
    end
  end
end

class Report
  include Sidekiq::Worker
  sidekiq_options retry: 0
  sidekiq_options queue: 'reports'

  def perform
    puts "Generating report ..."
    sleep(10)
    puts "Report generated!"
  end
end