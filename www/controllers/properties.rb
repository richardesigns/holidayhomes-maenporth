module WWW
  class PropertiesController < BaseController
    render_defaults[:dir] += '/properties'

    get '/for-rent' do
      @properties = Estate.for_rent
      render :'all-for-rent'
    end

    get '/for-sale' do
      @properties = Estate.for_sale
      render :'all-for-sale'
    end

    get '/:id/for-rent' do |id|
      @property = Estate.fetch(id) do
        not_found
        halt
      end
      # TODO Belongs in View/Page object
      if @property.enquiry_route == 'agent'
        @enquiry_location =  @property.enquiry_link
      else
        @enquiry_location = "/properties/#{@property.id}/enquire"
      end
      render :'for-rent'
    end

    get '/:id/for-sale' do |id|
      @property = Estate.fetch(id) do
        not_found
        halt
      end
      render :'for-sale'
    end

    get '/:id/enquire' do |id|
      @property = Estate.fetch(id) do
        not_found
        halt
      end
      render :enquire
    end
    #
    # patch '/:id/sale-profile' do |id|
    #   # TODO test
    #   @property = Estate.fetch(id) do
    #     not_found
    #     halt
    #   end
    #   form = PropertySaleForm.new request.POST['property']
    #   @property.update form
    #   @property.save
    #   render :'edit-sale-profile'
    # end
    #
    # patch '/:id/rent-profile' do |id|
    #   # TODO test
    #   @property = Estate.fetch(id) do
    #     not_found
    #     halt
    #   end
    #   form = PropertyRentForm.new request.POST['property']
    #   @property.update form
    #   @property.save
    #   render :'edit-rent-profile'
    # end
    #
    # patch '/:id/status' do |id|
    #   # TODO test
    #   @property = Estate.fetch(id) do
    #     not_found
    #     halt
    #   end
    #   form = PropertyStatusForm.new request.POST['property']
    #   @property.update form
    #   redirect('/properties')
    # end
    #
    # delete '/:id' do |id|
    #   piece = Estate.fetch(id) do
    #     not_found
    #     halt
    #   end
    #   piece.destroy
    #   redirect '/properties'
    # end

    def not_found
      response.status = 404
    end

  end
end
