module CountersHelper

  def counter_interpretation(input)
    input.gsub!(/[[:space:]]/, '')
    start_text = ["開始","かいし","スタート","すたーと"]
    stop_text = ["ストップ","停止","ていし","すとっぷ","終了","しゅうりょう"]
    search_text = ["時間","じかん"]
    all_text = ["全部","ぜんぶ"]
    if start_text.any? {|t| input.include?(t)}
      len = input.length
      if input.include? ("開始")
        word = input[len-len..len-3]
      elsif input.include? ("かいし")
        word = input[len-len..len-4]
      elsif ["スタート","すたーと"].any? {|t| input.include?(t)}
        word = input[len-len..len-5]
      end
      time_counter_start(word)
    elsif stop_text.any? {|t| input.include?(t)}
      len = input.length
      if ["停止","終了"].any? {|t| input.include?(t)}
        word = input[len-len..len-3]
      elsif input.include? ("しゅうりょう")
        word = input[len-len..len-7]
      elsif input.include? ("ていし")
        word = input[len-len..len-4]
      elsif ["ストップ","すとっぷ"].any? {|t| input.include?(t)}
        word = input[len-len..len-5]
      end
      time_counter_stop(word)
    elsif search_text.any? {|t| input.include?(t)}
      len = input.length
      if input.include? ("時間")
        word = input[len-len..len-3]
      elsif input.include? ("じかん")
        word = input[len-len..len-4]
      end
      counter_progress(word)
    elsif all_text.any? {|t| input.include?(t)}
      counter_all
    else
      @text = "対応していないメッセージです。"
    end
  end

  def time_counter_start(input)
    now_time = Time.now
    counter = Counter.new(name: input, start_time: now_time)
    if counter.save
      @text = "#{input}カウンターを開始します。"
    end
  end

  def time_counter_stop(input)
    now_time = Time.now
    counter = Counter.find_by(name: input, stop_time: nil)
    if counter
      counter.update!(stop_time: now_time)
      @text = "#{input}カウンターを停止しました。"
    end
  end

  def counter_all
    counters = Counter.all
    @texts = Array.new
    counters.each do |counter|
      if counter.stop_time.present?
        @texts << "測定終了：#{counter.name}カウンター"
      else
        @texts << "測定中：#{counter.name}カウンター"
      end
    end
  end

  def counter_progress(input)
    counter = Counter.find_by(name: input, stop_time: nil)
    if counter
      subtraction_time = Time.now - counter.start_time
      progress_time = subtraction_time.to_i
      if progress_time >= 86400
        day = progress_time/86400
        sub_day_time = progress_time%86400
        hours = sub_day_time/3600
        sub_hours_time = sub_day_time%3600
        minutes = sub_hours_time/60
        seconds = sub_hours_time%60
        @text = "#{counter.name}カウンター：#{day}日#{hours}時間#{minutes}分#{seconds}秒経過中"
      elsif progress_time >= 3600
        hours = progress_time/3600
        sub_hours_time = @progress_time%3600
        minutes = sub_hours_time/60
        seconds = sub_hours_time%60
        @text = "#{counter.name}カウンター：#{hours}時間#{minutes}分#{seconds}秒経過中"
      elsif progress_time >= 60
        minutes = progress_time/60
        seconds = progress_time%60
        @text = "#{counter.name}カウンター：#{minutes}分#{seconds}秒経過中"
      else
        @text = "#{counter.name}カウンター：#{progress_time}秒経過中"
      end
    else
      @text = "カウンターを取得できませんでした。"
    end
  end
end
