
module OrderCron

  def self.cron_job
    @days = Date.today.strftime("%A").downcase
    HardWorker.perform_async(@days)
  end

end