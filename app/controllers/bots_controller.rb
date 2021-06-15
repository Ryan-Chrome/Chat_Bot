class BotsController < ApplicationController
  include CountersHelper
  include YoutubesHelper
  include ApplicationHelper

  before_action :change_operator, only: [:counter_callback, :youtube_search_callback, :youtube_list_callback]

  def index
    if params[:input].present?
      sorting_operation(params[:input])
      respond_to do |format|
        if @operator.present?
          if @operator == "counter"
            format.js { render "counter_operation" }
          elsif @operator == "youtube"
            format.js { render "youtube_search_operation" }
          end
        else
          format.js
        end
      end
    end
  end

  def counter_callback
    counter_interpretation(params[:input])
    respond_to do |format|
      format.js
    end
  end

  def youtube_search_callback
    if params[:video_id].present?
      youtube_search(params[:input], params[:video_id])
    else
      youtube_search(params[:input], false)
    end
    respond_to do |format|
      if @mode == "search"
        format.js
      elsif @mode == "playlist"
        format.js { render "youtube_list_callback" }
      end
    end
  end

  def youtube_list_callback
    youtube_list(params[:input])
    respond_to do |format|
      if @mode == "search"
        format.js { render "youtube_search_callback" }
      elsif @mode = "playlist"
        format.js
      end
    end
  end

  private
    def change_operator
      if params[:input].gsub!(/[[:space:]]/, '') == "オペレーター変更"
        respond_to do |format|
          format.js { render "change_operator" }
        end
      end
    end
end
