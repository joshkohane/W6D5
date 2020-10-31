class CatRentalRequestsController < ApplicationController
    def new
        @request = CatRentalRequest.new
        render :new
    end

    def create
        @request = CatRentalRequest.new(requests_params)
        if @request.save
            redirect_to cat_url(@request.cat)
        else
            render :new
        end
    end

    def requests_params
        params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date, :status)
    end
end