require 'spec_helper'

describe User do
  
  before do 
    @user = User.new(name: "Example User", email: "user@example.com",
                            password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should be_valid }

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

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

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before do
      @user = User.new(name: "Example User", email: "robert@example.com",
                       password: "foobar", password_confirmation: nil)
    end
    it { should_not be_valid }
  end

  describe "with a password that is too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of the authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end



end
