module ViewInterface

  def prompt(text)
    @prompt.text = text
  end

  def show_input
    @enter_box.show
    @enter_button.show
  end

  def hide_input
    @enter_box.hide
    @enter_button.hide
  end

  def report(data)
    @report_box.text = "#{data}\n"
  end

  def append_report(data)
    string = @report_box.text
    string << "#{data}\n"
    @report_box.text = string
  end

  def display_job_info(job_no, release_letter)
    @job_no_display.text = job_no
    @release_display.text = release_letter
  end

end