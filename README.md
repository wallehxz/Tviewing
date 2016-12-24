流畅的管理后台

自适应播放页面

用户行为分析统计

用户观看互动

更多资源

        if ($host != 'www.koogle.cc' ) {
            rewrite ^/(.*)$ https://www.koogle.cc/$1  permanent;
        }


        if ($request_uri ~  ^/show/(.*)$ ) {
            set $show "show";
        }

        if ($scheme = 'https') {
        }

        if ($show = "showhttps") {
           rewrite ^/(.*)$ http://www.koogle.cc/$1 permanent;
        }

      if ($request_uri !~ ^/show/(.*)$) {
          set $not_show "notshow";
      }

      if ($scheme = 'http') {
          set $not_show "${not_show}http";
      }

      if ($not_show = "notshowhttp") {
          rewrite ^/(.*)$ https://www.koogle.cc/$1 permanent;
      }
