require 'spec_helper'

describe User do
 
  before { @user = User.new(name: "Example User", email: "user@example.com") }  

  subject { @user }

  it { should respond_to(:name) } 
  it { should respond_to(:email) } 
  it { should be_valid }

  describe "invalid when name is not present" do
    
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "invalid when email is not present" do
    
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "invalid when name is too long" do
     
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do

    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_addr|
        @user.email = invalid_addr
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    
    it "should be valid" do
      addresses = %w[user@foo.com A_US-ER@f.b.org first.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_addr|
        @user.email = valid_addr
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      duplicate_email_user = @user.dup 
      duplicate_email_user.email = @user.email.upcase
      duplicate_email_user.save
    end

    it { should_not be_valid }
  end


end
