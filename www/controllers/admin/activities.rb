module WWW
  module Admin
    class ActivitiesController < BaseController
      # In the future this might make more sense to be relative to some admin root
      render_defaults[:dir] += '/admin/leisure'

      get '/' do
        @categories = Activity::Category.all.map do |c|
          [c, Activity.send("#{c.name.downcase}_activities")]
        end
        render :index
      end

      get '/offers' do
        @offers = Offer::Record.all
        render :offers_index
      end

      get '/new' do
        # DEBT sets values
        @activity = Activity::Record.create(:category => "", activity_name: "")
        render :edit
      end

      # post '/' do
      #   # DEBT not used
      #   activity = Activity::Record.create()
      #   redirect "/#{activity.id}"
      # end

      get '/:id/edit' do |id|
        @activity = Activity::Record.find(id: id)
        if @activity
          render :edit
        else
          not_found
        end
      end

      patch '/:id' do |id|
        @activity = Activity::Record.find(id: id)
        if @activity
          updates = request.POST.clone
          updates.delete("_method") # Mutable Eurgh DEBT
          updates["hidden"] = (updates["hidden"] == "on")
          updates["hide_gallery"] = (updates["hide_gallery"] == "on")
          updates["main_description"] = Description.new(updates["main_description"])
          @activity.update(updates)
          redirect '/admin/leisure'
          # Probably redirect somewhere
        else
          not_found
        end
      end

      delete '/:id' do |id|
        activity = Activity::Record.find(id: id)
        if activity
          offers = Offer::Record.where(activity: activity)
          offers.destroy
          activity.destroy
          redirect '/admin/leisure'
        else
          not_found
        end
      end

      def not_found
        response.status = 404
      end
    end
  end
end
