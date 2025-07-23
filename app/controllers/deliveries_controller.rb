class DeliveriesController < ApplicationController
  def index
    matching_deliveries = Delivery.all
    @list_of_deliveries = matching_deliveries.order({ :created_at => :desc })
    render({ :template => "deliveries/index" })
  end

 def show
  the_id = params.fetch("path_id")
  @the_delivery = Delivery.find_by(id: the_id)

  if @the_delivery.nil?
    redirect_to("/deliveries", alert: "Delivery not found.")
  else
    render({ :template => "deliveries/show" })
  end
end


def create
  the_delivery = Delivery.new
  the_delivery.description = params.fetch("query_description")
  the_delivery.expected_on = params.fetch("query_expected_on")
  the_delivery.details = params.fetch("query_details", "")
  the_delivery.received = false
  the_delivery.user_id = current_user.id  # assign current user here

  if the_delivery.valid?
    the_delivery.save
    redirect_to("/deliveries", { notice: "Added to list" })
  else
    redirect_to("/deliveries", { alert: the_delivery.errors.full_messages.to_sentence })
  end
end



def update
  the_id = params.fetch("path_id")
  the_delivery = Delivery.find_by(id: the_id)

  if the_delivery.nil?
    redirect_to("/deliveries", alert: "Delivery not found.")
    return
  end

  # Only update the received status
  the_delivery.received = true

  if the_delivery.valid?
    the_delivery.save
    redirect_to("/deliveries", { notice: "Delivery updated successfully." })
  else
    redirect_to("/deliveries", { alert: the_delivery.errors.full_messages.to_sentence })
  end
end


def destroy
  the_id = params.fetch("path_id")
  the_delivery = Delivery.find_by(id: the_id)

  if the_delivery.nil?
    redirect_to("/deliveries", alert: "Delivery not found.")
  else
    the_delivery.destroy
    redirect_to("/deliveries", { :notice => "Delivery deleted successfully." })
  end
end

end
