class Widgets::Errors::CredentialsError < StandardError
  def initialize(msg = 'Invalid Credentials.')
    super(msg)
  end
end
