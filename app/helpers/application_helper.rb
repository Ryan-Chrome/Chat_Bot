module ApplicationHelper

  def sorting_operation(input)
    input.gsub!(/[[:space:]]/, '')
    sorting_text = ["カウンター","YouTube"]
    if sorting_text.any? {|t| input.include?(t)}
      if input.include? ("カウンター")
        @operator = "counter"
        @text = "カウンターオペレーターです。"
      elsif input.include? ("YouTube")
        @operator = "youtube"
        @text = "YouTubeオペレーター(検索)です。「〇〇探して」で動画を取得してきます。「プレイリスト」でプレイリストを呼び出します。"
      end
    else
      @text = "指定されたオペレーターは存在しません。"
    end
  end
end
