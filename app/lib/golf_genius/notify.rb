class GolfGenius::Notify

  attr_accessor :session
  attr_accessor :current_columns
  attr_accessor :employees
  attr_accessor :test_mode
  attr_accessor :beginning_of_week
  attr_accessor :end_of_week

  def initialize(testing = false)
    # Test Mode
    # Sends a test mail to all GolfGenius Employees
    self.test_mode = testing

    # Init GoogleDrive session from client_secrets
    self.session = GoogleDrive::Session.from_service_account_key("client_secret.json")
  end

  def run
    # Don't send reminders Sat and Sun
    return if !self.test_mode && [5, 6].include?(Date.today.wday)

    # Set the current week
    # If Today is Sunday, then we set the next week
    set_week

    # Ex: ['Vali', 'Rares', 'Dan', 'Ovidiu', 'Mircea', 'Adi', 'Dan', 'Vali', 'Rares', 'Rares']
    self.current_columns = get_spreadsheet

    # Return if we don't have columns from spreadsheet
    return if self.current_columns.blank?

    # Ex: ['Rares', 'Dan']
    self.employees = work_day_employees

    # Send notifications
    send_notifications
  end

  private

  # Gets the spreadsheet from GoogleDrive based on its key
  def get_spreadsheet
    begin
      return parse_spreadsheet(session.spreadsheet_by_key("1CR96shZ0bAyviDydUjGgGxmg6iVXSanh1dNrQ28AbY8"))
    rescue Google::Apis::ClientError => e
      Raven.capture_exception(e.message)
      return nil
    end
  end

  # Parse the spreadsheet
  def parse_spreadsheet(spreadsheet)
    # We get the first worksheet
    worksheet = spreadsheet.worksheets.first

    # Get the rows, skipping the first 105 rows
    worksheet.rows(ENV['SKIPPED_SPREADSHEET_ROWS'].to_i).each_with_index do |row, index|

      # Check if the row is valid
      # Valid means if the row represents the current week
      if row.first.present? && find_valid_row(row.first)
        # Return the valid row
        return row[1..10]
      end

    end

    # Handle users not found here
    Raven.capture_exception('No rows found in spreadsheet!')
    return nil

  end

  # Find valid row based on week
  def find_valid_row(week)
    week = week.split(' - ')

    begin
      week_start_day = Date.strptime(week[0].strip, "%d.%m.%y")
      week_end_day = Date.strptime(week[1].strip, "%d.%m.%y")
    rescue ArgumentError
      return false
    end

    return ( week_start_day == self.beginning_of_week ) && ( week_end_day == self.end_of_week )
  end

  # Find work day employees
  def work_day_employees
    all_week_employees = self.current_columns.each_slice(2).to_a

    return all_week_employees[Date.today.wday]
  end

  # Send notifications
  def send_notifications
    # In test mode we send a random notification to all users
    if self.test_mode
      GolfGenius::Employee.all.each do |employee|
        employee.notify("Testing feature, don't worry")
      end
    else
      hb_employee = GolfGenius::Employee.where('name ILIKE ?', "#{self.employees[0].downcase}%").first
      bugs_employee = GolfGenius::Employee.where('name ILIKE ?', "#{self.employees[1].downcase}%").first


      hb_employee.notify('honey badgers') if hb_employee.present?
      bugs_employee.notify('bugs') if bugs_employee.present?
    end
  end

  # Set the week
  def set_week
    if Date.today.wday == 0
      self.beginning_of_week = date_of_next('Monday')
      self.end_of_week = date_of_next('Friday')
    else
      self.beginning_of_week = Date.today.beginning_of_week
      self.end_of_week = Date.today.end_of_week - 2
    end
  end

  # Get the neext day based on it
  # Ex: Today is Monday (05.02.18), we want the date of the next 'Monday'
  # The function will return the next Monday date, (12.02.18)
  def date_of_next(day)
    date = Date.parse(day)
    delta = date > Date.today ? 0 : 7

    return date + delta
  end

end
