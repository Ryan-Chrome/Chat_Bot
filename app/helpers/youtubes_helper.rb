module YoutubesHelper
  require 'google/apis/youtube_v3'

  def youtube_search(input, video_id)
    input.gsub!(/[[:space:]]/, '')
    len = input.length
    if input.include?("探して")
      word = input[len-len..len-4]
      @mode = "search"
      youtube_select(word)
    elsif input.include?("検索")
      word = input[len-len..len-3]
      @mode = "search"
      youtube_select(word)
    elsif video_id != false && input.include?("プレイリスト追加")
      len = input.length
      word = input[len-len..len-9]
      @mode = "search"
      youtube_add_playlist(video_id, word)
    elsif input == "プレイリスト"
      @mode = "playlist"
      @playlist = Playlist.all
    else
      @mode = "search"
      @text = "メッセージに対応できませんでした。"
    end
  end

  def youtube_list(input)
    input.gsub!(/[[:space:]]/, '')
    len = input.length
    if input.include?("削除")
      word = input[len-len..len-3]
      @mode = "playlist"
      playlist_destroy(word)
    elsif input == "閉じて"
      @mode = "search"
      @text = "YouTubeオペレーター(検索)です。「〇〇探して」で動画を取得してきます。「プレイリスト」でプレイリストを呼び出します。"
    else
      @mode = "playlist"
      playlist_play(input)
    end
  end

  def youtube_select(input)
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.key = ENV['API_KEY']
    options = {
      :order => "viewCount",
      :type => "video",
      :max_results => 10,
      :q => "#{input}"
    }
    youtube_search_list = youtube.list_searches(:snippet, options)
    random = Random.new
    random_number = random.rand(0..youtube_search_list.items.length - 1)
    youtube_title = youtube_search_list.items[random_number].snippet.title
    @youtube_id = youtube_search_list.items[random_number].id.video_id
    @text = "動画タイトル「#{youtube_title}」を取得しました."
  end

  def playlist_play(input)
    @video = Playlist.find_by(title: input)
    if @video
      @text = "プレイリスト「#{@video.title}」を再生します。" 
    else
      @text = "プレイリストに存在しないようです。" 
    end
  end

  def playlist_destroy(input)
    @destroy_video = Playlist.find_by(title: input)
    if @destroy_video
      @destroy_video.destroy
      @text = "「#{@destroy_video.title}」をプレイリストから削除しました。"
    else
      @text = "プレイリストに存在しないようです。"
    end
  end

  def youtube_add_playlist(video_id, video_title)
    @add_video = Playlist.new(video_id: video_id, title: video_title)
    if @add_video.save
      @text = "#{video_title}をプレイリストに追加しました。"
    end
  end
end