// Element取得
    const get_element = {
        // フォーム関連取得
        get_form_element: ()=> {
            var text = document.getElementById("chat_input");
            var submit = document.getElementById("btn");
        },
        // マイク関連取得
        get_mike_element: ()=> {
            var start_btn = document.getElementById("mike_start");
            var stop_btn = document.getElementById("mike_stop");
        }
    };

    // 音声認識
    const mike = {
        btn_mike_start: ()=> {
            this.start_btn.onclick = () => {
                SpeechRecognition = webkitSpeechRecognition || SpeechRecognition;
                var input_recognition = new SpeechRecognition();

                input_recognition.start();
                this.stop_btn.onclick = () => {
                    input_recognition.stop();
                }

                input_recognition.onresult = (event) => {
                    this.text.value = event.results[0][0].transcript;
                    
                    var order_recognition = new SpeechRecognition();
                    order_recognition.start();

                    order_recognition.onresult = (event) => {
                        var order = event.results[0][0].transcript;
                        if(order == "よろしく"){
                            order_recognition.stop();
                            var chat_div = document.createElement("div");
                            var div_inner = document.createElement("p");
                            var user_text = document.createTextNode(this.text.value);
                            chat_div.setAttribute("class", "user-content");
                            div_inner.setAttribute("class", "user-text");
                            div_inner.appendChild(user_text);
                            chat_div.appendChild(div_inner);
                            this.container.appendChild(chat_div);
                            this.submit.click();
                        } else if (order == "取り消し"){
                            this.text.value = "";
                            this.start_btn.click();
                        }
                    }
                }

            }
        }
    }

