{
  plugins.bufferline = {
    enable = true;
    settings = {
      highlights = {
        buffer_selected = {
          underline = true;
          undercurl = false;
          italic = false;
          sp = "#b8bb26";
        };
        buffer_visible = {
          underline = true;
          undercurl = false;
          italic = false;
          sp = "#d79921";
        };
      };
      options = {
        separator_style = "thick";
        show_tab_indicators = true;
        show_buffer_close_icons = true;
        show_close_icon = false;
        color_icons = true;
        # This ensures the underline spans the full width of the tab
        #BG: Removed because it prevents tab names from de-duplicating
        #enforce_regular_tabs = true;
      };
    };
  };
}
