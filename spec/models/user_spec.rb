require 'spec_helper'

describe User do

  it "validates the presence of email" do
    u = User.new

    expect(u.valid?).to eq(false)
    expect(u.errors[:email]).to_not be_empty

    u.email = "email@example.com"
    u.valid?

    expect(u.errors[:email]).to be_empty
  end

  it "validates password confirmation" do
    u = User.new(password: "password",
                 password_confirmation: "notpassword")

    expect(u.valid?).to eq(false)
    expect(u.errors[:password]).to be_empty
    expect(u.errors[:password_confirmation]).to_not be_empty

    u = User.new(email: "email@example.com",
                 password: "password",
                 password_confirmation: "password")

    expect(u.valid?).to eq(true)
  end
end
