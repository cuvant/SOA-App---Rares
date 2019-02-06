class GolfGenius::Employee < ApplicationRecord

  validates :email, :name, :phone_number, presence: true

  def notify(job_type)
    text = "#{self.name} tomorrow #{Date.today + 1} you work #{job_type}, so be ready! At 8:00 AM, max 8:30 AM on Hipchat room: 'Golf Genius' the issues have to be posted. Good luck!"

    GolfNotificationsMailer.notify(self.email, text, job_type, self.name).deliver
    send_text_message(text)
  end

  private

  def send_text_message(body)
    twilio_client = Twilio::REST::Client.new

    begin
      twilio_client.api.account.messages.create(
        from: ENV['TWILIO_FROM'],
        to: "+4#{self.phone_number}",
        body: body
      )
    rescue Twilio::REST::RestError => e
      Raven.capture_exception(e.message)
    end
  end

end
