require File.expand_path('../../spec_helper', __FILE__)

module Pod::TrunkApp
  describe "Owner" do
    before do
      Mail::TestMailer.deliveries.clear
      @owner = Owner.create(:email => 'jenny@example.com', :name => 'Jenny')
    end

    it "coerces to YAML" do
      yaml = YAML.load(@owner.to_yaml)
      yaml.keys.sort.should == %w(created_at email id name)
    end

    it "finds itself with an email address" do
      owner = Owner.find_or_create_by_email(@owner.email)
      owner.should.not.be.new
      owner.email.should == @owner.email
    end

    it "creates itself with an email address" do
      email = 'janny@example.com'
      owner = Owner.find_or_create_by_email(email)
      owner.should.not.be.new
      owner.email.should == email
    end

    it "normalizes the email address when finding by email address" do
      owner = Owner.find_or_create_by_email(" #{@owner.email.upcase} ")
      owner.should.not.be.new
      owner.email.should == @owner.email
    end

    it "normalizes the email address when creating by email address" do
      email = 'janny@example.com'
      owner = Owner.find_or_create_by_email(" #{email.upcase} ")
      owner.should.not.be.new
      owner.email.should == email
    end

    it "sends an email to the email address on create" do
      mail = Mail::TestMailer.deliveries.last
      mail.to.should == [@owner.email]
      mail.subject.should == 'This is a test email'
      mail.body.decoded.should.include @owner.name
    end
  end
end