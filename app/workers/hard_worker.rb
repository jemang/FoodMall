class HardWorker
  include Sidekiq::Worker

  def perform(days)
  	template = Template.where("day = '#{days}'")
  	template.each do |temp|
     order = Orderitem.new
     order.quantity = temp.quantity
     order.note = temp.note
     order.total = temp.total
     order.status = temp.status
     order.item_id = temp.item_id
     order.user_id = temp.user_id
     order.runner_id = temp.runner_id
     order.chef_id = temp.chef_id
     order.dtime = temp.dtime
     order.current_user_id = temp.user_id
     order.save!
     sleep 2
    end
  end

end
