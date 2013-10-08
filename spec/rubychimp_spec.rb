require 'spec_helper'

describe Rubychimp, :vcr do

  let(:rubychimp) { Rubychimp.new("82d3dcabb0cd77925b861ae1e47c73d5-us7") }

  describe "#lists_id" do
    it "returns all lists ids" do
      expect(rubychimp.lists_id).to eql ["f694dc6d73", "d852f12b22"]
    end
  end

  describe "#unsubscribed_lists_id" do
    context "when email is present" do
      it "returns an array with all lists ids where user is not subscribed" do
        unsubscribed_lists_id = ["f694dc6d73"]
        expect(rubychimp.unsubscribed_lists_id("info@hashdog.com")).to eql unsubscribed_lists_id
      end
    end

    context "when email is not present" do
      it "returns an empty array" do
        expect(rubychimp.unsubscribed_lists_id([])).to eql []
      end
    end
  end

  describe "#lists_data" do
    context "when an array with ids is present" do
      it "returns requested lists ids and names" do
        list_data = [{ id:"d852f12b22", name: "test hashdog"}]
        expect(rubychimp.lists_data(["d852f12b22"])).to eql list_data
      end
    end

    context "when an array with ids is not present" do
      it "returns an empty array" do
        expect(rubychimp.lists_data).to eql []
      end
    end
  end

  describe "#subscribed_lists_data" do
    context "when email is present" do
      it "returns an array of hashes with all list ids and names where user is subscribed" do
        subscribed_lists = [ { id: "d852f12b22", name: "test hashdog"} ]
        expect(rubychimp.subscribed_lists_data("info@hashdog.com")).to eql subscribed_lists
      end
    end

    context "when email is not present" do
      it "returns an empty array" do
        expect(rubychimp.subscribed_lists_data).to eql []
      end
    end
  end

  describe "#unsubscribed_lists_data" do
    context "when email is present" do
      it "returns an array of hashes with all list ids and names where user is not subscribed" do
        unsubscribed_lists = [ { id: "f694dc6d73", name: "test 2 hashdog"} ]
        expect(rubychimp.unsubscribed_lists_data("info@hashdog.com")).to eql unsubscribed_lists
      end
    end

    context "when email is not present" do
      it "returns an empty array" do
        expect(rubychimp.unsubscribed_lists_data).to eql []
      end
    end
  end

  describe "#user_subscribe" do
    context "when list_id and email are present" do
      it "subscribe user to specified list" do
        expect(rubychimp.user_subscribe("d852f12b22", "team@hashdog.com")).to eql true
      end
    end

    context "when list_id and email ar not present" do
      it "returns false" do
        expect(rubychimp.user_subscribe).to eql false
      end
    end
  end

  describe "#user_unsubscribe" do
    context "when list_id and email are present" do
      it "subscribe user to specified list" do
        expect(rubychimp.user_unsubscribe("d852f12b22", "team@hashdog.com")).to eql true
      end
    end

    context "when list_id and email ar not present" do
      it "returns false" do
        expect(rubychimp.user_unsubscribe).to eql false
      end
    end
  end

  describe "#unsubscribe_all" do
    context "when list_id and email are present" do
      it "subscribe user to specified list" do
        expect(rubychimp.unsubscribe_all(["d852f12b22"], "info@hashdog.com")).to eql true
      end
    end

    context "when list_id and email ar not present" do
      it "returns false" do
        expect(rubychimp.unsubscribe_all).to eql false
      end
    end
  end

  describe "#error_messages" do
    it "returns error messages" do
      rubychimp.user_subscribe("c9356sd52ab8", "info@hashdog.com")
      expect(rubychimp.error_messages).to_not be_empty
    end
  end

  describe "#success?" do
    context "when no errors" do
      it "returns true" do
        rubychimp.user_subscribe("f694dc6d73", "info@hashdog.com")
        expect(rubychimp.success?).to eql true
      end
    end

    context "when errors" do
      it "returns false" do
        rubychimp.user_subscribe("f694dc6d73", "info@hashdog.com")
        expect(rubychimp.success?).to eql false
      end
    end
  end

  describe "#subscribed_lists_id" do
    context "when email is present" do
      it "returns an array with all lists ids where user is subscribed" do
        expect(rubychimp.subscribed_lists_id("info@hashdog.com")).to eql ["d852f12b22", "f694dc6d73"]
      end
    end

    context "when email is not present" do
      it "returns an empty array" do
        expect(rubychimp.subscribed_lists_id([])).to eql []
      end
    end
  end


end