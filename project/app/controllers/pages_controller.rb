class PagesController < ApplicationController
  def levelup
    Subscriber.create!(email: params[:email])

    redirect_to_back notice: "Thanks! &nbsp;You have been added to the list."
  end
end
