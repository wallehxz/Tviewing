var cuteslider3 = new Cute.Slider();
cuteslider3.setup("cuteslider_3" , "cuteslider_3_wrapper");
cuteslider3.api.addEventListener(Cute.SliderEvent.CHANGE_START, function(event){});
cuteslider3.api.addEventListener(Cute.SliderEvent.CHANGE_END, function(event){});
cuteslider3.api.addEventListener(Cute.SliderEvent.WATING, function(event){});
cuteslider3.api.addEventListener(Cute.SliderEvent.CHANGE_NEXT_SLIDE, function(event){});
cuteslider3.api.addEventListener(Cute.SliderEvent.WATING_FOR_NEXT, function(event){});